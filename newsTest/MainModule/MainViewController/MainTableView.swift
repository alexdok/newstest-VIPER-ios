//
//  MainTableView.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MainTableViewCell
        cell.titleLabel.text = cellModels[indexPath.row].title
        cell.imageCell.image = cellModels[indexPath.row].image
        cell.linkCountLabel.text =  String(cellModels[indexPath.row].count)
        cell.imageCell.backgroundColor = .green
        needMoreCells(indexPath: indexPath)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellModels[indexPath.row].count += 1
        presenter?.didNewsTapt(title: cellModels[indexPath.row].title, image: cellModels[indexPath.row].image)
        tableNews.reloadData()
    }
    
    func needMoreCells(indexPath: IndexPath) {
        if  indexPath.row > cellModels.count - 2 {
            print("\(indexPath.row)")
        }
    }
    
    func configureTableNews() {
        tableNews.rowHeight = 150
        tableNews.estimatedRowHeight = UITableView.automaticDimension
        tableNews.dataSource = self
        tableNews.delegate = self
        tableNews.register(MainTableViewCell.self)
    }
}

extension MainViewController {
    // setup constraints
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
