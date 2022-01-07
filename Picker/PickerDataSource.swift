//
//  PickerDataSource.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 7.1.2022.
//

import UIKit

class PickerDataSource: NSObject, UITableViewDataSource {
	private var items: [Pickable]
	var pattern: String = ""

	init(items: [Pickable]) {
		self.items = items
	}

	func items(with pattern: String = "") -> [Pickable] {
		return items.filter { item in
			return item.contains(pattern)
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items(with: self.pattern).count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.reuseIdentifier, for: indexPath) as! PickerCell

		let item = items(with: self.pattern)[indexPath.item]
		cell.populateCell(with: item)

		return cell
	}
}
