//
//  MainViewController.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func finishActivityIndicator()
    func showAlert(text: AlertModel)
    func viewIsReady(images: [UIImage], titles: [String])
}

final class MainViewController: UIViewController {
    // MARK: - prop
    var presenter: MainPresenterProtocol?
    let searchBar = UISearchBar()
    let tableNews = UITableView()
    private let refreshControler = UIRefreshControl()
    private let alertBuilder = AlertBuilderImpl()
    lazy var canGiveNewCells = false
    var bottomConstraint: NSLayoutConstraint?
    var cellsNewsForTable: [MainTableViewCellModel] = []
    var indicator = ActivityIndicator()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        
        configureVC()
        createTableNews()
        configureTableNews()
        setupSearcBar()
        
        presenter?.loadFirstView()
        indicator.showLoading(onView: view)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        cellsNewsForTable.removeAll()
        presenter?.loadFirstView()
        tableNews.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       view.endEditing(true)
       bottomConstraint?.constant = 0
        UIView.animate(withDuration: Constants.standartDurationAnimation) {
            self.view.layoutIfNeeded()
        }
   }
}

// MARK: - Private functions
private extension MainViewController {
    private func setupRefreshController() {
        refreshControler.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControler.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableNews.addSubview(refreshControler)
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Loading....."
    }
    
    private func setupSearcBar() {
        searchBar.frame = CGRect(x:0, y:0, width: tableNews.frame.size.width, height:44)
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.placeholder = "search"
        
        self.tableNews.tableHeaderView = searchBar
    }
    
    private func configureTableNews() {
        tableNews.rowHeight = CGFloat(Constants.tableNewsRowHeight)
        tableNews.estimatedRowHeight = UITableView.automaticDimension
        tableNews.dataSource = self
        tableNews.delegate = self
        tableNews.register(MainTableViewCell.self)
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    func finishActivityIndicator() {
        refreshControler.endRefreshing()
    }
    
    func showAlert(text: AlertModel) {
        let alert = alertBuilder.createAlert(with: text)
        present(alert, animated: true)
    }
    
    func viewIsReady(images: [UIImage], titles: [String]) {
        guard let presenter = presenter else { return }
        let cellsModelsForTable = presenter.createCellModels(images: images, titles: titles)
        cellsNewsForTable += cellsModelsForTable
        self.navigationItem.title = "Table News"
        self.indicator.hideLoading()
        self.tableNews.reloadData()
    }
}
