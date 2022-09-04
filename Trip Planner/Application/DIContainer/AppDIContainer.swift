//
//  AppDIContainer.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

final class AppDIContainer {

    // Add App Storages, Services, Network Managers etc.
    // Handle object instances, control their lifecycle, reuse them from memory pool or dispose them

    private let networkManager: NetworkManager = DefaultNetworkManager()
    private lazy var suggestionsRepository: SuggestionsRepository = Trie()

}

// MARK: - MainCoordinatorDIContainer

extension AppDIContainer: MainCoordinatorDIContainer {

    func makeSearchViewModel(
        _ dataUseCase: RequestDataUseCase,
        _ suggestionsFactory: @escaping SuggestionsFactory,
        _ connectionsFactory: @escaping ConnectionsFactory
    ) -> SearchViewModel {
        SearchViewModel(dataUseCase, suggestionsFactory, connectionsFactory)
    }

    func makeRequestDataUseCase() -> RequestDataUseCase {
        RequestDataUseCase(makeDataRepository())
    }

    func makeSuggestionsUseCase(_ data: Data) -> SuggestionsUseCase {
        SuggestionsUseCase(suggestionsRepository, data)
    }

    func makeConnectionsUseCase(_ verticesData: [String],
                                _ connections: [Connection]) -> ConnectionsUseCase {
        let service = makeConnectionsService(verticesData, connections)
        return ConnectionsUseCase(service)
    }

    func makeSearchViewController(_ viewModel: SearchViewModel) -> SearchViewController {
        let viewController = SearchViewController.instatiate(nil)
        viewController.viewModel = viewModel
        viewController.styles = AppTheme.makeSearchScreenStyles()
        return viewController
    }

    func makeResultViewModel(_ route: [Connection]) -> ResultViewModel {
        ResultViewModel(route)
    }

    func makeResultViewController(_ viewModel: ResultViewModel) -> ResultViewController {
        let viewController = ResultViewController.instatiate(nil)
        viewController.viewModel = viewModel
        viewController.styles = AppTheme.makeResultScreenStyles()
        return viewController
    }

    func makeSuggestionsRepository() -> SuggestionsRepository {
        suggestionsRepository
    }

}

// MARK: - Repositories && Services -

private extension AppDIContainer {
    func makeDataRepository() -> DataRepository {
        NetworkDataRepository(networkManager)
    }

    func makeConnectionsService(
        _ verticesData: [String],
        _ connections: [Connection]) -> ConnectionServicable {
            ConnectionsService(withVerticesData: verticesData, connections)
    }
}
