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
	private var itemsCount: Int {
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

	var prompt: String?
	var shouldShowPrompt: Bool = false


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
				let index = shouldShowPrompt ? i + 1 : i
				return IndexPath(item: index, section: 0)
			}
		}

		return nil
	}

	/// Removes the token at the given `IndexPath`
	///
	/// - Parameter indexPath: Position of the token to be removed
	func removeToken(at indexPath: IndexPath) {
		let index = shouldShowPrompt ? indexPath.item - 1 : indexPath.item
		tokens.remove(at: index)
	}

	/// Identifier of reusable cell to be used at a given `IndexPath`
	///
	/// - Parameter indexPath: IndexPath of cell
	///
	/// - Returns: Cell identifier
	private func identifier(forCellAtIndexPath indexPath: IndexPath) -> String {
		switch indexPath.item {
			case (shouldShowPrompt ? 0 : nil):
				return "PromptCollectionViewCell"

			case textFieldIndexPath.item:
				return "TextFieldCollectionViewCell"

			default:
				return "TokenCollectionViewCell"
		}
	}
}


// MARK: UICollectionViewDataSource methods
extension TokenDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return itemsCount
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(forCellAtIndexPath: indexPath), for: indexPath)

		switch cell {
			case let promptCell as PromptCollectionViewCell:
				promptCell.text = prompt
				break

			case let tokenCell as TokenCollectionViewCell:
				let token = tokens[indexPath.item + (shouldShowPrompt ? -1 : 0)]
				tokenCell.configure(with: token)

				tokenCell.willBeRemoved = { [weak self] in
					guard let self = self else { return }

					if let removedIndexPath = self.indexPathFor(token: token) {
						self.removeToken(at: removedIndexPath)

						UIView.performWithoutAnimation {
							collectionView.deleteItems(at: [removedIndexPath])
						}

						// TODO: Considerations. When deleting token, should it go to the following tag, textfield or do nothing?
						// Currently we make textfield first responder
						if let textFieldCell = collectionView.cellForItem(at: self.textFieldIndexPath) as? TextFieldCollectionViewCell {

							_ = textFieldCell.becomeFirstResponder()
						}
					}
				}

				tokenCell.willReplaceText = { [weak self] text in
					guard let self = self else { return }

					if let removedIndexPath = self.indexPathFor(token: token) {
						self.removeToken(at: removedIndexPath)

						UIView.performWithoutAnimation {
							collectionView.deleteItems(at: [removedIndexPath])
						}

						if let textFieldCell = collectionView.cellForItem(at: self.textFieldIndexPath) as? TextFieldCollectionViewCell {

							_ = textFieldCell.becomeFirstResponder()
							textFieldCell.text = text
						}
					}
				}

			case let textFieldCell as TextFieldCollectionViewCell:
				textFieldCell.onTextReturn = { [weak self] text in
					guard let self = self else { return }

					self.append(token: text)

					let newIndexPath = IndexPath(item: self.textFieldIndexPath.item - 1, section: 0)

					UIView.performWithoutAnimation {
						collectionView.insertItems(at: [newIndexPath])
						collectionView.scrollToItem(at: self.textFieldIndexPath, at: .top, animated: true)
					}
				}

				textFieldCell.onEmptyDelete = { [weak self] in
					guard let self = self else { return }

					if !self.tokens.isEmpty {
						let previousIndexPath = IndexPath(item: self.textFieldIndexPath.item - 1, section: 0)
						let cell = collectionView.cellForItem(at: previousIndexPath)
						_ = cell?.becomeFirstResponder()
					}
				}

				return textFieldCell

			default:
				break
		}

		return cell
	}
}


// MARK: UICollectionViewDelegateFlowLayout methods
extension TokenDataSource: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// TODO: Use a ViewModel or something else to handle size that is more customizable
		let identifier = identifier(forCellAtIndexPath: indexPath)
		let font = UIFont.systemFont(ofSize: 18)
		let horizontalPadding = 8.0
		let verticalPadding = 8.0

		switch identifier {
			case "PromptCollectionViewCell":
				let width = prompt?.size(withAttributes: [.font: font]).width ?? 0
				return CGSize(width: width + horizontalPadding * 2, height: font.lineHeight + verticalPadding * 2)

			case "TextFieldCollectionViewCell":
				// Here we return the minimum size for the TextField
				return CGSize(width: 60, height: font.lineHeight + verticalPadding * 2)

			// Default currently is TokenCollectionViewCell
			default:
				let width = tokens[shouldShowPrompt ? indexPath.item - 1 : indexPath.item].size(withAttributes: [.font: font]).width

				return CGSize(width: width + horizontalPadding * 2, height: font.lineHeight + verticalPadding * 2)
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
