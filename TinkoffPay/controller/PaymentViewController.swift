//
// Created by Anastasia Zolotykh on 28.04.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import UIKit

class PaymentViewController: BaseController<PaymentPresenter>, PaymentView {

    @IBOutlet weak var tableView: UITableView!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        refreshControl.layer.zPosition -= 1

        return refreshControl
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init() {
        super.init(nibName: "PaymentViewController", bundle: nil)

        setView(baseView: self)
        setPresenter(presenter: PaymentPresenter(view: self, paymentFacade: getInteractorManager().newNewsFacade()))

    }

    override func loadView() {
        super.loadView()

//        tableView.register(UINib(nibName: "NewsListItemCell", bundle: nil), forCellReuseIdentifier: NewsListItemCell.CELL_ID)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 427

//        tableView.dataSource = dataSource
//        tableView.delegate = delegate
        tableView.addSubview(refreshControl)
        tableView.sendSubview(toBack: refreshControl)

    }

    @objc func refresh(sender: AnyObject) {
        presenter.refresh()
    }

    func hideRefreshLoader() {
        refreshControl.endRefreshing()
    }

    func updateDataSource(news: [PaymentAccess]) {
//        dataSource.news = news
        tableView.reloadData()
    }

}
