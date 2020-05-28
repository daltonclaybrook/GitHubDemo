//
//  FavorieReposViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/27/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import RxSwift

struct FavoriteReposViewModel {
	let favoriteRepos: Observable<[Repo]>
	let repoStarToggled: AnyObserver<Repo>
}
