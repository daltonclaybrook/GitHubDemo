//
//  RepoDetailViewController.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Kingfisher
import UIKit

final class RepoDetailsViewController: UIViewController {
	@IBOutlet var ownerImageView: UIImageView!
	@IBOutlet var ownerNameLabel: UILabel!
	@IBOutlet var repoNameLabel: UILabel!
	@IBOutlet var languageLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var starsLabel: UILabel!
	@IBOutlet var forksLabel: UILabel!
	@IBOutlet var watchingLabel: UILabel!

	private let viewModel: RepoDetailsViewModel

	init?(coder: NSCoder, viewModel: RepoDetailsViewModel) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureViews()
		configure(with: viewModel)
	}

	// MARK: - Helpers

	private func configureViews() {
		ownerImageView.kf.indicatorType = .activity
		ownerImageView.layer.masksToBounds = true
		ownerImageView.layer.cornerRadius = 4
	}

	private func configure(with viewModel: RepoDetailsViewModel) {
		ownerImageView.kf.setImage(with: viewModel.ownerImageURL)
		ownerNameLabel.text = viewModel.ownerName
		repoNameLabel.text = viewModel.repoName
		languageLabel.text = viewModel.language
		descriptionLabel.text = viewModel.description
		starsLabel.text = viewModel.starsText
		forksLabel.text = viewModel.forksText
		watchingLabel.text = viewModel.watchingText
	}
}

extension RepoDetailsViewController {
	static func buildFromStoryboard(with viewModel: RepoDetailsViewModel) -> RepoDetailsViewController {
		UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(identifier: String(describing: self)) { coder in
				RepoDetailsViewController(coder: coder, viewModel: viewModel)
			}
	}
}
