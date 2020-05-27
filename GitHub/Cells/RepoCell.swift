//
//  RepoCell.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import UIKit

final class RepoCell: UITableViewCell {
	static var reuseID: String {
		String(describing: self)
	}

	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var ownerLabel: UILabel!

	func configure(with viewModel: RepoCellViewModel) {
		nameLabel.text = viewModel.name
		ownerLabel.text = viewModel.owner
	}
}
