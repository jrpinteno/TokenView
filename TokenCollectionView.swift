//
//  TokenCollectionView.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

/// CollectionView will host a PromptLabel (unique), Tags (already recognized entry) and a
/// UITextField from which to enter new tags
class TokenCollectionView: UICollectionView {
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func reloadData() {
		super.reloadData()

		invalidateIntrinsicContentSize()
	}

	override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}

	override var intrinsicContentSize: CGSize {
		layoutIfNeeded()

		return contentSize
	}

	private func setupView() {
		layer.borderColor = UIColor.black.cgColor

		register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: TextFieldCollectionViewCell.reuseIdentifier)
		register(TokenCollectionViewCell.self, forCellWithReuseIdentifier: TokenCollectionViewCell.reuseIdentifier)
		register(PromptCollectionViewCell.self, forCellWithReuseIdentifier: PromptCollectionViewCell.reuseIdentifier)
	}
}
