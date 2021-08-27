//
//  ForgetPasswordController.swift
//  MyChatApp
//
//  Created by gadgetzone on 18/08/21.
//

import UIKit
import JGProgressHUD
import  Firebase

class ForgetPasswordController: UIViewController {
    // MARK: - Properties
    
    private var viewModel               =  ForgetPasswordViewModel()
    weak var delegate                   : AuthenticatioDelegate?

    private lazy var emailContainerView : UIView = {
        return InputContainerView(image : #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private let emailTextField          = CustomTextField(placeholder: "Email")

    private let sendButton: UIButton    = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Go back? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
            attributedTitle.append(NSAttributedString(string: "Log In",
                                                      attributes:  [.font: UIFont.boldSystemFont(ofSize: 16),
                                                                    .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: - Selector
    
    @objc func handleReset() {
        guard let email = emailTextField.text else { return }
        showLoader(true, withText: "Sending....")

        AuthService.shared.resetePassword(email: email) {
            self.view.endEditing(true)
            self.showSuccessAlert()
        } onError: { errorMessage in
            self.showError(errorMessage)
        }
        self.showLoader(false)
    }

    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    
    func configureUI() {
        
        configureGradientLayer()
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   sendButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top         : view.topAnchor,
                     left        : view.leftAnchor,
                     right       : view.rightAnchor,
                     paddingTop  : 100,
                     paddingLeft : 32,
                     paddingRight: 32)
        
        view.addSubview(alreadyHaveAccButton)
        alreadyHaveAccButton.anchor(top         :stack.bottomAnchor,
                                    left        : view.leftAnchor,
                                    right       : view.rightAnchor,
                                    paddingLeft : 32,
                                    paddingRight: 32)
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } 
        checkFormStatus()
    }
}

// MARK: - AuthenticationControllerProtocol

extension ForgetPasswordController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            sendButton.isEnabled        = true
            sendButton.backgroundColor  = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            sendButton.isEnabled        = false
            sendButton.backgroundColor  = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
   }
