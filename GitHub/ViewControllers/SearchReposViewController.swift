//
//  SearchReposViewController.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class SearchReposViewController: UIViewController {
	@IBOutlet private var tableView: UITableView!
	@IBOutlet private var searchBar: UISearchBar!
	@IBOutlet private var favoritesButton: UIBarButtonItem!
	@IBOutlet private var loadingIndicator: UIActivityIndicatorView!

	private let disposeBag = DisposeBag()
	private let repoStarToggledRelay = PublishRelay<Repo>()

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let selectedPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedPath, animated: true)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		view.endEditing(true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let inputs = makeViewModelInputs()
		let outputs = SearchReposViewModel.transform(inputs: inputs)
		configureBindings(with: outputs)
	}

	// MARK: - Helpers

	private func makeViewModelInputs() -> SearchReposViewModel.Inputs {
		let searchText = searchBar.rx.text.map { $0 ?? "" }
		return SearchReposViewModel.Inputs(searchBarText: searchText)
	}

	private func configureBindings(with outputs: SearchReposViewModel.Outputs) {
		outputs.isLoading
			.bind(to: loadingIndicator.rx.isAnimating)
			.disposed(by: disposeBag)

		let starredRepos = getStarredRepos().share(replay: 1)
		let isRepoStarred = { (repo: Repo) in starredRepos.map { $0[repo.id] != nil } }

		outputs.repos
			.bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseID, cellType: RepoCell.self)) { [repoStarToggledRelay] _, repo, cell in
				cell.configure(
					with: RepoCellViewModel(repo: repo),
					isRepoStarred: isRepoStarred(repo),
					repoStarToggled: repoStarToggledRelay.asObserver()
				)
			}
			.disposed(by: disposeBag)

		tableView.rx.modelSelected(Repo.self)
			.map { RepoDetailsViewModel(repo: $0) }
			.map { RepoDetailsViewController.buildFromStoryboard(with: $0) }
			.subscribe(onNext: { [weak self] viewController in
				self?.navigationController?.pushViewController(viewController, animated: true)
			})
			.disposed(by: disposeBag)

		let favoriteRepos = starredRepos.map { $0.values.sorted { $0.name < $1.name } }
		favoritesButton.rx.tap
			.map { [repoStarToggledRelay] in
				FavoriteReposViewModel(favoriteRepos: favoriteRepos, repoStarToggled: repoStarToggledRelay.asObserver())
			}
			.map { FavoriteReposViewController.buildFromStoryboard(with: $0) }
			.map { UINavigationController(rootViewController: $0) }
			.subscribe(onNext: { [weak self] navController in
				self?.present(navController, animated: true, completion: nil)
			})
			.disposed(by: disposeBag)

		outputs.error
			.map { error -> UIAlertController in
				UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
			}
			.do(onNext: { alert in
				alert.addAction(UIAlertAction(title: "OK", style: .default))
			})
			.subscribe(onNext: { [weak self] alert in
				self?.present(alert, animated: true, completion: nil)
			})
			.disposed(by: disposeBag)
	}

	private func getStarredRepos() -> Observable<[RepoID: Repo]> {
		repoStarToggledRelay
			.scan(into: [RepoID: Repo]()) { starredRepos, repo in
				if starredRepos[repo.id] == nil {
					starredRepos[repo.id] = repo
				} else {
					starredRepos.removeValue(forKey: repo.id)
				}
			}
	}
}
