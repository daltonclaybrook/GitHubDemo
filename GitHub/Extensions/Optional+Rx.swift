//
//  Optional+Rx.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation
import RxSwift

public protocol OptionalType {
	associatedtype WrappedType
	var wrapped: WrappedType? { get }
}

extension Optional: OptionalType {
	public typealias WrappedType = Wrapped
	public var wrapped: Wrapped? {
		return self
	}
}

extension ObservableType where Element: OptionalType {
	public func unwrapped() -> Observable<Element.WrappedType> {
		return flatMap { optionalType -> Observable<Element.WrappedType> in
			if let unwrapped = optionalType.wrapped {
				return .just(unwrapped)
			} else {
				return .never()
			}
		}
	}

	public func unwrappedMap<T>(_ closure: @escaping (Element.WrappedType) -> T) -> Observable<T?> {
		return map { optionalType in
			optionalType.wrapped.map(closure)
		}
	}

	public func unwrappedFlatMap<T>(_ closure: @escaping (Element.WrappedType) -> T?) -> Observable<T?> {
		return map { optionalType in
			optionalType.wrapped.flatMap(closure)
		}
	}
}
