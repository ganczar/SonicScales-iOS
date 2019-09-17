//
//  UITextFieldWithoutCaret.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 27/12/15.
//  Copyright © 2015 Sonic Scales. All rights reserved.
//

import UIKit

class UITextFieldWithoutCaret: UITextField {
	
	override func caretRect(for position: UITextPosition) -> CGRect {
		return CGRect.zero
	}
	
	override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		return [AnyObject]() as! [UITextSelectionRect]
	}
}
