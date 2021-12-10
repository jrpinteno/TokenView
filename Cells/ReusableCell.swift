//
//  ReusableCell.swift
//  TestContactPicker
//
//  Created by Xavi R. Pinteño on 10.12.2021.
//

import UIKit

/// Protocol for views that can be reused
public protocol ReusableCell: AnyObject {
	static var reuseIdentifier: String { get }
}


/// Default implementation for `UIView`, that way we don't need to repeat code in the
/// diferent scenarios
public extension ReusableCell where Self: UICollectionViewCell {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension PromptCollectionViewCell: ReusableCell {}
extension TextFieldCollectionViewCell: ReusableCell {}
extension TokenCollectionViewCell: ReusableCell {}
