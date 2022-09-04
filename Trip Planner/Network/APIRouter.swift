//
//  APIRouter.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

enum APIRouter {

    static let baseUrl = "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/"

    case connections

    private var method: String {
        switch self {
        // MARK: - handle more http methods
        default:
            return "GET"
        }
    }

    private var path: String {
        switch self {
        case .connections:
            return "/connections.json"
        }
    }

    private var parameters: [String: String]? {
        switch self {
        // MARK: - add quary parameters to the endpoint
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {

        guard var components = URLComponents(string: APIRouter.baseUrl) else { throw AppDomainError.failedToResolveUrl }

        var urlQueryItems = components.queryItems ?? [URLQueryItem]()
        parameters?.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }

        components.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = components.url else { throw AppDomainError.failedToResolveUrl }

        var urlRequest = URLRequest(url: url.absoluteURL.appendingPathComponent(path))
        urlRequest.httpMethod = method

        return urlRequest

    }
}
