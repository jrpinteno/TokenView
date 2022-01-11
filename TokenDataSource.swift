//
//  TokenDataSource.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

class TokenDataSource: NSObject {
	// MARK: Properties

	/// Array of tokens
	private(set) var tokens: [String] = []

	/// Tokens + TextField + (Prompt if should be shown)
	var itemsCount: Int {
		return tokens.count + 1 + (shouldShowPrompt ? 1 : 0)
	}

	/// Position of TextField in the collectionView
	var textFieldIndexPath: IndexPath {
		// TextField is always at the end
		return IndexPath(item: tokens.count + (shouldShowPrompt ? 1 : 0), section: 0)
	}

	/// IndexPath for prompt cell if it's shown
	var promptIndexPath: IndexPath? {
		return shouldShowPrompt ? IndexPath(item: 0, section: 0) : nil
	}

	/// Non-editable text to show before the line of tokens
	var prompt: String?

	/// Tells whether label with prompt is shown. It affects to calculation
	/// regarding IndexPath of the different items
	var shouldShowPrompt: Bool = false


	// MARK: Token operations

	/// Fetch token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position at which the token should be
	/// - Returns: Token which will be displayed
	func token(at indexPath: IndexPath) -> String {
		return tokens[indexPath.item + (shouldShowPrompt ? -1 : 0)]
	}

	/// Appends a token to the token list
	///
	/// - Parameter token: Token to be appended
	func append(token: String) {
		tokens.append(token)
	}

	/// Removes the token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position of the token to be removed
	func removeToken(at indexPath: IndexPath) {
		let index = shouldShowPrompt ? indexPath.item - 1 : indexPath.item
		tokens.remove(at: index)
	}

	/// Finds `IndexPath` for a given token
	///
	/// - Parameter token: Token
	/// - Returns: `IndexPath` for the first appearance of the given token
	func indexPathFor(token: String) -> IndexPath? {
		for i in 0 ..< tokens.count {
			if token == tokens[i] {
				let index = shouldShowPrompt ? i + 1 : i
				return IndexPath(item: index, section: 0)
			}
		}

		return nil
	}


	// MARK: Helper methods to get data according to item position
	/// Identifier of reusable cell to be used at a given `IndexPath`
	///
	/// - Parameter indexPath: IndexPath of cell
	///
	/// - Returns: Cell identifier
	func identifier(forCellAtIndexPath indexPath: IndexPath) -> String {
		switch indexPath.item {
			case (shouldShowPrompt ? 0 : nil):
				return PromptCollectionViewCell.reuseIdentifier

			case textFieldIndexPath.item:
				return TextFieldCollectionViewCell.reuseIdentifier

			default:
				return TokenCollectionViewCell.reuseIdentifier
		}
	}
}


// MARK: UICollectionViewDelegateFlowLayout methods
extension TokenDataSource: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// TODO: Use a ViewModel or something else to handle size that is more customizable
		let identifier = identifier(forCellAtIndexPath: indexPath)
		let font = UIFont.systemFont(ofSize: 18)
		let horizontalPadding = 4.0
		let verticalPadding = 8.0

		switch identifier {
			case PromptCollectionViewCell.reuseIdentifier:
				let width = prompt?.size(withAttributes: [.font: font]).width ?? 0
				return CGSize(width: ceil(width) + horizontalPadding * 2, height: font.lineHeight + verticalPadding * 2)

			case TextFieldCollectionViewCell.reuseIdentifier:
				// Here we return the minimum size for the TextField
				return CGSize(width: 60, height: font.lineHeight + verticalPadding * 2)

			// Default currently is TokenCollectionViewCell
			default:
				let width = token(at: indexPath).size(withAttributes: [.font: font]).width

				return CGSize(width: ceil(width) + horizontalPadding * 2, height: font.lineHeight + verticalPadding * 2)
		}
	}
}


// MARK: UICollectionViewDelegate methods
extension TokenDataSource: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? TokenCollectionViewCell {
			_ = cell.becomeFirstResponder()
		}
	}
}
