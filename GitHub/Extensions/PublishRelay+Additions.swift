//
//  PublishRelay+Additions.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/27/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import RxRelay
import RxSwift

extension PublishRelay {
	func asObserver() -> AnyObserver<Element> {
		AnyObserver { event in
			switch event {
			case let .next(element):
				self.accept(element)
			case .completed, .error:
				break
			}
		}
	}
}
