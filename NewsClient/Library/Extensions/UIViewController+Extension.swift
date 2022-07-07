//
//  UIViewController+Extension.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

extension UIViewController {
    static var indentifier: String {
        String(describing: self)
    }
}

// MARK: - topMostViewController

extension UIViewController {
    static var topMostViewController: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        var presentedVC = keyWindow?.rootViewController
        while let controller = presentedVC?.presentedViewController {
            presentedVC = controller
        }
        return presentedVC
    }
}
