//
//  FavoriteReposViewController.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/27/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class FavoriteReposViewController: UIViewController {
	@IBOutlet private var tableView: UITableView!

	private let viewModel: FavoriteReposViewModel
	private let disposeBag = DisposeBag()

	init?(coder: NSCoder, viewModel: FavoriteReposViewModel) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureBindings()
	}

	private func configureBindings() {
		viewModel.favoriteRepos
			.bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseID, cellType: RepoCell.self)) { [viewModel] _, repo, cell in
				cell.configure(
					with: RepoCellViewModel(repo: repo),
					isRepoStarred: .just(true),
					repoStarToggled: viewModel.repoStarToggled
				)
			}
			.disposed(by: disposeBag)
	}
}

extension FavoriteReposViewController {
	static func buildFromStoryboard(with viewModel: FavoriteReposViewModel) -> FavoriteReposViewController {
		UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(identifier: String(describing: self)) { coder in
				FavoriteReposViewController(coder: coder, viewModel: viewModel)
			}
	}
}
