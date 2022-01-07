//
//  Pickable.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 22.12.2021.
//

import UIKit

protocol Pickable {
	var title: String { get }
	var subtitle: String? { get }
	var image: UIImage? { get }

	func contains(_ pattern: String) -> Bool
}
