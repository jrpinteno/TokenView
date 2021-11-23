//
//  TextFieldCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		addSubview(textField)
		textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		textField.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
		textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
	}


	// MARK: Lazy views

	private lazy var textField: UITextField = {
		let field = UITextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.autocorrectionType = .no
		field.autocapitalizationType = .none
		field.placeholder = "Type here..."

		return field
	}()
}
