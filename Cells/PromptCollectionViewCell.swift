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

	private func setupView() {
		isUserInteractionEnabled = false
		backgroundColor = .darkGray

		addSubview(promptLabel)
		promptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		promptLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		promptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
		promptLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
	}


	// MARK: Lazy views

	private lazy var promptLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()
}
