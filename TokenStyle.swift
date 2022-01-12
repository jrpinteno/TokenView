//
//  TokenStyle.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 2.12.2021.
//

import UIKit

protocol TokenStyle {
	var backgroundColor: UIColor { get set }
	var cornerRadius: CGFloat { get set }
	var contentInset: UIEdgeInsets { get set }
	var textColor: UIColor { get set }
	var font: UIFont { get set }
}


struct DefaultStyle: TokenStyle {
	var backgroundColor: UIColor = .lightGray
	var textColor: UIColor = .white
	var cornerRadius: CGFloat = 4.0

	var contentInset: UIEdgeInsets = .init(top: 2, left: 4, bottom: 2, right: 4)
	var font: UIFont = .systemFont(ofSize: 14.0)
}

struct DefaultPromptStyle: TokenStyle {
	var backgroundColor: UIColor = .clear
	var cornerRadius: CGFloat = 0
	var contentInset: UIEdgeInsets = .init(top: 2, left: 0, bottom: 2, right: 0)

	var textColor: UIColor = .lightGray
	var font: UIFont = .systemFont(ofSize: 14.0)
}
