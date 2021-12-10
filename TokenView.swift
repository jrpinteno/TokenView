//
//  TokenView.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

class TokenView: UIView {
	private let tokenDataSource: TokenDataSource = .init()

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		addSubview(collectionView)
		collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true

		collectionView.dataSource = self
		collectionView.delegate = tokenDataSource
		collectionView.isScrollEnabled = true

		if let layout = collectionView.collectionViewLayout as? TokenFlowLayout {
			layout.delegate = self
		}

		tokenDataSource.prompt = "To:"
		tokenDataSource.shouldShowPrompt = true
	}


	// MARK: Lazy views

	private lazy var collectionView: TokenCollectionView = {
		let layout = TokenFlowLayout()
		let view = TokenCollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()
}


// MARK: TokenFlowLayoutDelegate methods
extension TokenView: TokenFlowLayoutDelegate {
	func textFieldIndexPath(in collectionView: UICollectionView) -> IndexPath {
		return tokenDataSource.textFieldIndexPath
	}
}


// MARK: UICollectionViewDataSource methods
extension TokenView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tokenDataSource.itemsCount
	}

	fileprivate func configure(_ indexPath: IndexPath, _ tokenCell: TokenCollectionViewCell, _ collectionView: UICollectionView) {
		let token = tokenDataSource.token(at: indexPath)
		tokenCell.configure(with: token)

		tokenCell.willBeRemoved = { [weak self] in
			guard let self = self else { return }

			if let removedIndexPath = self.tokenDataSource.indexPathFor(token: token) {
				self.tokenDataSource.removeToken(at: removedIndexPath)

				UIView.performWithoutAnimation {
					collectionView.deleteItems(at: [removedIndexPath])
				}

				// TODO: Considerations. When deleting token, should it go to the following tag, textfield or do nothing?
				// Currently we make textfield first responder
				if let textFieldCell = collectionView.cellForItem(at: self.tokenDataSource.textFieldIndexPath) as? TextFieldCollectionViewCell {

					_ = textFieldCell.becomeFirstResponder()
				}
			}
		}

		tokenCell.willReplaceText = { [weak self] text in
			guard let self = self else { return }

			if let removedIndexPath = self.tokenDataSource.indexPathFor(token: token) {
				self.tokenDataSource.removeToken(at: removedIndexPath)

				UIView.performWithoutAnimation {
					collectionView.deleteItems(at: [removedIndexPath])
				}

				if let textFieldCell = collectionView.cellForItem(at: self.tokenDataSource.textFieldIndexPath) as? TextFieldCollectionViewCell {

					_ = textFieldCell.becomeFirstResponder()
					textFieldCell.text = text
				}
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tokenDataSource.identifier(forCellAtIndexPath: indexPath), for: indexPath)

		switch cell {
			case let promptCell as PromptCollectionViewCell:
				promptCell.text = tokenDataSource.prompt
				break

			case let tokenCell as TokenCollectionViewCell:
				configure(indexPath, tokenCell, collectionView)

			case let textFieldCell as TextFieldCollectionViewCell:
				textFieldCell.onTextReturn = { [weak self] text in
					guard let self = self else { return }

					self.tokenDataSource.append(token: text)

					let newIndexPath = IndexPath(item: self.tokenDataSource.textFieldIndexPath.item - 1, section: 0)

					UIView.performWithoutAnimation {
						collectionView.insertItems(at: [newIndexPath])
						collectionView.scrollToItem(at: self.tokenDataSource.textFieldIndexPath, at: .top, animated: true)
					}
				}

				textFieldCell.onEmptyDelete = { [weak self] in
					guard let self = self else { return }

					if !self.tokenDataSource.tokens.isEmpty {
						let previousIndexPath = IndexPath(item: self.tokenDataSource.textFieldIndexPath.item - 1, section: 0)
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
