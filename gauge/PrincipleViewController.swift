//
//  PrincipleViewController.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 13/05/2017.
//  Copyright © 2017 Sonic Scales. All rights reserved.
//

import UIKit

class PrincipleViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var stepsScrollView: UIScrollView!
	@IBOutlet weak var stepsPageControl: UIPageControl!

	let step1 = ["description": "1. Place the weight on the scale", "image": "Step1"];
	let step2 = ["description": "2. Strum the string", "image": "Step2"];
	let step3 = ["description": "3. Get the result", "image": "Step3"];

	var stepsArray = [Dictionary<String, String>]();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.automaticallyAdjustsScrollViewInsets = false;

		stepsArray = [step1, step2, step3];
		stepsScrollView.delegate = self;
		stepsScrollView.isPagingEnabled = true;
		stepsScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(stepsArray.count), height: 350)
		stepsScrollView.showsHorizontalScrollIndicator = false;
		loadSteps();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let page = Int(stepsScrollView.contentOffset.x / stepsScrollView.frame.size.width);
		stepsPageControl.currentPage = page;
	}

	func loadSteps() {
		for (index, step) in stepsArray.enumerated() {
			if let stepView = Bundle.main.loadNibNamed("Step", owner: nil, options: nil)?.first as? StepView {
				stepView.stepDescriptionLabel.text = step["description"];
				stepView.stepImageView.image = UIImage(named: step["image"]!);

				stepsScrollView.addSubview(stepView);
				stepView.frame.size.width = self.view.bounds.size.width;
				stepView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width;
			}
		}
	}

}
