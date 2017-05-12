//
//  GaugeViewController.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 13/12/15.
//  Copyright © 2015 Sonic Scales. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox.AudioServices

class GaugeViewController: UIViewController, EZMicrophoneDelegate, EZAudioFFTDelegate {
	
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var maxFrequencyLabel: UILabel!
	@IBOutlet weak var magnitudeLabel: UILabel!
	@IBOutlet weak var zeroButton: UIButton!
	@IBOutlet weak var unitControl: UISegmentedControl!
	
	var microphone: EZMicrophone!;
	var fft: EZAudioFFTRolling!;
	
	var gravitionalAcceleration: Double!; // [m/s²]
	var linearDensity: Double!; // [kg/m]
	var stringLength: Double!;
	var forceArmLength: Double!;
	var resistanceArmLength: Double!;
	
	var unitRatio: Double!;
	var fractionalDigits: UInt8!;
	
	var currentValue: Double!;
	var zeroAdjustment: Double = 0;
	
	var settings: Settings!;
	
	override func viewDidLoad() {
		super.viewDidLoad();

		let context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext;
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>();
		let entityDescription = NSEntityDescription.entity(forEntityName: "Settings", in: context);
		fetchRequest.entity = entityDescription;
		do {
			let settingsArray: [Settings] = try context.fetch(fetchRequest) as! [Settings];
			if (settingsArray.count > 0) {
				settings = settingsArray[0];
			} else {
				settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context) as? Settings;
				
				// defaults
				settings.density = 7850;
				settings.stringDiameter = 21;
				settings.stringLength = 220;
				settings.forceArmLength = 22;
				settings.resistanceArmLength = 4;
				do {
					try context.save()
				} catch _ as NSError {
					// TODO: Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					//println("Unresolved error \(error), \(error.userInfo)")
					abort();
				}
			}
		} catch {
		}
		
		// TODO: move to settings
		unitControl.selectedSegmentIndex = 0;
		updateUnits();
		
		zeroButton.setTitleColor(UIColor.darkText, for: UIControlState());
		zeroButton.setTitleColor(UIColor.lightGray, for: UIControlState.disabled);
		zeroButton.layer.borderWidth = 1.0;
		zeroButton.layer.masksToBounds = true;
		zeroButton.layer.cornerRadius = 5.0;
		
		let audioSession: AVAudioSession = AVAudioSession.sharedInstance();
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord);
			try audioSession.setActive(true);
		} catch _ {
		}
		
		microphone = EZMicrophone(delegate: self);
		fft = EZAudioFFTRolling(windowSize: 16384, sampleRate: Float(microphone.audioStreamBasicDescription().mSampleRate), delegate: self);
		microphone.startFetchingAudio();
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning();
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// TODO: 9.78-9.83 - estimate based on GPS coordinates or measure using accelerometer
		gravitionalAcceleration = 9.80665;
		stringLength = settings.stringLength;
		forceArmLength = settings.forceArmLength;
		resistanceArmLength = settings.resistanceArmLength;
		linearDensity = settings.density * Double.pi * pow((25.4 * settings.stringDiameter / 1000 / 1000) / 2, 2);
	}

	fileprivate var decimalFormat: String {
		get {
			return "%.\(fractionalDigits.description)f";
		}
	}

	fileprivate func calculateWeight(_ frequency: Double) -> Double {
		return unitRatio * (resistanceArmLength / forceArmLength) * 4 * linearDensity * pow(stringLength / 1000, 2) * pow(frequency, 2) / gravitionalAcceleration;
	}

	fileprivate func updateUnits() {
		switch unitControl.selectedSegmentIndex {
		case 0: // [g]
			unitRatio = 1000;
			fractionalDigits = 0;
			break;
		case 1: // [kg]
			unitRatio = 1;
			fractionalDigits = 3;
			break;
		case 2: // [oz]
			unitRatio = 35.2739619;
			fractionalDigits = 1;
			break;
		case 3: // [lbs]
			unitRatio = 2.20462262;
			fractionalDigits = 2;
			break;
		default:
			break;
		}
	}

	// MARK: EZMicrophoneDelegate

	func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
		fft.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize);
	}
	
	// MARK: EZAudioFFTDelegate
	
	func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>, bufferSize: vDSP_Length) {
		
		var weightString: String = "-";
		var frequencyString: String = "-";
		var magnitudeString: String = "-∞";
		var buttonColor: CGColor = UIColor.lightGray.cgColor;
		var buttonEnabled: Bool = false;

		let maxFrequency: Double = Double(fft.maxFrequency);
		let magnitude: Float = (20 * log10f(fft.maxFrequencyMagnitude));

		DispatchQueue.main.async(execute: { () -> Void in
			if (magnitude > -90) {
				self.currentValue = self.calculateWeight(maxFrequency);
				weightString = String(format: self.decimalFormat, self.currentValue - self.zeroAdjustment);
				frequencyString = String(format: "%.1f", maxFrequency);
				magnitudeString = String(format: "%.0f", magnitude);
				buttonEnabled = true;
				buttonColor = UIColor.darkText.cgColor;
			}
			self.weightLabel.text = weightString;
			self.maxFrequencyLabel.text = "\(frequencyString) Hz";
			self.magnitudeLabel.text = "\(magnitudeString) dB";
			self.zeroButton.isEnabled = buttonEnabled;
			self.zeroButton.layer.borderColor = buttonColor;
		});
	}
	
	@IBAction func zero(_ sender: UIButton) {
		zeroAdjustment = currentValue;
	}

	@IBAction func unitChanged(_ sender: UISegmentedControl) {
		updateUnits();
	}
}

