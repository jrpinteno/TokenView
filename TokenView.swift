//
//  TokenView.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

protocol TokenViewDelegate: AnyObject {
	func tokenView(_ view: TokenView, isTokenValid token: String) -> Bool
	func tokenView(_ view: TokenView, didSelectToken token: String)
	func tokenView(_ view: TokenView, didAddToken token: String)
	func tokenView(_ view: TokenView, didRemoveToken token: String)
}


class TokenView: UIView {
	// MARK: Properties
	weak var delegate: TokenViewDelegate? = nil
	let tokenDataSource = TokenDataSource<Token>()

	var pickerDataSource: PickerDataSource? = nil
	var pickerHeightConstraint: NSLayoutConstraint!
	var maxPickerHeight: CGFloat = 0

	var items: [Pickable]? = nil {
		didSet {
			if let items = items {
				pickerDataSource = PickerDataSource(items: items)
				pickerView.dataSource = pickerDataSource
				pickerView.delegate = self

				shouldShowPicker = true
			}
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

	var placeholder: String? = nil {
		didSet {
			tokenDataSource.placeholder = placeholder
		}
	}

	var shouldShowPicker: Bool = false

	/// If not defined, return Configuration.Style.Token
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

	override func layoutSubviews() {
		super.layoutSubviews()

		if shouldShowPicker {
			let screenHeight = UIScreen.main.bounds.height
			maxPickerHeight = screenHeight - self.frame.maxY
		}
	}

	/// We override hitTest to allow touches on pickerView which is outside
	/// parent's bounds
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if shouldShowPicker {
			let subViewPoint = pickerView.convert(point, from: self)

			if let view = pickerView.hitTest(subViewPoint, with: event) {
				return view
			}
		}

		return super.hitTest(point, with: event)
	}

	private func setupViews() {
		addSubview(collectionView)
		collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.isScrollEnabled = false

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

	lazy var pickerView: PickerTableView = {
		let view = PickerTableView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		view.separatorInset = .zero
		view.register(PickerCell.self, forCellReuseIdentifier: PickerCell.reuseIdentifier)

		return view
	}()
}


// MARK: TokenFlowLayoutDelegate methods
extension TokenView: TokenFlowLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView, didChangeHeight height: CGFloat) {}

	func textFieldIndexPath(in collectionView: UICollectionView) -> IndexPath {
		return tokenDataSource.textFieldIndexPath
	}
}


// MARK: UICollectionViewDelegateFlowLayout methods
extension TokenView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// TODO: Use a ViewModel or something else to handle size that is more customizable
		let identifier = tokenDataSource.identifier(forCellAtIndexPath: indexPath)
		let font = UIFont.systemFont(ofSize: 14)
		let horizontalPadding = 4.0
		let verticalPadding = 4.0

		switch identifier {
			case PromptCollectionViewCell.reuseIdentifier:
				let width = prompt?.size(withAttributes: [.font: font]).width ?? 0
				return CGSize(width: ceil(width), height: font.lineHeight + verticalPadding * 2)

			case TextFieldCollectionViewCell.reuseIdentifier:
				// Here we return the minimum size for the TextField
				return CGSize(width: 60, height: font.lineHeight + verticalPadding * 2)

				// Default currently is TokenCollectionViewCell
			default:
				let token = tokenDataSource.token(at: indexPath)
				let width = token.displayValue.size(withAttributes: [.font: font]).width

				return CGSize(width: ceil(width) + horizontalPadding * 2, height: font.lineHeight + verticalPadding * 2)
		}
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
		return .none
	}

	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}
