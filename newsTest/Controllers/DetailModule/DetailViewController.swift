//
//  DetailViewController.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    func setValuesToViewController(viewModel: ViewModelForDetailView)
}

final class DetailViewController: UIViewController {

    var presenter: DetailPresenterProtocol?
    
    var urlToFullNews: String?
    var urlToImage: String?
    var labelTitle = UILabel()
    var labelDetailNews = UILabel()
    var labelDateNews = UILabel()
    var labelNewsSource = UILabel()
    let button = UIButton()
    var imageView = UIImageView()
    let labelLoading = UILabel()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initialize()
        presenter?.viewDidLoaded()
    }
    
    @objc func buttonTapped() {
        animationTap()
        presenter?.didTapButtonToFullNews()
    }
    
    deinit {
        print("---------------------------Detail controller was DEINITED--------------------------------")
    }
}

// MARK: - Private functions
private extension DetailViewController {
    func initialize() {
        setupConstraints()
        setupButton()
    }
    
    private func animationTap() {
        UIView.animate(withDuration: 0.3) {
            self.button.backgroundColor = .green
        } completion: { _ in
            self.button.backgroundColor = .red
        }
    }
    
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func setValuesToViewController(viewModel: ViewModelForDetailView) {
        imageView.image = viewModel.image
        labelTitle.text = viewModel.title
        labelDateNews.text = viewModel.publishedAt
        labelNewsSource.text = viewModel.author
        labelDetailNews.text = viewModel.description
        urlToFullNews = viewModel.url
    }
    

}

extension DetailViewController {
    // MARK: - set constraints
    func setupConstraints() {
        setupButton()
        [labelTitle, labelDetailNews, labelDateNews, labelNewsSource].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            $0.numberOfLines = 10
            $0.textColor = .black
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            view.addSubview($0)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
 
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelDetailNews.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            labelDetailNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelDetailNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelDateNews.topAnchor.constraint(equalTo: labelDetailNews.bottomAnchor, constant: 16),
            labelDateNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelDateNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            labelNewsSource.topAnchor.constraint(equalTo: labelDateNews.bottomAnchor, constant: 16),
            labelNewsSource.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelNewsSource.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupButton() {
        button.setTitle("Go to full news", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

struct ViewModelForDetailView {
    var author: String
    var title: String
    var description: String
    var url: String
    var image: UIImage
    var publishedAt: String
    var content: String
}
