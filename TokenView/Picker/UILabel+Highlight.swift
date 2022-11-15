//
//  UILabel+Highlight.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 21.2.2022.
//

import UIKit

extension UILabel {
	func highlight(_ pattern: String) {
		guard let labelText = text else {
			return
		}

		let mutableAttributed = NSMutableAttributedString(string: labelText)
		// TODO: Should check diacriticInsensitive as well
		let patternRange = (labelText as NSString).range(of: pattern, options: .caseInsensitive)

		mutableAttributed.addAttributes([
			.foregroundColor: UIColor.black
		], range: patternRange)

		attributedText = mutableAttributed
	}
}
