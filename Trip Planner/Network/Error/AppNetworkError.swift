//
//  AppNetworkError.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

// MARK: - Network Errors

enum AppNetworkError: String, Error {
    case serverNoResponse
    case noConnection
}
