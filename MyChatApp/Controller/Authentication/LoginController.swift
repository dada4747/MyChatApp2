//
//  LoginController.swift
//  MyChatApp
//
//  Created by gadgetzone on 08/08/21.
//

import UIKit
import Firebase
import JGProgressHUD

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

protocol AuthenticatioDelegate: class {
    func authenticationComplite()
}
class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LogInViewModel()
    
    weak var delegate     : AuthenticatioDelegate?
    
    private let iconImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chatIcon2.png")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"),
                                  textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                  textField: passTextField)
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Forget password? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Reset Password",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
    }()
    
    
    private let dontHaveAccButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign UP",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectore
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        showLoader(true, withText: "Logging In")
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showError(error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.authenticationComplite()
            //self.dismiss(animated: true, completion: nil)
            self.showLoader(false)

        }
    }
    @objc func handleShowResetPassword() {
        let vc = ForgetPasswordController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleShowSignup() {
        let vc = RegistrationController()
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    // MARK: - Helper

    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    
        configureGradientLayer()
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 200, width: 300)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.anchor(top:stack.bottomAnchor,
                                    left:view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingLeft: 32,
                                    paddingRight: 32)
        
        view.addSubview(dontHaveAccButton)
        dontHaveAccButton.anchor(left: view.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingLeft: 32,
                                 paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
}

// MARK: - AuthenticationControllerProtocol

extension LoginController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled       = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            loginButton.isEnabled       = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
