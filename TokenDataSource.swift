//
//  TokenDataSource.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

class TokenDataSource: NSObject {
	private var tokens: [String] = ["Europa", "s’ha", "convertit", "novament", "en", "l’epicentre", "mundial",
											  "de", "la", "pandèmia", "covid"]

	// MARK: Token operations

	/// Appends a token to the token list
	///
	/// - Parameter token: Token to be appended
	func append(token: String) {
		tokens.append(token)
	}

	/// Finds `IndexPath` for a given token
	///
	/// - Parameter token: Token
	/// - Returns: `IndexPath` for the first appearance of the given token
	func indexPathFor(token: String) -> IndexPath? {
		for i in 0 ..< tokens.count {
			if token == tokens[i] {
				return IndexPath(item: i, section: 0)
			}
		}

		return nil
	}

	/// Removes the token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position of the token to be removed
	func removeToken(at indexPath: IndexPath) {
		tokens.remove(at: indexPath.item)
	}

	/// Identifier of reusable cell to be used at a given `IndexPath`
	///
	/// - Parameter indexPath: IndexPath of cell
	///
	/// - Returns: Cell identifier
	private func identifier(forCellAtIndexPath indexPath: IndexPath) -> String {
		switch indexPath.item {
			case tokens.count:
				return "TextFieldCollectionViewCell"

			default:
				return "TokenCollectionViewCell"
		}
	}
}


extension TokenDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Amount of token tags + textField

		return tokens.count + 1
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(forCellAtIndexPath: indexPath), for: indexPath)

		switch cell {
			case let tokenCell as TokenCollectionViewCell:
				let token = tokens[indexPath.item]
				tokenCell.configure(with: token)
				tokenCell.willBeRemoved = { [weak self] in
					guard let self = self else { return }

					if let removedIndexPath = self.indexPathFor(token: token) {
						self.removeToken(at: removedIndexPath)
						collectionView.deleteItems(at: [removedIndexPath])
					}
				}

			case let textFieldCell as TextFieldCollectionViewCell:
				textFieldCell.onTextReturn = { [self] text in
					append(token: text)

					let newIndexPath = IndexPath(item: tokens.count - 1, section: 0)

					UIView.performWithoutAnimation {
						collectionView.insertItems(at: [newIndexPath])
					}
				}

				return textFieldCell

			default:
				break
		}

		return cell
	}
}

extension TokenDataSource: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// TODO: Use a ViewModel or something else to handle size that is more customizable
		let identifier = identifier(forCellAtIndexPath: indexPath)

		switch identifier {
			case "TextFieldCollectionViewCell":
				return CGSize(width: 60, height: 20)

			// Default currently is TokenCollectionViewCell
			default:
				return tokens[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 18)])
		}
	}
}


extension TokenDataSource: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? TokenCollectionViewCell {
			_ = cell.becomeFirstResponder()
		}
	}
}
