//
//  Extensions.swift
//  MyChatApp
//
//  Created by gadgetzone on 08/08/21.
//

import UIKit
import JGProgressHUD

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

extension UIViewController {

    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        let gradiant = CAGradientLayer()
        gradiant.colors = [UIColor.systemYellow.cgColor, UIColor.systemPink.cgColor, UIColor.black.cgColor]
        gradiant.locations = [0, 0.5, 1.4]
        gradiant.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradiant.endPoint = CGPoint(x: 1.0, y: 1.0)

        view.layer.addSublayer(gradiant)
        gradiant.frame = view.frame
    }
    
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func showNotFound(_ show: Bool, withText text: String? = "NotFound") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func configureNavBar(withTitle title: String, preferLargeTitles: Bool) {
        let appearanc = UINavigationBarAppearance()
        appearanc.configureWithOpaqueBackground()
        appearanc.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearanc.backgroundImage = #imageLiteral(resourceName: "429388") 

        navigationController?.navigationBar.standardAppearance   = appearanc
        navigationController?.navigationBar.compactAppearance    = appearanc
        navigationController?.navigationBar.scrollEdgeAppearance = appearanc
        navigationController?.navigationBar.prefersLargeTitles   = preferLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor            = .white
        navigationController?.navigationBar.isTranslucent        = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Success", message: "Email is send to inbox", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
