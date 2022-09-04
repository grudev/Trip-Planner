//
//  ConnectionsUseCaseTests.swift
//  Trip PlannerTests
//
//  Created by Dimitar Grudev on 5.09.22.
//

import XCTest
@testable import Trip_Planner

class ConnectionsUseCaseTests: XCTestCase {

    var sut: ConnectionsUseCase!
    var repository: ConnectionServicable!

    override func setUp() {
        repository = ConnectionsService(
            withVerticesData: cities,
            mockData.connections
        )
        sut = ConnectionsUseCase(repository)
    }

    func testConnections_forValidInput_ShouldReturnCorrectRoute() async {

        // given
        let selection = Selection(from: "london", to: "sydney")
        let expectedResult = [
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
                to: "Sydney",
                coordinates: Coordinates(
                    from: Coordinate(lat: 35.652832, long: 139.839478),
                    to: Coordinate(lat: -33.865143, long: 151.2099)
                ),
                price: 100
            )
        ]

        // when
        let result = try? await sut.execute(selection)


        // then
        XCTAssertEqual(result!, expectedResult)
    }

    func testConnections_forInputNotDirectlyConnectedCities_ShouldReturnComplexRouteOfManyConnections() async {

        // given
        let selection = Selection(from: "sydney", to: "porto")
        let expectedResult = [
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
                to: "Porto",
                coordinates: Coordinates(
                    from: Coordinate(lat: 51.5285582, long: -0.241681),
                    to: Coordinate(lat: 41.14961, long: -8.61099)
                ),
                price: 50
            )
        ]

        // when
        let result = try? await sut.execute(selection)


        // then
        XCTAssertEqual(result!.count, expectedResult.count)
        XCTAssertEqual(result!, expectedResult)
    }

    func testConnections_forInputContainingNonExistingDestination_ShouldReturnEmptyRoute() async {

        // given
        let selection = Selection(from: "london", to: "mordor")
        let expectedResult: [Connection] = []

        // when
        let result = try? await sut.execute(selection)


        // then
        XCTAssertEqual(result!, expectedResult)
    }

    func testConnections_forInputContainingTwoNonExistingInputs_ShouldReturnEmptyRoute() async {

        // given
        let selection = Selection(from: "braavos", to: "mordor")
        let expectedResult: [Connection] = []

        // when
        let result = try? await sut.execute(selection)


        // then
        XCTAssertEqual(result!, expectedResult)
    }

    func testConnections_forInputContainingNonExistingSource_ShouldReturnEmptyRoute() async {

        // given
        let selection = Selection(from: "braavos", to: "new york")
        let expectedResult: [Connection] = []

        // when
        let result = try? await sut.execute(selection)


        // then
        XCTAssertEqual(result!, expectedResult)
    }

}

extension Connection: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.from == rhs.from && lhs.to == rhs.to && lhs.price == rhs.price)
    }
}
