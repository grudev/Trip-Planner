//
//  MockedData.swift
//  Trip PlannerTests
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

@testable import Trip_Planner

let cities = ["london", "tokyo", "porto", "sydney", "cape town", "new york", "los angeles", ""]

var mockData = Data(connections: [
    Connection(
        from: "London",
        to: "Tokyo",
        coordinates: Coordinates(
            from: Coordinate(lat: 51.5285582, long: -0.241681),
            to: Coordinate(lat: 35.652832, long: 139.839478)
        ),
        price: 220
    ),
    Connection(
        from: "Tokyo",
        to: "London",
        coordinates: Coordinates(
            from: Coordinate(lat: 35.652832, long: 139.839478),
            to: Coordinate(lat: 51.5285582, long: -0.241681)
        ),
        price: 200
    ),
    Connection(
        from: "London",
        to: "Porto",
        coordinates: Coordinates(
            from: Coordinate(lat: 51.5285582, long: -0.241681),
            to: Coordinate(lat: 41.14961, long: -8.61099)
        ),
        price: 50
    ),
    Connection(
        from: "Tokyo",
        to: "Sydney",
        coordinates: Coordinates(
            from: Coordinate(lat: 35.652832, long: 139.839478),
            to: Coordinate(lat: -33.865143, long: 151.2099)
        ),
        price: 100
    ),
    Connection(
        from: "Sydney",
        to: "Cape Town",
        coordinates: Coordinates(
            from: Coordinate(lat: -33.865143, long: 151.2099),
            to: Coordinate(lat: -33.918861, long: 18.4233)
        ),
        price: 200
    ),
    Connection(
        from: "Cape Town",
        to: "London",
        coordinates: Coordinates(
            from: Coordinate(lat: -33.918861, long: 18.4233),
            to: Coordinate(lat: 51.5285582, long: -0.241681)
        ),
        price: 800
    ),
    Connection(
        from: "London",
        to: "New York",
        coordinates: Coordinates(
            from: Coordinate(lat: 51.5285582, long: -0.241681),
            to: Coordinate(lat: 40.73061, long: -73.935242)
        ),
        price: 400
    ),
    Connection(
        from: "New York",
        to: "Los Angeles",
        coordinates: Coordinates(
            from: Coordinate(lat: 40.73061, long: -73.935242),
            to: Coordinate(lat: 34.052235, long: -118.243683)
        ),
        price: 400
    ),
    Connection(
        from: "Los Angeles",
        to: "Tokyo",
        coordinates: Coordinates(
            from: Coordinate(lat: 40.73061, long: -73.935242),
            to: Coordinate(lat: 35.652832, long: 139.839478)
        ),
        price: 150
    )
])
