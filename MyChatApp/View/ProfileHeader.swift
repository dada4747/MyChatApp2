//
//  ProfileHeader.swift
//  MyChatApp
//
//  Created by gadgetzone on 14/08/21.
//

import UIKit
protocol ProfileHeaderDelegate: class {
    func dismissController()
}
protocol ProfileCellDelegate: class {
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) 

}
class ProfileHeader: UIView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { populateUserData() }
    }
    weak var del: ProfileCellDelegate?
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    lazy var  profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.layer.borderWidth = 4.0
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleToFill
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTapped)))
        
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "429388"))
            
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleZoomTapped(_ tapGesture: UITapGestureRecognizer) {
        print("profile view tapped")
        if let imageview = tapGesture.view as? UIImageView {
            print("imageview fghjsdfghj")
            del?.performZoomInForStartingImageView(imageview)
        }
    }
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }
    
    // MARK: - Helper
    
    func populateUserData() {
        guard let user = user else { return }
        fullNameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI() {
    
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop:  96)
        
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 24, width: 24)
        
    }
    
    
}
