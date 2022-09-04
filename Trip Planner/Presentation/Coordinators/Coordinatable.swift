//
//  Coordinatable.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

protocol Coordinatable: AnyObject {
    var parentCoordinator: Coordinatable? { get set }
    var childCoordinators: [Coordinatable]? { get set }

    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }

    func start()
    func finish()

    func addChild(_ child: Coordinatable)
    func childDidFinish(_ child: Coordinatable)
}

// MARK: - Default Behaviour

extension Coordinatable {

    func start() { }

    func finish() {
        childCoordinators?.forEach{ child in
            child.parentCoordinator = nil
            child.finish()
        }
        parentCoordinator?.childDidFinish(self)
    }

    func addChild(_ child: Coordinatable) {
        if childCoordinators == nil {
            childCoordinators = [Coordinatable]()
        }
        let isFound = childCoordinators?.contains(where: { (candidate: Coordinatable) -> Bool in
            child === candidate
        }) ?? false
        guard !isFound else { return }
        childCoordinators?.append(child)
        child.parentCoordinator = self
    }

    func childDidFinish(_ child: Coordinatable) {
        childCoordinators?.removeAll(where: { (candidate: Coordinatable) -> Bool in
            child === candidate
        })
    }

}
