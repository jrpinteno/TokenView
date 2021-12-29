//
//  PickerViewController.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 22.12.2021.
//

import UIKit

extension PickerCell: ReusableCell {}

class PickerViewController: UITableViewController {
	var pattern: String = "" {
		didSet {
			tableView.reloadData()
		}
	}

	var dataSource: PickerDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(PickerCell.self, forCellReuseIdentifier: PickerCell.reuseIdentifier)
	}


	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource?.items(with: pattern).count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.reuseIdentifier, for: indexPath) as! PickerCell

		if let item = dataSource?.items(with: pattern)[indexPath.item] {
			cell.populateCell(with: item)
		}

		return cell
	}
}
