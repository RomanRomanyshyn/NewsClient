//
//  ViewProtocol.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import Foundation

// MARK: - ViewProtocol

protocol ViewProtocol: AnyObject {
    associatedtype Presenter
    var presenter: Presenter! { get set }
}
