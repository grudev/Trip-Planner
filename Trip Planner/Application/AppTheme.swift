//
//  AppTheme.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

final class AppTheme {

    // MARK: - Color Definitions

    struct Colors {

        static let red = UIColor.red
        static let white = UIColor.white
        static let blue = UIColor.systemBlue
        static let gray = UIColor.darkGray
        static let lightGray = UIColor.lightGray

        struct Text {
            static var `default`: UIColor { gray }
        }

    }

    struct Text {
        static func appFont(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size)
        }
    }

    // MARK: - Apply General Theme

    static func applyGeneralTheme() {
        UINavigationBar.appearance().barTintColor = Colors.red
        UINavigationBar.appearance().tintColor = Colors.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.white
        ]
        UINavigationBar.appearance().isTranslucent = false

        UIToolbar.appearance().barTintColor = Colors.red
        UIToolbar.appearance().tintColor = Colors.red
    }

}

// MARK: - Search Screen Styles

extension AppTheme {

    static func makeSearchScreenStyles() -> SearchScreenStyles {
        SearchViewController.DefaultSearchScreenStyles(backgroundColor: Colors.white)
    }

    static func makeResultScreenStyles() -> ResultScreenStyles {
        ResultViewController.DefaultResultViewStyles.init(backgroundColor: .white)
    }

}
