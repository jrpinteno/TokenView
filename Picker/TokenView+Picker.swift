//
//  TokenView+Picker.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 11.1.2022.
//

import UIKit

// MARK: Picker methods
extension TokenView {
	/// Shows selection picker
	///
	/// - Parameter pattern: Search pattern as criteria to show elements in picker
	func showPicker(for pattern: String) {
		guard !pattern.isEmpty else {
			hidePicker()
			return
		}

		// TODO: Call delegate to check data and return
		// guard delegate.filterpattern...

		if pickerView.window == nil {
			addSubview(pickerView)
			pickerHeightConstraint = pickerView.heightAnchor.constraint(equalToConstant: 0)
			pickerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
			pickerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
			pickerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
			pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

			pickerHeightConstraint.isActive = true
		}

		if pickerView.isHidden {
			pickerView.isHidden = false
		}

		pickerDataSource?.pattern = pattern
		pickerView.reloadData()
	}

	/// Hides selection picker
	func hidePicker() {
		pickerView.isHidden = true
	}
}
