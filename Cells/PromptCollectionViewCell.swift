//
//  PromptCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class PromptCollectionViewCell: UICollectionViewCell {
	var text: String? {
		get {
			return promptLabel.text
		}

		set {
			promptLabel.text = newValue
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView(with style: TokenStyle = DefaultPromptStyle()) {
		isUserInteractionEnabled = false
		backgroundColor = style.backgroundColor

		promptLabel.textColor = style.textColor
		promptLabel.layer.cornerRadius = style.cornerRadius
		promptLabel.font = style.font

		contentView.addSubview(promptLabel)
		promptLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: style.contentInset.left).isActive = true
		promptLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: style.contentInset.top).isActive = true
		promptLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -style.contentInset.right).isActive = true
		promptLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -style.contentInset.bottom).isActive = true
	}


	// MARK: Lazy views

	private lazy var promptLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()
}
