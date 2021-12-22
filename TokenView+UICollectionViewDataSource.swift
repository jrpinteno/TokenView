//
//  TokenView+UICollectionViewDataSource.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 13.12.2021.
//

import UIKit

// MARK: UICollectionViewDataSource methods
extension TokenView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tokenDataSource.itemsCount
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tokenDataSource.identifier(forCellAtIndexPath: indexPath), for: indexPath)

		switch cell {
			case let promptCell as PromptCollectionViewCell:
				promptCell.text = tokenDataSource.prompt

			case let tokenCell as TokenCollectionViewCell:
				configureCell(tokenCell, at: indexPath)

			case let textFieldCell as TextFieldCollectionViewCell:
				configureCell(textFieldCell)

			default:
				break
		}

		return cell
	}
}


// MARK: Helper methods to configure cells
fileprivate extension TokenView {
	func configureCell(_ tokenCell: TokenCollectionViewCell, at indexPath: IndexPath) {
		let token = tokenDataSource.token(at: indexPath)
		tokenCell.configure(with: token)

		tokenCell.willBeRemoved = { [weak self] in
			guard let self = self else { return }

			self.removeToken(token)
		}

		tokenCell.willReplaceText = { [weak self] text in
			guard let self = self else { return }

			self.removeToken(token, replaceText: text)
		}
	}

	func configureCell(_ textFieldCell: TextFieldCollectionViewCell) {
		textFieldCell.onTextReturn = { [weak self] text in
			guard let self = self else {
				return true
			}

			return self.addToken(text)
		}

		textFieldCell.onEmptyDelete = { [weak self] in
			guard let self = self else { return }

			if !self.tokenDataSource.tokens.isEmpty {
				let previousIndexPath = IndexPath(item: self.tokenDataSource.textFieldIndexPath.item - 1, section: 0)
				let cell = self.collectionView.cellForItem(at: previousIndexPath)
				_ = cell?.becomeFirstResponder()
			}
		}

		// OnTextChanged currently only makes sense when delimiters are set, otherwise token is
		// only to be added upon return
		if let delimiters = delimiters {
			textFieldCell.onTextChanged = { [weak self] text in
				guard let self = self else {
					return true
				}

				// If string delimiters are set, then check against them
				if delimiters.contains(String(text.suffix(1))) {
					return self.addToken(text.dropLast().trimmingCharacters(in: .whitespaces))
				}

				return false
			}
		}
	}

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

		self.tokenDataSource.append(token: text)

		let newIndexPath = IndexPath(item: self.tokenDataSource.textFieldIndexPath.item - 1, section: 0)

		UIView.performWithoutAnimation {
			self.collectionView.insertItems(at: [newIndexPath])
			self.collectionView.scrollToItem(at: self.tokenDataSource.textFieldIndexPath, at: .top, animated: true)
		}

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
	func removeToken(_ token: String, replaceText: String? = nil) {
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
		}
	}
}
