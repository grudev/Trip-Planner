//
//  DataRepository.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol DataRepository {
    init(_ networkManager: NetworkManager)
    func getData() async throws -> Data?
}

final class NetworkDataRepository: DataRepository {

    private var networkManager: NetworkManager!

    init(_ networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getData() async throws -> Data? {
        let request = try APIRouter.connections.asURLRequest()
        return try await networkManager.request(request)
    }

}
