//
//  Identifiable.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

public protocol Identifiable {
    static var uniqueIdentifier: String { get }
}

public extension Identifiable {
    static var uniqueIdentifier: String { String(describing: self) }
}

extension NSObject: Identifiable { }
