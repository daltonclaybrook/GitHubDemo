//
//  RepoCellViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation

struct RepoCellViewModel {
	let name: String
	let owner: String
}

extension RepoCellViewModel {
	init(repo: Repo) {
		self.name = repo.name
		self.owner = repo.owner.login
	}
}
