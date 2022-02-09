//
//  PickerCell.swift
//  TokenView
//
//  Created by Xavi R. Pinteño on 29.12.2021.
//

import UIKit

extension PickerCell: ReusableCell {}

class PickerCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func populateCell(with data: Pickable) {
		if !data.title.isEmpty {
			titleLabel.text = data.title
			titleLabel.isHidden = false
		}

		if let subtitle = data.subtitle, !subtitle.isEmpty {
			detailLabel.text = subtitle
			detailLabel.isHidden = false
		}

		if let image = data.image {
			photoView.image = image
			photoView.isHidden = false
			photoView.heightAnchor.constraint(equalTo: verticalStack.heightAnchor).isActive = true
			photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor).isActive = true
		}

		let stackHeight = ceil(titleLabel.font.lineHeight + detailLabel.font.lineHeight)
		verticalStack.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
	}

	private func setupView() {
		contentView.addSubview(horizontalStack)
		horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
		horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
		horizontalStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8).isActive = true
		horizontalStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4).isActive = true

		horizontalStack.addArrangedSubview(photoView)

		verticalStack.addArrangedSubview(titleLabel)
		verticalStack.addArrangedSubview(detailLabel)

		horizontalStack.addArrangedSubview(verticalStack)

		photoView.isHidden = true
		titleLabel.isHidden = true
		detailLabel.isHidden = true
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		photoView.isHidden = true
		titleLabel.isHidden = true
		detailLabel.isHidden = true
	}


	// MARK: views

	private lazy var horizontalStack: UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.isLayoutMarginsRelativeArrangement = true
		stack.spacing = 8
		stack.alignment = .center
		stack.distribution = .fill
		stack.axis = .horizontal

		return stack
	}()

	private lazy var verticalStack: UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .fill
		stack.distribution = .fill

		return stack
	}()

	private lazy var photoView: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		view.setContentHuggingPriority(.defaultLow, for: .vertical)
		view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

		return view
	}()

	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.setContentHuggingPriority(.required, for: .vertical)
		label.font = .systemFont(ofSize: 14.0)

		return label
	}()

	private lazy var detailLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.setContentHuggingPriority(.required, for: .vertical)
		label.font = .systemFont(ofSize: 14.0)
		label.textColor = .darkGray

		return label
	}()
}
