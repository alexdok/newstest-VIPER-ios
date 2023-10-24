//
//  MainTableViewCell.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    let imageBackground: UIView = {
        let imageBackground = UIView()
        imageBackground.layer.cornerRadius = Constants.imageViewCornerRadius
        imageBackground.backgroundColor = .white
        imageBackground.clipsToBounds = true
        return imageBackground
    }()
    
    let image: UIImageView = {
        let imageCell = UIImageView()
        imageCell.layer.cornerRadius = Constants.imageViewCornerRadius
        imageCell.clipsToBounds = true
        return imageCell
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
        createShadow(for: imageBackground)
        createShadow(for: titleLabel)
        createShadow(for: linkCountLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        titleLabel.text = nil
        linkCountLabel.text = nil
    }
    
    private func createShadow(for myView: UIView) {
        switch myView {
        case is UILabel:
            myView.layer.shadowColor = UIColor.gray.cgColor
            myView.layer.shadowOffset = CGSize(width: -1, height: 2)
            myView.layer.shadowOpacity = 0.8
            myView.layer.shadowRadius = 2
            
            myView.clipsToBounds = false
            myView.layer.masksToBounds = false
        default :
            myView.layer.shadowColor = UIColor.black.cgColor
            myView.layer.shadowOffset = CGSize(width: -3, height: 3)
            myView.layer.shadowOpacity = 1
            myView.layer.shadowRadius = 4
            
            myView.clipsToBounds = false
            myView.layer.masksToBounds = false
        }
      
    }
    
    func setupValuesCell(values: MainTableViewCellModel) {
        image.image = values.image
        titleLabel.text = values.title
        linkCountLabel.text = String(values.count)
    }
    
   private func setupConstraaints() {
        [imageBackground, image, titleLabel, linkCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellItemsPadding),
            imageBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellItemsPadding),
            imageBackground.widthAnchor.constraint(equalToConstant: Constants.imageCellWidth),
            imageBackground.heightAnchor.constraint(equalToConstant: Constants.imageCellHeight),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellItemsPadding),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellItemsPadding),
            image.widthAnchor.constraint(equalToConstant: Constants.imageCellWidth),
            image.heightAnchor.constraint(equalToConstant: Constants.imageCellHeight),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellItemsPadding),
            titleLabel.leadingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: Constants.cellItemsPadding),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.cellItemsPadding),
  
            linkCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.cellItemsPadding),
            linkCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.cellItemsPadding)
        ])
    }
}
