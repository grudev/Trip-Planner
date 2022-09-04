//
//  NetworkManager.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol NetworkManager {

    static var session: URLSession { get }
    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }

    func request<T>(_ request: URLRequest) async throws -> T where T: Codable

}

protocol NetworkCancellable {
    var taskIdentifier: Int { get }
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

final class DefaultNetworkManager: NetworkManager {

    static var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }

    func request<T>(_ request: URLRequest) async throws -> T where T: Codable {
        let (data, reponse) = try await DefaultNetworkManager.session.data(for: request)
        // Handle response
        print("Response: \(reponse)")
        return try DefaultNetworkManager.decoder.decode(T.self, from: data)
    }

}
