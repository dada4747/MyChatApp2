//
//  UserCell.swift
//  MyChatApp
//
//  Created by gadgetzone on 11/08/21.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView =  {
        let iv              = UIImageView()
        iv.backgroundColor  = UIColor(patternImage: UIImage(named: "profile.png")!)
        iv.contentMode      = .scaleToFill
        iv.clipsToBounds    = true
        return iv
    }()
    private let usernameLabel: UILabel = {
        let label   = UILabel()
        label.font  = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let fullNameLabel: UILabel = {
        let label       = UILabel()
        label.font      = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        profileImageView.centerY(inView     : self,
                                 leftAnchor : leftAnchor,
                                 paddingLeft: 12)
        profileImageView.setDimensions(height: 56,
                                       width : 56 )
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack       = UIStackView(arrangedSubviews: [usernameLabel, fullNameLabel])
        stack.axis      = .vertical
        stack.spacing   = 2
        
        addSubview(stack)
        stack.centerY(inView     : profileImageView,
                      leftAnchor : profileImageView.rightAnchor,
                      paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func  configure() {
        guard  let user     = user else { return }
        fullNameLabel.text  = user.fullname
        usernameLabel.text  = user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
}
