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

		collectionView.dataSource = tokenDataSource
		collectionView.delegate = tokenDataSource

		if let layout = collectionView.collectionViewLayout as? TokenFlowLayout {
			layout.delegate = self
		}
	}


	// MARK: Lazy views

	private lazy var collectionView: TokenCollectionView = {
		let layout = TokenFlowLayout()
		let view = TokenCollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()
}

extension TokenView: TokenFlowLayoutDelegate {
	func textFieldIndexPath(in collectionView: UICollectionView) -> IndexPath {
		return tokenDataSource.textFieldIndexPath
	}
}
