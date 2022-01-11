//
//  TokenView+Tokens.swift
//  TestContactPicker
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

		self.tokenDataSource.append(token: token)

		let newIndexPath = IndexPath(item: self.tokenDataSource.textFieldIndexPath.item - 1, section: 0)

		UIView.performWithoutAnimation {
			self.collectionView.insertItems(at: [newIndexPath])
			self.collectionView.scrollToItem(at: self.tokenDataSource.textFieldIndexPath, at: .top, animated: true)
		}

		delegate?.tokenView(self, didAddToken: token.key)

		return true
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
			if let textFieldCell = collectionView.cellForItem(at: tokenDataSource.textFieldIndexPath) as? TextFieldCollectionViewCell {

				_ = textFieldCell.becomeFirstResponder()
				textFieldCell.text = replaceText
			}

			delegate?.tokenView(self, didRemoveToken: token.key)
		}
	}
}
