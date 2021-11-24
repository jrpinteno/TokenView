//
//  TextFieldCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {
	// MARK: Properties

	/// Closure called when inner textfield returns
	var onTextReturn: ((_ text: String) -> Void)?

	/// Closure called when textfield is trying to backwards delete and is empty
	var onEmptyDelete: (() -> Void)?

	/// Helper to get/set text in the `UITextField`
	var text: String? {
		get {
			return textField.text
		}

		set {
			textField.text = newValue
		}
	}


	// MARK: -

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

		textField.onEmptyDelete = { [weak self] in
			self?.onEmptyDelete?()
		}
	}

	override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
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
