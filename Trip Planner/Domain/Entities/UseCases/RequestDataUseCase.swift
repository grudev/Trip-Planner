//
//  RequestDataUseCase.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol UseCaseDataRequestable: UseCase { }

final class RequestDataUseCase: UseCaseDataRequestable {

    typealias Response = Data?
    typealias Request = Void?

    private let repository: DataRepository

    private var connections = [Connection]()

    init(_ repository: DataRepository) {
        self.repository = repository
    }

    func execute(_ request: Request) async throws -> Response {
        return try await repository.getData()
    }

}
