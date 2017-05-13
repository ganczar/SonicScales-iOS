//
//  SettingsTableViewController.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 16/12/15.
//  Copyright © 2015 Sonic Scales. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var densityTextField: UITextFieldWithoutCaret!;
	@IBOutlet weak var diameterTextField: UITextFieldWithoutCaret!;
	@IBOutlet weak var lengthTextField: UITextFieldWithoutCaret!;
	@IBOutlet weak var forceArmTextField: UITextFieldWithoutCaret!;
	@IBOutlet weak var resistanceArmTextField: UITextFieldWithoutCaret!;

	var densityPicker: UIPickerView!;
	var diameterPicker: UIPickerView!;
	var lengthPicker: UIPickerView!;
	var forceArmPicker: UIPickerView!;
	var resistanceArmPicker: UIPickerView!;

	var settings: Settings!;

	let densityArray = [Int](5000...10000);
	let diameterArray = [Int](8...84);
	let lengthArray = [Int](100...3000);
	let forceArmArray = [Int](1...100);
	let resistanceArmArray = [Int](1...100);

	override func viewDidLoad() {
		super.viewDidLoad();

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.handleTap));
		tapGestureRecognizer.cancelsTouchesInView = false;
		self.view.addGestureRecognizer(tapGestureRecognizer);

		let context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext;
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>();
		let entityDescription = NSEntityDescription.entity(forEntityName: "Settings", in: context);
		fetchRequest.entity = entityDescription;
		do {
			settings = try context.fetch(fetchRequest)[0] as! Settings;
		} catch {
			let fetchError = error as NSError;
			print(fetchError);
		}

		densityPicker = createPicker();
		densityPicker.selectRow(densityArray.index(of: Int(settings.density))!, inComponent: 0, animated: false);
		
		densityTextField.inputView = densityPicker;
		densityTextField.inputAccessoryView = createPickerToolbar("String's density [kg/m³]");
		densityTextField.delegate = self;
		densityTextField.selectedTextRange = nil;
		densityTextField.text = String(Int(settings.density));

		diameterPicker = createPicker();
		diameterPicker.selectRow(diameterArray.index(of: Int(settings.stringDiameter))!, inComponent: 0, animated: false);
		
		diameterTextField.inputView = diameterPicker;
		diameterTextField.inputAccessoryView = createPickerToolbar("String's diameter [1/1000 inch]");
		diameterTextField.delegate = self;
		diameterTextField.selectedTextRange = nil;
		diameterTextField.text = String(Int(settings.stringDiameter));

		lengthPicker = createPicker();
		lengthPicker.selectRow(lengthArray.index(of: Int(settings.stringLength))!, inComponent: 0, animated: false);
		
		lengthTextField.inputView = lengthPicker;
		lengthTextField.inputAccessoryView = createPickerToolbar("String's length [mm]");
		lengthTextField.delegate = self;
		lengthTextField.selectedTextRange = nil;
		lengthTextField.text = String(Int(settings.stringLength));

		forceArmPicker = createPicker();
		forceArmPicker.selectRow(forceArmArray.index(of: Int(settings.forceArmLength))!, inComponent: 0, animated: false);
		
		forceArmTextField.inputView = forceArmPicker;
		forceArmTextField.inputAccessoryView = createPickerToolbar("Force arm's length [length unit]");
		forceArmTextField.delegate = self;
		forceArmTextField.selectedTextRange = nil;
		forceArmTextField.text = String(Int(settings.forceArmLength));

		resistanceArmPicker = createPicker();
		resistanceArmPicker.selectRow(resistanceArmArray.index(of: Int(settings.resistanceArmLength))!, inComponent: 0, animated: false);
		
		resistanceArmTextField.inputView = resistanceArmPicker;
		resistanceArmTextField.inputAccessoryView = createPickerToolbar("Resistance arm's length [length unit]");
		resistanceArmTextField.delegate = self;
		resistanceArmTextField.selectedTextRange = nil;
		resistanceArmTextField.text = String(Int(settings.resistanceArmLength));

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning();
	}
	
	func handleTap() {
		self.view.endEditing(true);
	}

	fileprivate func createPicker() -> UIPickerView {
		let picker = UIPickerView();
		picker.backgroundColor = .white;
		picker.dataSource = self;
		picker.delegate = self;
		return picker;
	}
	
	fileprivate func createPickerToolbar(_ title: String) -> UIToolbar {
		let toolBar = UIToolbar();
		toolBar.barStyle = UIBarStyle.default;
		toolBar.isTranslucent = true;
		toolBar.tintColor = .darkGray;
		toolBar.sizeToFit();
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SettingsTableViewController.handleTap));
		let titleButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: nil);
		titleButton.isEnabled = false;
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
		toolBar.setItems([titleButton, spaceButton, doneButton], animated: false);
		toolBar.isUserInteractionEnabled = true;
		return toolBar;
	}

	// MARK: - Picker view data source
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int
	{
		return 1;
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	{
		if (pickerView == densityPicker) {
			return densityArray.count;
		} else if (pickerView == diameterPicker) {
			return diameterArray.count;
		} else if (pickerView == lengthPicker) {
			return lengthArray.count;
		} else if (pickerView == forceArmPicker) {
			return forceArmArray.count;
		} else if (pickerView == resistanceArmPicker) {
			return resistanceArmArray.count;
		} else {
			return 0;
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var label: UILabel? = view as? UILabel;
		if (label == nil) {
			label = UILabel();//UILabel(frame: CGRectMake(20, 0, 60, 30));
			label?.font = UIFont.systemFont(ofSize: 25);
			label?.textAlignment = NSTextAlignment.center;
		}

		if (pickerView == densityPicker) {
			label?.text = String(densityArray[row]);
		} else if (pickerView == diameterPicker) {
			label?.text = String(diameterArray[row]);
		} else if (pickerView == lengthPicker) {
			label?.text = String(lengthArray[row]);
		} else if (pickerView == forceArmPicker) {
			label?.text = String(forceArmArray[row]);
		} else if (pickerView == resistanceArmPicker) {
			label?.text = String(resistanceArmArray[row]);
		}
		
		return label!;
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		if (pickerView == densityPicker) {
			densityTextField.text = String(pickerView.selectedRow(inComponent: 0) + densityArray[0]);
		} else if (pickerView == diameterPicker) {
			diameterTextField.text = String(pickerView.selectedRow(inComponent: 0) + diameterArray[0]);
		} else if (pickerView == lengthPicker) {
			lengthTextField.text = String(pickerView.selectedRow(inComponent: 0) + lengthArray[0]);
		} else if (pickerView == forceArmPicker) {
			forceArmTextField.text = String(pickerView.selectedRow(inComponent: 0) + forceArmArray[0]);
		} else if (pickerView == resistanceArmPicker) {
			resistanceArmTextField.text = String(pickerView.selectedRow(inComponent: 0) + resistanceArmArray[0]);
		}
	}
	
	
	// MARK: - Text field delegate
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return false;
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		return true;
	}

	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false;
	}

	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3;
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
		case 1:
			return 2
		case 2:
			return 2
		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerLabel: UILabel = UILabel()
		headerLabel.frame = CGRect(x: 10, y: 1, width: 320, height: 20);
		headerLabel.font = UIFont.systemFont(ofSize: 12)
		headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
		headerLabel.textColor = UIColor.darkGray
		let headerView: UIView = UIView()
		headerView.backgroundColor = UIColor.groupTableViewBackground
		headerView.alpha = 0.5
		headerView.addSubview(headerLabel)
		return headerView;
	}

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil);
	}

	@IBAction func done(_ sender: UIBarButtonItem) {

		settings.density = Double(densityPicker.selectedRow(inComponent: 0) + densityArray[0]) as Double;
		settings.stringDiameter = Double(diameterPicker.selectedRow(inComponent: 0) + diameterArray[0]) as Double;
		settings.stringLength = Double(lengthPicker.selectedRow(inComponent: 0) + lengthArray[0]) as Double;
		settings.forceArmLength = Double(forceArmPicker.selectedRow(inComponent: 0) + forceArmArray[0]) as Double;
		settings.resistanceArmLength = Double(resistanceArmPicker.selectedRow(inComponent: 0) + resistanceArmArray[0]) as Double;

		(UIApplication.shared.delegate as! AppDelegate).saveContext();

		self.dismiss(animated: true, completion: nil);
	}
}
