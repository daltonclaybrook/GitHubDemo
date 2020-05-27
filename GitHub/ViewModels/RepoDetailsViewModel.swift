//
//  RepoDetailsViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation

struct RepoDetailsViewModel {
	let ownerName: String
	let ownerImageURL: URL
	let repoName: String
	let language: String
	let description: String
	let starsText: String
	let forksText: String
	let watchingText: String
}

extension RepoDetailsViewModel {
	init(repo: Repo) {
		self.ownerName = repo.owner.login
		self.ownerImageURL = repo.owner.avatarURL
		self.repoName = repo.name
		self.language = repo.language ?? "No language"
		self.description = repo.description ?? "No description"
		self.starsText = pluralize(singular: "star", count: repo.stargazersCount)
		self.forksText = pluralize(singular: "fork", count: repo.forksCount)
		self.watchingText = "\(repo.watchersCount) watching"
	}
}

// MARK: - Helpers

private func pluralize(singular: String, count: Int) -> String {
	count == 1 ? "\(count) \(singular)" : "\(count) \(singular)s"
}
