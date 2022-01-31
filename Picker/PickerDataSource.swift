//
//  PickerDataSource.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 7.1.2022.
//

import UIKit

protocol PickerDataSourceDelegate: AnyObject {
	func dataSource(_ dataSource: PickerDataSource, patternNotFound pattern: String)
}

class PickerDataSource: NSObject, UITableViewDataSource {
	private var items: [Pickable]
	weak var delegate: PickerDataSourceDelegate? = nil

	var pattern: String = "" {
		didSet {
			if filteredItems.isEmpty {
				delegate?.dataSource(self, patternNotFound: pattern)
			}
		}
	}

	init(items: [Pickable]) {
		self.items = items
	}

	var filteredItems: [Pickable] {
		return items.filter { item in
			return item.contains(pattern)
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.reuseIdentifier, for: indexPath) as! PickerCell

		let item = filteredItems[indexPath.item]
		cell.populateCell(with: item)

		return cell
	}
}
