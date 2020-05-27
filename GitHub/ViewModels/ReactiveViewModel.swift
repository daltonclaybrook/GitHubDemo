//
//  ReactiveViewModel.swift
//  GitHub
//
//  Created by Dalton Claybrook on 5/27/20.
//  Copyright © 2020 Dalton Claybrook. All rights reserved.
//

protocol ReactiveViewModel {
	associatedtype Inputs
	associatedtype Outputs

	static func transform(inputs: Inputs) -> Outputs
}
