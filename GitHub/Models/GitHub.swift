//
//  GitHub.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation

struct ReposResponse: Decodable {
	let totalCount: Int
	let items: [Repo]

	private enum CodingKeys: String, CodingKey {
		case totalCount = "total_count"
		case items
	}
}

typealias RepoID = Int

struct Repo: Decodable {
	let id: RepoID
	let name: String
	let description: String?
	let url: URL
	let language: String?
	let owner: Owner
	let stargazersCount: Int
	let watchersCount: Int
	let forksCount: Int
	let sizeInKb: Int

	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case url
		case language
		case owner
		case stargazersCount = "stargazers_count"
		case watchersCount = "watchers_count"
		case forksCount = "forks_count"
		case sizeInKb = "size"
	}
}

struct Owner: Decodable {
	let id: Int
	let login: String
	let url: URL
	let avatarURL: URL

	private enum CodingKeys: String, CodingKey {
		case id
		case login
		case url
		case avatarURL = "avatar_url"
	}
}
