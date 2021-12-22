//
//  TokenView.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

protocol TokenViewDelegate {
	func tokenView(_ view: TokenView, isTokenValid token: String) -> Bool
	func tokenView(_ view: TokenView, didSelectToken token: String)
	func tokenView(_ view: TokenView, didRemoveToken token: String)
}


class TokenView: UIView {
	// MARK: Properties
	let tokenDataSource: TokenDataSource = .init()
	var delegate: TokenViewDelegate? = nil

	var prompt: String? = nil {
		didSet {
			tokenDataSource.prompt = prompt
		}
	}

	var shouldShowPrompt: Bool = false {
		didSet {
			tokenDataSource.shouldShowPrompt = shouldShowPrompt
		}
	}

	// If not defined, return Configuration.Style.Token
	var customTokenStyle: TokenStyle?

	/// Delimiters to check on new text entry for token generation
	var delimiters: [String]? = nil

	/// Should tokens be validated before being added
	var validationRequired: Bool = false

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
	}


	// MARK: Lazy views

	lazy var collectionView: TokenCollectionView = {
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
