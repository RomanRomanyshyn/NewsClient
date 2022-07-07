//
//  UIStoryboard+Extension.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.indentifier) as? T else {
            fatalError()
        }
        return viewController
    }
}
