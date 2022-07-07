//
//  UIAlertController+Extension.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

extension UIAlertController {
    static func getUnlikedAlert(removeAction: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: "Attention!", message: "Do you want to stop tracking this?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive, handler: removeAction)
        let actionNo = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        return alertController
    }
}
