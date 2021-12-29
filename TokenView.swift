//
//  TokenView.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

protocol PickerDataSource: AnyObject {
	func items(with pattern: String) -> [String]
}

protocol TokenViewDelegate: AnyObject {
	func tokenView(_ view: TokenView, isTokenValid token: String) -> Bool
	func tokenView(_ view: TokenView, didSelectToken token: String)
	func tokenView(_ view: TokenView, didRemoveToken token: String)
	func tokenView(_ view: TokenView, present picker: PickerViewController)
}


class TokenView: UIView {
// MARK: Properties
	let tokenDataSource: TokenDataSource = .init()
	weak var delegate: TokenViewDelegate? = nil
	weak var pickerDataSource: PickerDataSource? = nil {
		didSet {
			picker.dataSource = pickerDataSource
		}
	}

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

	lazy var picker: PickerViewController = {
		let viewController = PickerViewController()
		viewController.modalPresentationStyle = .popover

		return viewController
	}()
}


// MARK: TokenFlowLayoutDelegate methods
extension TokenView: TokenFlowLayoutDelegate {
	func textFieldIndexPath(in collectionView: UICollectionView) -> IndexPath {
		return tokenDataSource.textFieldIndexPath
	}
}


// MARK: UIPopoverPresentationControllerDelegate methods
extension TokenView: UIPopoverPresentationControllerDelegate {
	func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
		popoverPresentationController.sourceView = self
		popoverPresentationController.sourceRect = self.bounds
		popoverPresentationController.canOverlapSourceViewRect = false
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		print("adaptivePresentationStyle")
		return .none
	}

	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		print("adaptivePresentationStyle")
		return .none
	}
}
