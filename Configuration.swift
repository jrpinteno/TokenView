//
//  Configuration.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 13.12.2021.
//

import UIKit

enum Configuration {
	enum Style {
		struct Token: TokenStyle {
			var backgroundColor: UIColor = .lightGray
			var textColor: UIColor = .white
			var cornerRadius: CGFloat = 4.0

			var contentInset: UIEdgeInsets = .init(top: 2, left: 4, bottom: 2, right: 4)
			var font: UIFont = .systemFont(ofSize: 18.0)
		}

		struct Prompt: TokenStyle {
			var backgroundColor: UIColor = .darkGray
			var cornerRadius: CGFloat = 0
			var contentInset: UIEdgeInsets = .init(top: 2, left: 4, bottom: 2, right: 4)

			var textColor: UIColor = .black
			var font: UIFont = .systemFont(ofSize: 18.0)
		}

		static var font: UIFont = .systemFont(ofSize: 18.0)
	}
}
