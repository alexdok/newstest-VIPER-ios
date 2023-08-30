//
//  MainTableView.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import UIKit

extension MainViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { print("fatalError(canot create cell)")
            return UITableViewCell()
        }
        cell.linkCountLabel.text = "asasfasfas"
        cell.titleLabel.text = "TITLE TESST"
        cell.imageCell.backgroundColor = .green
            return cell
    }
    
    func configureTableNews() {
        tableNews.rowHeight = 150
        tableNews.estimatedRowHeight = UITableView.automaticDimension
        tableNews.dataSource = self
        tableNews.delegate = self
        tableNews.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func createTableNews() {
        view.addSubview(tableNews)
        view.addSubview(searchBar)
        tableNews.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        
        bottomConstraint = searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableNews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableNews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            tableNews.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableNews.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
