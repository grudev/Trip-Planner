//
//  ConnectionsUseCase.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol UseCaseConnectionsRequestable: UseCase { }

final class ConnectionsUseCase: UseCaseConnectionsRequestable {

    typealias Response = [Connection]
    typealias Request = Selection

    private let repository: ConnectionServicable

    init(_ repository: ConnectionServicable) {
        self.repository = repository
    }

    func execute(_ request: Request) async throws -> Response {
        guard let from = request.from, let to = request.to else {
            throw ConnectionsErrors.failedToFindCheapestPath
        }
        return try repository.findCheapestPath(from: from, to: to)
    }

}

// MARK: - Connections Errors

enum ConnectionsErrors: String, Error {
    case failedToFindCheapestPath
}
