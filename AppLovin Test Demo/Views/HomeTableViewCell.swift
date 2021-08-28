//
//  HomeTableViewCell.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/27.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let g = contentView
        NSLayoutConstraint.activate([
            iconContainer.centerYAnchor.constraint(equalTo: g.centerYAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            iconContainer.widthAnchor.constraint(equalTo: g.heightAnchor, constant: -12),
            iconContainer.heightAnchor.constraint(equalTo: iconContainer.widthAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconContainer.widthAnchor, constant: -6),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            label.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: g.centerYAnchor)
        ])
        separatorInset = UIEdgeInsets(top: 0,
                                      left: 40 + iconContainer.frame.size.width,
                                      bottom: 0,
                                      right: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
    }
    
    public func configure(with model: HomeOption) {
        label.text = model.title
        label.textColor = model.titleColor
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}
