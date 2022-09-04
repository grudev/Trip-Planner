//
//  Data.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

struct Data: Codable {
    var connections: [Connection]
}

struct Connection: Codable {
    var from: String
    var to: String
    var coordinates: Coordinates
    var price: Double
}

struct Coordinates: Codable {
    var from: Coordinate
    var to: Coordinate
}

struct Coordinate: Codable {
    var lat: Double
    var long: Double
}
