//
//  MainTableViewCell.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    let imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 6
        label.font = .systemFont(ofSize: 14)
        label.minimumScaleFactor = 8
        return label
    }()
    
    var linkCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.contentMode = .right
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraaints()
    }
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = nil
        titleLabel.text = nil
        linkCountLabel.text = nil
    }
    
    func setupValuesCell(values: MainTableViewCellViewModel) {
        imageCell.image = values.image
        titleLabel.text = values.title
        linkCountLabel.text = String(values.count)
    }
    
   private func setupConstraaints() {
        [imageCell, titleLabel, linkCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageCell.widthAnchor.constraint(equalToConstant: 150),
            imageCell.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
  
            linkCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            linkCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
