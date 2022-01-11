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


// MARK: UICollectionViewDelegate methods
extension TokenView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

		if let cell = collectionView.cellForItem(at: indexPath) as? TokenCollectionViewCell {
			if cell.isSelected {
				let item = tokenDataSource.token(at: indexPath)
				delegate?.tokenView(self, didSelectToken: item.key)
			} else {
				_ = cell.becomeFirstResponder()
			}
		}
	}
}


// MARK: PickerTableViewDelegate methods
extension TokenView: PickerTableViewDelegate {
	func tableView(_ view: UITableView, didUpdateContentSize contentSize: CGSize) {
		// TODO: Take into account safe area
		pickerHeightConstraint.constant = min(contentSize.height, maxPickerHeight)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let item = pickerDataSource?.filteredItems[indexPath.item] {
			let token = Token(key: item.key, displayValue: item.displayValue)

			if addToken(token) {
				if let textFieldCell = collectionView.cellForItem(at: tokenDataSource.textFieldIndexPath) as? TextFieldCollectionViewCell {

					_ = textFieldCell.becomeFirstResponder()
					textFieldCell.text = nil
				}
			}
		}
	}
}


// MARK: Helper methods to configure cells
fileprivate extension TokenView {
	func configureCell(_ tokenCell: TokenCollectionViewCell, at indexPath: IndexPath) {
		let token = tokenDataSource.token(at: indexPath)
		tokenCell.configure(with: token.displayValue)

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

		textFieldCell.onTextChanged = { [weak self] text in
			guard let self = self else {
				return true
			}

			if let delimiters = self.delimiters, delimiters.contains(String(text.suffix(1))) {
				return self.addToken(text.dropLast().trimmingCharacters(in: .whitespaces))
			}

			if self.shouldShowPicker {
				self.showPicker(for: text)
			}

			return false
		}
	}
}
