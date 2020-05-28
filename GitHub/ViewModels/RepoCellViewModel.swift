//
//  RepoCellViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation

struct RepoCellViewModel {
	let repo: Repo
	var name: String { repo.name }
	var owner: String { repo.owner.login }
}
