//
//  TargetListCell.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit
import AlamofireImage

@available(iOS 9.0, *)
class TargetListCell: UITableViewCell {

    var targetInfo: TargetInfo?{
        didSet{
            guard let targetInfo = targetInfo else {return}
            if let imageURL = targetInfo.imageURL,
                let url = URL(string: imageURL){
                profileImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "icon_contactbook.png"))
            }else {
                profileImageView.image = targetInfo.image ?? #imageLiteral(resourceName: "icon_contactbook.png")
            }
            nameLabel.text = targetInfo.name
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
