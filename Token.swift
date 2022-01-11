//
//  Token.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 11.1.2022.
//

import Foundation

protocol Tokenizable: Equatable {
	var key: String { get }
	var displayValue: String { get }

	// TODO: Add auxiliary image as optional
}

struct Token: Tokenizable {
	var key: String
	var displayValue: String {
		return value ?? key
	}

	private var value: String?

	init(key: String, displayValue: String? = nil) {
		self.key = key
		value = displayValue
	}
}
