//
//  ResultViewModel.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit
import Combine

protocol ResultViewModelOutput { }

protocol ResultViewModelInput {

    var title: String { get }

    var routePublisher: Published<[Connection]>.Publisher { get }

}

final class ResultViewModel {

    @Published private var route: [Connection]

    init(_ route: [Connection]) {
        self.route = route
    }

}

extension ResultViewModel: ResultViewModelInput {

    var title: String {
        "From \(route.first?.from ?? "") to \(route.last?.to ?? "") for $\(priceFor(route: route))"
    }

    var routePublisher: Published<[Connection]>.Publisher { $route }

}

extension ResultViewModel: ResultViewModelOutput {

}

private extension ResultViewModel {
    func priceFor(route: [Connection]) -> Double {
        var totalPrice: Double = 0
        route.forEach { totalPrice += $0.price }
        return totalPrice
    }
}
