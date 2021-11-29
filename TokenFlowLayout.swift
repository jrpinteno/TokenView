//
//  TokenFlowLayout.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

/// Custom collection flow layout to handle left-aligned tags.
class TokenFlowLayout: UICollectionViewFlowLayout {
	// TODO: Should be configurable
	/// Space between cells in the collectionView
	private let cellPadding: CGFloat = 8.0

	override init() {
		super.init()

		sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
			return nil
		}

		var leftMargin = sectionInset.left
		var maxY: CGFloat = 0.0

		for attribute in layoutAttributes {
			if attribute.frame.origin.y >= maxY {
				leftMargin = sectionInset.left
			}

			attribute.frame.origin.x = leftMargin
			leftMargin += attribute.frame.width + cellPadding
			maxY = max(attribute.frame.maxY, maxY)
		}

		return layoutAttributes
	}
}
