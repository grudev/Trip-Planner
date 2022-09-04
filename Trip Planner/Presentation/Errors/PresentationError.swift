//
//  PresentationError.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

enum AppPresentationError: String, Error {
    case appWindowFailedToCreate = "app.presentation.window-failed-to-create"
    case appInitialViewControllerFailed = "app.presentation.initial-view-controller-failed"
}

func fatalError(_ error: AppPresentationError) -> Never {
    fatalError("ERROR: \(error.rawValue)")
}
