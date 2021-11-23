//
//  TokenCollectionViewCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

class TokenCollectionViewCell: UICollectionViewCell {
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
		addSubview(tokenLabel)
		tokenLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		tokenLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		tokenLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		tokenLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	// MARK: Lazy views

	private lazy var tokenLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .lightGray

		return label
	}()
}
