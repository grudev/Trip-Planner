//
//  Selection.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

struct Selection {
    var from: String?
    var to: String?
}

extension Selection {
    func isValid() -> Bool {
        return self.from != nil && self.to != nil
    }
}
