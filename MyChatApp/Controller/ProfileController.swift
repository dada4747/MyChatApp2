//
//  ProfileController.swift
//  MyChatApp
//
//  Created by gadgetzone on 14/08/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileController : UITableViewController {
    
    // MARK: - Properties
    var startingFrame       : CGRect?
    var blackBackgroundView : UIView?
    var startingImageView   : UIImageView?
    
    
    weak var delegate   : ProfileControllerDelegate?
    private var  user   : User? {
        didSet{ headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0,
                                                             y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    private let footerView      = ProfileFooter()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        showLoader(true)
        Service.fetchuser(withUid: uid) { user in
            self.showLoader(false)
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.delegate       = self
        headerView.del = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight       = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        footerView.delegate       = self
        footerView.frame          = .init(x      : 0,
                                          y      : 0,
                                          width  : view.frame.width,
                                          height : 100)
        
        tableView.tableFooterView = footerView

 
    }
}

// MARK: - UITableViewDataSource

extension ProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        print("DEBUGE: hancle action\(viewModel.description)")
        switch viewModel {
        case .accountInfo:
            print("this is account info page......")
        case .settings:
            print("this is settings page .....")
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileFooterDelegate

extension ProfileController: ProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure want to Logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "LogOut", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileController: ProfileCellDelegate {
    
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
            print("print is profile delegate")
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            let zoomingImageView                      = UIImageView(frame: startingFrame!)
            zoomingImageView.backgroundColor          = UIColor.red
            zoomingImageView.image                    = startingImageView.image
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            if let keyWindow                          = UIApplication.shared.keyWindow {
                blackBackgroundView                   = UIView(frame: keyWindow.frame)
                blackBackgroundView?.backgroundColor  = UIColor.black
                blackBackgroundView?.alpha            = 0
                keyWindow.addSubview(blackBackgroundView!)
                
                keyWindow.addSubview(zoomingImageView)
                
                UIView.animate(withDuration          : 0.5,
                               delay                 : 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity : 1,
                               options               : .curveEaseOut,
                               animations: {
                                
                                self.blackBackgroundView?.alpha = 1
                                self.tableView.alpha = 0
                    
                                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    
                                zoomingImageView.frame = CGRect(x       : 0,
                                                                y       : 0,
                                                                width   : keyWindow.frame.width,
                                                                height  : height)
                    
                                zoomingImageView.center = keyWindow.center
                    
                               }, completion: { (completed) in
                                
                               }
                )
            }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView                 = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds      = true
            
            UIView.animate(withDuration             : 0.5,
                           delay                    : 0,
                           usingSpringWithDamping   : 1,
                           initialSpringVelocity    : 1,
                           options                  : .curveEaseOut,
                           animations               : {
                
                            zoomOutImageView.frame          = self.startingFrame!
                            self.blackBackgroundView?.alpha = 0
                            self.tableView.alpha      = 1
                
                           }, completion: { (completed) in
                            zoomOutImageView.removeFromSuperview()
                            self.startingImageView?.isHidden = false
                           }
            )
        }
    }
}
