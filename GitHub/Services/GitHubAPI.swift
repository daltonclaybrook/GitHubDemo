//
//  GitHubAPI.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/25/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

import Foundation
import RxSwift

struct GitHubAPI {
	private static let baseURLComponents = URLComponents(string: "https://api.github.com")!

	enum Error: Swift.Error {
		case nonSuccessStatusCode(code: Int)
		case requestError(Swift.Error)
		case decodeError(Swift.Error)
		case unknownError
	}

	static func makeSingleForSearchRepos(query: String) -> Single<ReposResponse> {
		return Single.create { subscriber in
			let request = makeSearchRequest(query: query)
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				let result: Result<ReposResponse, Error> = handleResponse(data: data, response: response, error: error)
				switch result {
				case let .success(response):
					subscriber(.success(response))
				case let .failure(error):
					subscriber(.failure(error))
				}
			}
			task.resume()
			return Disposables.create {
				task.cancel()
			}
		}
	}

	// MARK: - Helpers

	private static func makeSearchRequest(query: String) -> URLRequest {
		let queryString = query.components(separatedBy: .whitespacesAndNewlines).joined(separator: "+")
		var components = baseURLComponents
		components.path = "/search/repositories"
		components.queryItems = [
			URLQueryItem(name: "q", value: queryString),
			URLQueryItem(name: "sort", value: "stars")
		]
		var request = URLRequest(url: components.url!)
		request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		return request
	}

	private static func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> Result<T, Error> {
		if let error = error {
			return .failure(.requestError(error))
		}
		guard let response = response as? HTTPURLResponse, let data = data else {
			return .failure(.unknownError)
		}
		guard (200..<300).contains(response.statusCode) else {
			return .failure(.nonSuccessStatusCode(code: response.statusCode))
		}
		do {
			let resultObject = try JSONDecoder().decode(T.self, from: data)
			return .success(resultObject)
		} catch let decodeError {
			return .failure(.decodeError(decodeError))
		}
	}
}
