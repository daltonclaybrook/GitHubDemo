//
//  RepoDetailsViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation
import RxSwift

struct RepoDetailsViewModel {
	let repo: Repo
	let ownerName: String
	let ownerImageURL: URL
	let repoName: String
	let language: String
	let description: String
	let starsText: String
	let forksText: String
	let watchingText: String
	let isRepoStarred: Observable<Bool>
	let repoStarToggled: AnyObserver<Repo>
}

extension RepoDetailsViewModel {
	init(repo: Repo, isRepoStarred: Observable<Bool>, repoStarToggled: AnyObserver<Repo>) {
		self.repo = repo
		self.ownerName = repo.owner.login
		self.ownerImageURL = repo.owner.avatarURL
		self.repoName = repo.name
		self.language = repo.language ?? "No language"
		self.description = repo.description ?? "No description"
		self.starsText = pluralize(singular: "star", count: repo.stargazersCount)
		self.forksText = pluralize(singular: "fork", count: repo.forksCount)
		self.watchingText = "\(repo.watchersCount) watching"
		self.isRepoStarred = isRepoStarred
		self.repoStarToggled = repoStarToggled
	}
}

// MARK: - Helpers

private func pluralize(singular: String, count: Int) -> String {
	count == 1 ? "\(count) \(singular)" : "\(count) \(singular)s"
}
