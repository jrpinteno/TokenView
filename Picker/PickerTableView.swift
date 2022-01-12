//
//  PickerTableView.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 10.1.2022.
//

import UIKit

protocol PickerTableViewDelegate: UITableViewDelegate {
	func tableView(_ view: UITableView, didUpdateContentSize contentSize: CGSize)
}

class PickerTableView: UITableView {
	override func reloadData() {
		super.reloadData()

		invalidateIntrinsicContentSize()
	}

	override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()

			if oldValue != contentSize, let delegate = delegate as? PickerTableViewDelegate {
				delegate.tableView(self, didUpdateContentSize: contentSize)
			}
		}
	}

	override var intrinsicContentSize: CGSize {
		layoutIfNeeded()

		return contentSize
	}
}
