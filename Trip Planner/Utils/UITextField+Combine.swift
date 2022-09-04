//
//  UITextField+Combine.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }

}
