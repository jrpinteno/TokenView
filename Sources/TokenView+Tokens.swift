//
//  TokenView+Tokens.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 11.1.2022.
//

import UIKit

extension TokenView {
	/// Adds new token to the collectionView and DataSource
	///
	/// In case validation is required, a call to the delegate is made
	///
	/// - Parameter text: Token to be added
	/// - Returns: Whether the token has been successfully addded
	func addToken(_ text: String) -> Bool {
		guard !text.isEmpty else {
			return false
		}

		// If token needs validation and it's not valid stop here
		if self.validationRequired && self.delegate?.tokenView(self, isTokenValid: text) == false {
			return false
		}

		// TODO: delegate to search for item
		let token = Token(key: text)

		return addToken(token)
	}

	/// Adds new token to the collectionView and DataSource.
	///
	/// - Parameter token: Token to be added
	/// - Returns:
	func addToken(_ token: Token) -> Bool {
		defer {
			if shouldShowPicker {
				pickerDataSource?.pattern = ""
				hidePicker()
			}
		}

		// If token already exists no need to continue. TextField content is reset
		guard !tokenDataSource.contains(token: token) else {
			return true
		}

		tokenDataSource.append(token: token)

		let newIndexPath = IndexPath(item: self.tokenDataSource.lastIndexPath.item - 1, section: 0)

		UIView.performWithoutAnimation {
			self.collectionView.insertItems(at: [newIndexPath])
			self.collectionView.scrollToItem(at: self.tokenDataSource.lastIndexPath, at: .top, animated: true)
		}

		delegate?.tokenView(self, didAddToken: token.key)

		return true
	}

	/// Preloads a number of tokens to show on the tokenView
	///
	/// These tokens are not validated and might contain duplicates
	///
	/// - Parameter tokens: Tokens to be added initially
	func preloadTokens<S>(_ tokens: S) where S: Sequence, S.Element == Token {
		// TODO: Should do validation and check for duplicity?
		tokenDataSource.append(tokens: tokens)
	}

	/// Removes a token
	///
	/// Auxiliary function which deletes the token from both the dataSource
	/// and the collectionView.
	///
	/// - Warning: Duplicated tags might cause issues
	/// - Parameters:
	///   - token: Token to be deleted
	///   - replaceText: If present, the text will be shown in the textField
	func removeToken(_ token: Token, replaceText: String? = nil) {
		if let removedIndexPath = tokenDataSource.indexPathFor(token: token) {
			tokenDataSource.removeToken(at: removedIndexPath)

			UIView.performWithoutAnimation {
				collectionView.deleteItems(at: [removedIndexPath])
			}

			// TODO: Considerations. When deleting token, should it go to the following tag, textfield or do nothing?
			// Currently we make textfield first responder
			if let textFieldIndexPath = tokenDataSource.textFieldIndexPath,
				let textFieldCell = collectionView.cellForItem(at: textFieldIndexPath) as? TextFieldCollectionViewCell {

				_ = textFieldCell.becomeFirstResponder()
				textFieldCell.text = replaceText
			}

			delegate?.tokenView(self, didRemoveToken: token.key)
		}
	}
}
