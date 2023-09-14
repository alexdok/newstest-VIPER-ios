//
//  MainTableView.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//
import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNewsForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MainTableViewCell
        cell.titleLabel.text = cellsNewsForTable[indexPath.row].title
        cell.imageCell.image = cellsNewsForTable[indexPath.row].image
        cell.linkCountLabel.text =  String(cellsNewsForTable[indexPath.row].count)
        cell.imageCell.backgroundColor = .green
        needMoreCells(indexPath: indexPath)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         cellsNewsForTable[indexPath.row].count += 1
        let counter = cellsNewsForTable[indexPath.row].count
        SaveManagerImpl.shared.save(cellsNewsForTable[indexPath.row].title, count: counter)
        presenter?.didNewsTapt(title: cellsNewsForTable[indexPath.row].title, image: cellsNewsForTable[indexPath.row].image)
        tableNews.reloadData()
    }
    
    func needMoreCells(indexPath: IndexPath) {
        if indexPath.row > cellsNewsForTable.count - 10 {
            canGiveNewCells = true
            print(canGiveNewCells)
        }
        if indexPath.row > cellsNewsForTable.count - 2 && canGiveNewCells {
            canGiveNewCells.toggle()
            print(canGiveNewCells)
            presenter?.needMoreCells()
        }
    }
    
    func configureTableNews() {
        tableNews.rowHeight = CGFloat(Constants.tableNewsRowHeight)
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
