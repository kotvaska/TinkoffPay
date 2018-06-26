//
// Created by Maksim Kirilovskikh on 18.12.16.
// Copyright (c) 2016 chedev. All rights reserved.
//

import Foundation

@objc protocol BasePresenterProtocol {

    var controllerTitle: String { get set }

    @objc optional func viewDidLoad()

    @objc optional func viewDidAppear()

    @objc optional func viewDidDisappear()

    @objc optional func viewWillAppear()

    @objc optional func viewWillDisappear()

    @objc optional func viewDidLayoutSubviews()

    @objc optional func viewWillLayoutSubviews()

    @objc optional func setView(view: Any?)

}

protocol BasePresenter: BasePresenterProtocol {

    associatedtype V

    var view: V! { get set }

    init(view: V)

}

extension BasePresenter {

    func setView(view: BaseView?) {
        self.view = view as? V
    }

}
