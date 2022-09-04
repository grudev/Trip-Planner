//
//  NibInstantiable.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    static var defaultFileName: String { get }
    static func instatiate(_ bundle: Bundle?) -> Self
}

public extension StoryboardInstantiable where Self: UIViewController {

    static var defaultFileName: String { .init(describing: self) }

    static func instatiate(_ bundle: Bundle?) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError(AppPresentationError.appInitialViewControllerFailed)
        }
        return vc
    }

}
