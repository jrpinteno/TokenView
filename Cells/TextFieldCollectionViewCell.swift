//
//  TextFieldCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {
	var onTextReturn: ((_ text: String) -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		addSubview(textField)
		textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
		textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		textField.delegate = self

		textField.onEmptyDelete = {
			print("On empty")
		}
	}


	// MARK: Lazy views

	private lazy var textField: EmptyAwareTextField = {
		let field = EmptyAwareTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.autocorrectionType = .no
		field.autocapitalizationType = .none
		field.placeholder = "Type here..."

		return field
	}()
}


extension TextFieldCollectionViewCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, !text.isEmpty else {
			return true
		}

		onTextReturn?(text)

		// TODO: call closure onReturn with text, validation is done other side
		textField.text = nil

		return false
	}
}
