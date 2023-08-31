//
//  MainViewController.swift
//  Super easy dev
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func  setupRefreshController()
    func  configureVC()
    func  viewIsReady(images: [UIImage], titles :[String])
}

class MainViewController: UIViewController {

    // MARK: - Public
    var presenter: MainPresenterProtocol?
    let tableNews = UITableView()
    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    var bottomConstraint: NSLayoutConstraint?
    let alertBuilder = AlertBuilderImpl()
    var cellModels: [MainTableViewCellViewModel] = []
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRefreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableNews.addSubview(refreshControl)
    }
    
    func configureVC() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Table News"
        createTableNews()
        configureTableNews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        tableNews.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Private functions
private extension MainViewController {
    func initialize() {
        setupRefreshController()
        configureVC()
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func viewIsReady(images: [UIImage], titles: [String]) {
        onMain {
            var imageCount = 0
            for title in titles {
                let cellModel = MainTableViewCellViewModel(title: title, image: images[imageCount], count: 0)
                imageCount += 1
                self.cellModels.append(cellModel)
            }
            self.tableNews.reloadData()
        }
    }
}

