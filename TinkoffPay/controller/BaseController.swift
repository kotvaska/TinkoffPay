//
// Created by Anastasia Zolotykh on 10.03.17.
// Copyright (c) 2017 chedev. All rights reserved.
//

import Foundation
import UIKit

class BaseController<P: BasePresenter>: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    typealias V = BaseView

    public var baseView: V!
    public var presenter: P!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(presenter: P, view: V, nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.presenter = presenter
        self.baseView = view

    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    func setView(baseView: V) {
        self.baseView = baseView
    }

    func setPresenter(presenter: P) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        presenter?.view = baseView as? P.V
        super.viewDidLoad()
        presenter?.viewDidLoad?()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear?()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideTitle()
        presenter?.viewDidDisappear?()
        presenter?.view = nil

        if isMovingFromParentViewController {
            baseView = nil
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.view = baseView as? P.V
        showTitle()
        hideBackButtonTitle()
        super.viewWillAppear(animated)
        presenter?.viewWillAppear?()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear?()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        baseView = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.viewDidLayoutSubviews?()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        presenter.viewWillLayoutSubviews?()
    }

    private func hideTitle() {
        baseView?.setControllerTitle(title: " ")
    }

    private func showTitle() {
        baseView?.setControllerTitle(title: presenter.controllerTitle)
    }

    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func getConfiguration() -> AppConfiguration {
        let appDelegate = getAppDelegate()
        return appDelegate.appConfiguration
    }

    func getInteractorManager() -> InteractorManager {
        return getAppDelegate().interactorManager
    }

    func getMainRouter() -> MainRouter {
        return getAppDelegate().mainRouter
    }

    func alert(title: String, text: String, okAlertHandler: AlertHandler? = nil, cancelAlertHandler: AlertHandler? = nil) {
        let alert = getConfiguration()
                .alertBuilder
                .alertControllerWithColorButtons(title: title, message: text,
                okAction: okAlertHandler, cancelAction: cancelAlertHandler)

        getMainRouter().presentAlert(in: self, alertController: alert)

    }

    func alertError(message: String) {
        alert(title: "Ошибка", text: message, okAlertHandler: AlertHandler(text: "ОК", handler: nil))
    }

    func alertOk(title: String, text: String, okAlertHandler: AlertHandler) {
        alert(title: title, text: text, okAlertHandler: okAlertHandler)
    }

    func setControllerTitle(title: String) {
        self.navigationItem.title = title
    }

    func setNeedsLayout() {
        self.view.setNeedsLayout()
    }

    func layoutIfNeeded() {
        self.view.layoutIfNeeded()
    }

    func hideBackButtonTitle() {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }

    func startLoading() {
        view.subviews.forEach({ $0.isHidden = true })
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func finishLoading() {
        view.subviews.forEach({ $0.isHidden = false })
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

}
