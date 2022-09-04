//
//  MainCoordinator.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit
import Combine

protocol MainCoordinatorDIContainer {

    // Search Screen
    func makeRequestDataUseCase() -> RequestDataUseCase

    func makeSearchViewModel(
        _ dataUseCase: RequestDataUseCase,
        _ suggestionsFactory: @escaping SuggestionsFactory,
        _ connectionsFactory: @escaping ConnectionsFactory
    ) -> SearchViewModel
    func makeSearchViewController(_ viewModel: SearchViewModel) -> SearchViewController

    // Result Screen
    func makeResultViewModel(_ route: [Connection]) -> ResultViewModel
    func makeResultViewController(_ viewModel: ResultViewModel) -> ResultViewController

    func makeSuggestionsUseCase(_ data: Data) -> SuggestionsUseCase
    func makeConnectionsUseCase(_ verticesData: [String],
                                _ connections: [Connection]) -> ConnectionsUseCase

}

final class MainCoordinator: Coordinatable {

    // MARK: - Properties

    private let window: UIWindow!

    private var cancellables = Set<AnyCancellable>()

    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable]?
    lazy var navigationController = UINavigationController()
    var rootViewController: UIViewController?

    // MARK: - DI Container

    private let container: MainCoordinatorDIContainer!

    // MARK: - Coordinator Lifecycle

    init(window: UIWindow?, _ container: MainCoordinatorDIContainer) {
        self.window = window
        self.container = container

        navigationController.view.backgroundColor = AppTheme.Colors.white
        navigationController.navigationBar.tintColor = AppTheme.Colors.gray
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: AppTheme.Colors.gray]
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    func start() {
        presentSearchScreen()
    }

}

extension MainCoordinator {

    func presentSearchScreen() {
        let requestDataUseCase = container.makeRequestDataUseCase()

        let viewModel = container.makeSearchViewModel(
            requestDataUseCase,
            _makeSuggestionsUseCaseFactory(),
            _makeConnectionsUseCaseFactory()
        )

        // handle any callbacks from viewModel with the help of publishers
        viewModel.validConnectionPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] route in
                self?.presentResultScreen(route)
            }
            .store(in: &cancellables)

        let viewController = container.makeSearchViewController(viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func presentResultScreen(_ route: [Connection]) {
        let viewModel = container.makeResultViewModel(route)
        let viewController = container.makeResultViewController(viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Factories

typealias SuggestionsFactory = (Data) -> SuggestionsUseCase?
typealias ConnectionsFactory = (_ verticesData: [String],
                                _ connections: [Connection]) -> ConnectionsUseCase?

private extension MainCoordinator {
    func _makeSuggestionsUseCaseFactory() -> SuggestionsFactory {
        let factory = { [weak self] (_ data: Data) -> SuggestionsUseCase? in
            guard let self = self else { return nil }
            return self.container.makeSuggestionsUseCase(data)
        }
        return factory
    }

    func _makeConnectionsUseCaseFactory() -> ConnectionsFactory {
        let factory = { [weak self] (_ verticesData: [String],
                                     _ connections: [Connection]) -> ConnectionsUseCase? in
            guard let self = self else { return nil }
            return self.container.makeConnectionsUseCase(verticesData, connections)
        }
        return factory
    }
}
