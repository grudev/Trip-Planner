//
//  SearchViewModel.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation
import Combine

protocol SearchViewModelOutput {
    var validConnectionPublisher: AnyPublisher<[Connection], Never> { get }
}

protocol SearchViewModelInput {

    var title: String { get }
    var selectionPublisher: Published<Selection>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    func loadData()
    func getSuggestions(_ word: String) async throws -> [String]
    func updateFromSelection(_ destination: String)
    func updateToSelection(_ destination: String)
    func isValidWord(_ word: String) async throws -> Bool
    func haveValidSelection(_ selection: Selection)

}

final class SearchViewModel {

    private let requestDataUseCase: RequestDataUseCase
    private var suggestionsUseCase: SuggestionsUseCase?
    private var connectionsUseCase: ConnectionsUseCase?

    private let suggestionsFactory: SuggestionsFactory
    private let connectionsFactory: ConnectionsFactory

    private var connectionsData: [Connection]?

    init(
        _ requestDataUseCase: RequestDataUseCase,
        _ suggestionsFactory: @escaping SuggestionsFactory,
        _ connectionsFactory: @escaping ConnectionsFactory
    ) {
        self.requestDataUseCase = requestDataUseCase
        self.suggestionsFactory = suggestionsFactory
        self.connectionsFactory = connectionsFactory
    }

    // MARK: - Model Input Stored Properties

    @Published var selection = Selection(from: nil, to: nil)
    @Published var error: Error? = nil

    // MARK: - Model Output Stored Properties

    @Published var validConnection: [Connection]?

}

extension SearchViewModel: SearchViewModelInput {

    var title: String { "Find cheapest route" }

    var selectionPublisher: Published<Selection>.Publisher { $selection }
    var errorPublisher: Published<Error?>.Publisher { $error }

    func loadData() {
        Task {
            do {
                let data = try await requestDataUseCase.execute(nil)
                self.connectionsData = data?.connections
                guard let data = data else { return }
                suggestionsUseCase = suggestionsFactory(data)
            } catch let error {
                self.error = error
            }
        }
    }

    // Get Suggestions based on what user typed in search fields

    func getSuggestions(_ word: String) async throws -> [String] {
        try await suggestionsUseCase?.execute(word) ?? []
    }

    // Update selection

    func updateFromSelection(_ destination: String) {
        selection.from = destination.lowercased()
    }

    func updateToSelection(_ destination: String) {
        selection.to = destination.lowercased()
    }

    // Validate if a word is a valid destination

    func isValidWord(_ word: String) async throws -> Bool {
        try await suggestionsUseCase?.isValidWord(word) ?? false
    }

    // When 2 valid destinations present as selection,
    // find valid connections and calculate cheapest route.
    // Trigger navigation to result screen with found route.

    func haveValidSelection(_ selection: Selection) {

        if connectionsUseCase == nil {
            connectionsUseCase = connectionsFactory(
                suggestionsUseCase?.words() ?? [],
                connectionsData ?? []
            )
        }

        Task {
            do {
                validConnection = try await connectionsUseCase?.execute(selection)
            } catch let error {
                self.error = error
            }
        }
    }

}

extension SearchViewModel: SearchViewModelOutput {

    var validConnectionPublisher: AnyPublisher<[Connection], Never> {
        $validConnection
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }

}
