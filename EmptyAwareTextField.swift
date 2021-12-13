//
//  EmptyAwareTextField.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

/// Subclass of `UITextField` that detects when backwards delete
/// is done to an empty textfield and, if present, calls closure
class EmptyAwareTextField: UITextField {
	/// Closure called when trying to delete an empty textfield
	var onEmptyDelete: (() -> Void)?

	override func deleteBackward() {
		guard let text = text, text.isEmpty else {
			super.deleteBackward()

			return
		}

		// TODO: Is it necessary to call super on empty?
		onEmptyDelete?()
	}
}
