//
//  RepoDetailViewController.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

final class RepoDetailsViewController: UIViewController {
	@IBOutlet private var ownerImageView: UIImageView!
	@IBOutlet private var ownerNameLabel: UILabel!
	@IBOutlet private var repoNameLabel: UILabel!
	@IBOutlet private var languageLabel: UILabel!
	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var starsLabel: UILabel!
	@IBOutlet private var forksLabel: UILabel!
	@IBOutlet private var watchingLabel: UILabel!
	@IBOutlet private var starButton: UIButton!

	private let viewModel: RepoDetailsViewModel
	private let disposeBag = DisposeBag()

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

		viewModel.isRepoStarred
			.map { $0 ? "star.fill" : "star" }
			.map { UIImage(systemName: $0) }
			.bind(to: starButton.rx.image(for: .normal))
			.disposed(by: disposeBag)

		starButton.rx.tap
			.map { viewModel.repo }
			.bind(to: viewModel.repoStarToggled)
			.disposed(by: disposeBag)
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
