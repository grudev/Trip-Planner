//
//  AppDomainErrors.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

// MARK: - Domain Errors

enum AppDomainError: Error {
    case failedToResolveUrl
    case failedToDecode
}
