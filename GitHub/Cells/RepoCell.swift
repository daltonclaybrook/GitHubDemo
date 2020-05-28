//
//  RepoCell.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class RepoCell: UITableViewCell {
	static var reuseID: String {
		String(describing: self)
	}

	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var ownerLabel: UILabel!
	@IBOutlet private var starButton: UIButton!

	private var disposeBag = DisposeBag()

	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}

	func configure(with viewModel: RepoCellViewModel, isRepoStarred: Observable<Bool>, repoStarToggled: AnyObserver<Repo>) {
		nameLabel.text = viewModel.name
		ownerLabel.text = viewModel.owner

		isRepoStarred
			.map { $0 ? "star.fill" : "star" }
			.map { UIImage(systemName: $0) }
			.bind(to: starButton.rx.image(for: .normal))
			.disposed(by: disposeBag)

		starButton.rx.tap
			.map { viewModel.repo }
			.bind(to: repoStarToggled)
			.disposed(by: disposeBag)
	}
}
