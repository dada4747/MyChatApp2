//
//  ProfileFooter.swift
//  MyChatApp
//
//  Created by gadgetzone on 15/08/21.
//

import UIKit

protocol ProfileFooterDelegate: class {
    func handleLogout()
}
class ProfileFooter: UIView {
    // MARK: - Properties
    
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var LogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(LogoutButton)
        LogoutButton.anchor(left: leftAnchor,
                            right: rightAnchor,
                            paddingLeft: 34,
                            paddingRight: 34)
        LogoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        LogoutButton.widthAnchor.constraint(equalToConstant: 300).isActive = false
        LogoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
