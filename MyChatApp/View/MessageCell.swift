//
//  MessageCell.swift
//  MyChatApp
//
//  Created by gadgetzone on 12/08/21.
//

import UIKit

protocol MessageCellViewDelegate: class {
    func performZoomInForStartingImageView(_ startingImageView: UIImageView)
}

class MessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: MessageCellViewDelegate?
    
    var message: Message? {
        didSet { configure() }
    }

    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var  messageImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false 
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .clear
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTapped)))
        
        return iv
    }()
    
     let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
     let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor,
                                bottom: bottomAnchor,
                                paddingLeft: 8,
                                paddingBottom: -4)
        
        profileImageView.setDimensions(height: 32,
                                       width : 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor,
                               bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo : profileImageView.rightAnchor,
                                                                 constant: 12)
        bubbleLeftAnchor.isActive = false
        bubbleRightAnchor         = bubbleContainer.rightAnchor.constraint(equalTo : rightAnchor,
                                                                           constant: -12)
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        left: bubbleContainer.leftAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingTop: 4,
                        paddingLeft: 12,
                        paddingBottom: 4,
                        paddingRight: 12)
        
        bubbleContainer.addSubview(messageImageView)
        messageImageView.anchor(top:bubbleContainer.topAnchor,
                                left: bubbleContainer.leftAnchor,
                                bottom: bubbleContainer.bottomAnchor,
                                right: bubbleContainer.rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0)
        //messageImageView.setDimensions(height: 200, width: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleZoomTapped(_ tapGesture: UITapGestureRecognizer) {
        if let imageview = tapGesture.view as? UIImageView {
            delegate?.performZoomInForStartingImageView(imageview)
        }
    }
    
    // MARK: - Helper
    
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
                
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive

        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        messageImageView.sd_setImage(with: viewModel.messageImage)
    }
}
