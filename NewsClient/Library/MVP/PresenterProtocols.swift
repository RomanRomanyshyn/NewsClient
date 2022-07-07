//
//  PresenterProtocols.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import Foundation

protocol PresenterProtocol: AnyObject {

    associatedtype View
    associatedtype Parameters

    var view: View? { get set }

    init(parameters: Parameters, view: View)
}

// MARK: - Base presenter

protocol BasePresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
}

extension BasePresenterProtocol {
    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
}
