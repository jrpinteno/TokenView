//
//  TokenDataSource.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

class TokenDataSource<Element>: NSObject where Element: Tokenizable {
	// MARK: Properties

	/// Array of tokens
	private(set) var tokens: [Element] = []

	/// Tokens + TextField + (Prompt if should be shown)
	var itemsCount: Int {
		return tokens.count + 1 + (shouldShowPrompt ? 1 : 0)
	}

	/// Position of TextField in the collectionView
	var textFieldIndexPath: IndexPath {
		// TextField is always at the end
		return IndexPath(item: itemsCount - 1, section: 0)
	}

	/// IndexPath for prompt cell if it's shown
	var promptIndexPath: IndexPath? {
		return shouldShowPrompt ? IndexPath(item: 0, section: 0) : nil
	}

	/// Non-editable text to show before the line of tokens
	var prompt: String?

	/// Placeholder to show on the textfield
	var placeholder: String?

	/// Tells whether label with prompt is shown. It affects to calculation
	/// regarding IndexPath of the different items
	var shouldShowPrompt: Bool = false


	// MARK: Token operations

	/// Fetch token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position at which the token should be
	/// - Returns: Token which will be displayed
	func token(at indexPath: IndexPath) -> Element {
		return tokens[indexPath.item + (shouldShowPrompt ? -1 : 0)]
	}

	/// Appends a token to the token list
	///
	/// - Parameter token: Token to be appended
	func append(token: Element) {
		tokens.append(token)
	}

	/// Appends the elements of the sequence to token list
	///
	/// - Parameter tokens: Tokens to append
	func append<S>(tokens: S) where S: Sequence, S.Element == Element {
		self.tokens.append(contentsOf: tokens)
	}

	/// Removes the token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position of the token to be removed
	func removeToken(at indexPath: IndexPath) {
		let index = indexPath.item - (shouldShowPrompt ?  1 : 0)
		tokens.remove(at: index)
	}

	/// Returns a Boolean indicating whether token already exists in the array
	///
	/// - Parameter token: Token to check against
	/// - Returns: `true` if the `token` is found; otherwise `false`.
	func contains(token: Element) -> Bool {
		guard tokens.firstIndex(of: token) != nil else {
			return false
		}

		return true
	}

	/// Finds `IndexPath` for a given token
	///
	/// - Parameter token: Token
	/// - Returns: `IndexPath` for the first appearance of the given token
	func indexPathFor(token: Element) -> IndexPath? {
		guard let tokenIndex = tokens.firstIndex(of: token) else {
			return nil
		}

		let index = tokenIndex + (shouldShowPrompt ? 1 : 0)
		return IndexPath(item: index, section: 0)
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
