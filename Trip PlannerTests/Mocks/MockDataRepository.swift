//
//  MocNetworkRepository.swift
//  Trip PlannerTests
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation
@testable import Trip_Planner

final class MockDataRepository: DataRepository {

    private var networkManager: NetworkManager!

    init(_ networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getData() async throws -> Trip_Planner.Data? {
        let request = try APIRouter.connections.asURLRequest()
        return try await networkManager.request(request)
    }

}

