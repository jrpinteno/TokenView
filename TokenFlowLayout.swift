//
//  TokenFlowLayout.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 23.11.2021.
//

import UIKit

protocol TokenFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
	/// Asks the delegate for the position of the TextField Cell
	///
	/// - Returns: IndexPath of TextField cell
	func textFieldIndexPath(in collectionView: UICollectionView) -> IndexPath

	func collectionView(_ collectionView: UICollectionView, didChangeHeight height: CGFloat)
}


/// Custom collection flow layout to handle left-aligned tags.
class TokenFlowLayout: UICollectionViewFlowLayout {
	weak var delegate: TokenFlowLayoutDelegate? = nil

	override init() {
		super.init()

		sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		minimumLineSpacing = 4.0
		minimumInteritemSpacing = 4.0
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
			return nil
		}

		var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []

		for attribute in layoutAttributes {
			if attribute.representedElementCategory == .cell, let newAttributes = layoutAttributesForItem(at: attribute.indexPath) {
				newLayoutAttributes.append(newAttributes)
			} else {
				newLayoutAttributes.append(attribute)
			}
		}

		return newLayoutAttributes
	}


	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let collectionView = collectionView else { return nil }

		// We make a copy of the attribute to avoid cache mismatch (and warning)
		guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
			return nil
		}

		// TODO: directional insets
		// First item only requires having the inset left
		if indexPath.item == 0 {
			layoutAttributes.frame.origin.x = sectionInset.left
			return layoutAttributes
		}

		let width = collectionView.bounds.width
		let availableWidth = width - minimumInteritemSpacing
		print(availableWidth)
		if let previousAttributes = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: 0)),
			layoutAttributes.frameInSameLine(as: previousAttributes) {
			layoutAttributes.frame.origin.x = previousAttributes.frame.origin.x + previousAttributes.frame.width + minimumInteritemSpacing
		}

		// If the cell to layout corresponds to the TextField, it will be stretched to fill collection width
		if indexPath == delegate?.textFieldIndexPath(in: collectionView) {
			let width = collectionView.bounds.width - layoutAttributes.frame.origin.x - sectionInset.right
			layoutAttributes.frame.size.width = width
		}

		return layoutAttributes
	}
}


extension UICollectionViewLayoutAttributes {
	fileprivate func frameInSameLine(as attributes: UICollectionViewLayoutAttributes) -> Bool {
		let fullLineFrame = CGRect(x: -.infinity, y: frame.origin.y, width: .infinity, height: size.height)

		return fullLineFrame.intersects(attributes.frame)
	}
}
