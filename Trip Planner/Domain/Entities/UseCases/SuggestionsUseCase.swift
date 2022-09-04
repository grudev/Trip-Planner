//
//  SuggestionsUseCase.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

protocol UseCaseSuggestionsRequestable: UseCase {
    init(_ repository: SuggestionsRepository, _ data: Data)
    func isValidWord(_ word: String) async throws -> Bool
    func words() -> [String]
}

final class SuggestionsUseCase: UseCaseSuggestionsRequestable {

    typealias Response = [String]
    typealias Request = String

    private let repository: SuggestionsRepository

    init(_ repository: SuggestionsRepository, _ data: Data) {
        self.repository = repository
        Task { await populate(data) }
    }

    func execute(_ request: Request) async throws -> Response {
        guard !request.isEmpty else { return [] }
        return repository.findWordsWithPrefix(prefix: request)
    }

    func isValidWord(_ word: String) async throws -> Bool {
        guard !word.isEmpty else { return false }
        return repository.contains(word: word, matchPrefix: false)
    }

    func words() -> [String] {
        return repository.words
    }

}

// MARK: - Suggestions Private Methods

private extension SuggestionsUseCase {

    func populate(_ data: Data) async {
        data.connections.forEach { connection in
            repository.insert(word: connection.from)
            repository.insert(word: connection.to)
        }
    }

}
