//
//  AppInitialiser.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

protocol Appinitialising: AnyObject {
    init(window: UIWindow, _ container: MainCoordinatorDIContainer)
}

final class AppInitialiser: Appinitialising {

    private let window: UIWindow
    private let container: MainCoordinatorDIContainer
    private lazy var coordinator = MainCoordinator(window: window, container)

    init(window: UIWindow, _ container: MainCoordinatorDIContainer) {
        self.window = window
        self.container = container
    }

    func initialise(_ app: UIApplication, _ options: [UIApplication.LaunchOptionsKey: Any]?) {
        setupThirdPartyLibraries(app, options)
        AppTheme.applyGeneralTheme()
        coordinator.start()
    }

}

private extension AppInitialiser {
    func setupThirdPartyLibraries(_ app: UIApplication, _ options: [UIApplication.LaunchOptionsKey: Any]?) {
        // MARK: - setup third party libraries, SDKs, dependencies etc.
        // Everything that will be persisted trough the app session
    }
}
