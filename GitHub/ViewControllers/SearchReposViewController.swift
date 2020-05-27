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
	@IBOutlet private var loadingIndicator: UIActivityIndicatorView!

	private let disposeBag = DisposeBag()

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

		outputs.repos
			.bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseID, cellType: RepoCell.self)) { row, repo, cell in
				cell.configure(with: RepoCellViewModel(repo: repo))
			}
			.disposed(by: disposeBag)

		tableView.rx.modelSelected(Repo.self)
			.map { RepoDetailsViewModel(repo: $0) }
			.map { RepoDetailsViewController.buildFromStoryboard(with: $0) }
			.subscribe(onNext: { [weak self] viewController in
				self?.navigationController?.pushViewController(viewController, animated: true)
			})
			.disposed(by: disposeBag)

		outputs.error.subscribe(onNext: { error in
			print("received error: \(error)")
		}).disposed(by: disposeBag)
	}
}
