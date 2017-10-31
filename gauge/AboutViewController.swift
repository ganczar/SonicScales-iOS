//
//  AboutViewController.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 12/05/2017.
//  Copyright © 2017 Sonic Scales. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
	@IBOutlet weak var aboutTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.automaticallyAdjustsScrollViewInsets = false;
		aboutTextView.scrollRangeToVisible(NSRange(location:0, length:0));
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
