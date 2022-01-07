//
//  TextFieldCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

fileprivate extension Selector {
	static let textChanged = #selector(TextFieldCollectionViewCell.textChanged(_:))
}

class TextFieldCollectionViewCell: UICollectionViewCell {
	// MARK: Properties

	/// Closure called when inner textfield returns
	var onTextReturn: ((_ text: String) -> Bool)?

	/// Closure called when textfield is trying to backwards delete and is empty
	var onEmptyDelete: (() -> Void)?

	/// Closure called when textfield text has changed
	var onTextChanged: ((_ text: String) -> Bool)?

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

		textField.addTarget(self, action: .textChanged, for: .editingChanged)
	}

	override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}


	// MARK: Lazy views

	private lazy var textField: EmptyAwareTextField = {
		let field = EmptyAwareTextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.keyboardType = .emailAddress
		field.autocorrectionType = .no
		field.autocapitalizationType = .none
		field.placeholder = "Type here..."

		return field
	}()
}


// MARK: UITextFieldDelegate methods
extension TextFieldCollectionViewCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, !text.isEmpty else {
			return true
		}

		if onTextReturn?(text) == true {
			textField.text = nil
		}

		return false
	}

	@objc func textChanged(_ textField: UITextField) {
		guard let text = textField.text else {
			return
		}

		if onTextChanged?(text) == true {
			textField.text = nil
		}
	}
}
