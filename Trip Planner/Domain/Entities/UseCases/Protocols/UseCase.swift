//
//  UseCase.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol UseCase {

    associatedtype Response
    associatedtype Request

    typealias CompletionHandler = (_ result: Result<Response, Error>) -> Void

    func execute(_ request: Request) async throws -> Response

}
