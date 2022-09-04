//
//  SugesstionsUseCaseTests.swift
//  Trip PlannerTests
//
//  Created by Dimitar Grudev on 5.09.22.
//

import XCTest
@testable import Trip_Planner

class SugesstionsUseCaseTests: XCTestCase {

    var sut: SuggestionsUseCase!
    var repository: SuggestionsRepository = Trie()

    override func setUp() {
        sut = SuggestionsUseCase(repository, mockData)
    }

    func testAutocompleteSuggestions_forValidValueWithSingleResult_shouldReturnSingleResult() async {
        // given
        let input = "Tok"

        // when
        let result = try? await sut.execute(input)

        // then
        XCTAssertEqual(result, ["tokyo"])
    }

    func testAutocompleteSuggestions_forNonExistingValue_shouldReturnEmpty() async {
        // given
        let input = "Toka"

        // when
        let result = try? await sut.execute(input)

        // then
        XCTAssertEqual(result, [])
    }

    func testAutocompleteSuggestions_forValidValue_shouldReturnTwoResults() async {
        // given
        let input = "Lo"

        // when
        let result = try? await sut.execute(input)

        // then
        XCTAssertNotNil(result)

        // our autocomplete algorithm doesn't guarantee the order of the results, so we sort our result to easily verify it.
        let sortedResult = result!.sorted(by: { $0 < $1 })
        let expectedResult = ["london", "los angeles"]
        XCTAssertEqual(sortedResult, expectedResult)
    }

    func testAutocompleteSuggestions_forSingleChar_shouldReturnOneResults() async {
        // given
        let input = "p"

        // when
        let result = try? await sut.execute(input)

        // then
        XCTAssertEqual(result, ["porto"])
    }

    func testAutocompleteSuggestions_forEmptyInput_shouldReturnNoResults() async {
        // given
        let input = ""

        // when
        let result = try? await sut.execute(input)

        // then
        XCTAssertEqual(result, [])
    }

}
