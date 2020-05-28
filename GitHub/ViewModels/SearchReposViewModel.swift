//
//  SearchReposViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation
import RxSwift

enum SearchReposViewModel: ReactiveViewModel {
	struct Inputs {
		let searchBarText: Observable<String>
	}
	struct Outputs {
		let isLoading: Observable<Bool>
		let repos: Observable<[Repo]>
		let error: Observable<Error>
	}
}

extension SearchReposViewModel {
	static func transform(inputs: Inputs) -> Outputs {
		let searchQuery = inputs.searchBarText
			.debounce(.milliseconds(500), scheduler: MainScheduler.instance)
			.filter { !$0.isEmpty }
			.distinctUntilChanged()
			.share()

		let searchResponse = searchQuery
			.flatMapLatest { query in
				GitHubAPI.makeSingleForSearchRepos(query: query)
					.asObservable()
					.observeOn(MainScheduler.instance)
					.materialize()
					.filter { !$0.isCompleted }
			}
			.share(replay: 1)

		let startedLoading = searchQuery.map { _ in true }
		let stoppedLoading = searchResponse.map { _ in false }

		let isLoading = Observable
			.merge(startedLoading, stoppedLoading)
			.startWith(false)
			.share(replay: 1)
		let repos = searchResponse
			.map { $0.element?.items ?? [] }
			.share(replay: 1)
		let error = searchResponse.map { $0.error }.unwrapped()

		return Outputs(isLoading: isLoading, repos: repos, error: error)
	}
}
