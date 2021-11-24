//
//  TokenCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class TokenCollectionViewCell: UICollectionViewCell {
	// MARK: Properties
	var willBeRemoved: (() -> Void)?
	var willReplaceText: ((_ text: String) -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with text: String) {
		tokenLabel.text = text
	}

	private func setupView() {
		backgroundColor = .lightGray
		tokenLabel.textColor = .white

		addSubview(tokenLabel)
		tokenLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		tokenLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		tokenLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		tokenLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}


	// MARK: Overrides

	/// By default it is set to false, so we need to override in order to
	/// handle selection and configuration in becoming/resigning first responder
	override var canBecomeFirstResponder: Bool {
		return true
	}

	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected ? .blue : .lightGray
		}
	}

	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()

		isSelected = true

		return true
	}

	override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()

		isSelected = false

		return true
	}


	// MARK: Lazy views

	private lazy var tokenLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()
}


extension TokenCollectionViewCell: UIKeyInput {
	var hasText: Bool {
		return false
	}

	func insertText(_ text: String) {
		willReplaceText?(text)
	}

	func deleteBackward() {
		willBeRemoved?()
	}
}
