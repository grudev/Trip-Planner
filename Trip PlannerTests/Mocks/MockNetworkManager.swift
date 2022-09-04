//
//  MockNetworkManager.swift
//  Trip PlannerTests
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation
@testable import Trip_Planner

final class MockNetworkManager: NetworkManager {

    static var session = URLSession.shared
    static var decoder = JSONDecoder()
    static var encoder = JSONEncoder()

    func request<T>(_ request: URLRequest) async throws -> T where T: Codable {
        let (data, _) = try await DefaultNetworkManager.session.data(for: request)
        return try DefaultNetworkManager.decoder.decode(T.self, from: data)
    }

}
