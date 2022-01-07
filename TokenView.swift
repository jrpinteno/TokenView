//
//  TokenView.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 24.11.2021.
//

import UIKit

protocol TokenViewDelegate: AnyObject {
	func tokenView(_ view: TokenView, isTokenValid token: String) -> Bool
	func tokenView(_ view: TokenView, didSelectToken token: String)
	func tokenView(_ view: TokenView, didRemoveToken token: String)
}


class TokenView: UIView {
// MARK: Properties
	let tokenDataSource: TokenDataSource = .init()
	weak var delegate: TokenViewDelegate? = nil
	var pickerDataSource: PickerDataSource? = nil
	var pickerHeight: CGFloat = 400

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

	/// We override hitTest to allow touches on pickerView which is outside
	/// parent's bounds
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let subViewPoint = pickerView.convert(point, from: self)

		if let view = pickerView.hitTest(subViewPoint, with: event) {
			return view
		}

		return super.hitTest(point, with: event)
	}

	private func setupViews() {
		addSubview(collectionView)
		collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

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

	lazy var pickerView: UITableView = {
		let view = UITableView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		view.separatorInset = .zero
		view.register(PickerCell.self, forCellReuseIdentifier: PickerCell.reuseIdentifier)

		return view
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
		return .none
	}

	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}


extension TokenView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
}
