//
//  ConversationController.swift
//  MyChatApp
//
//  Created by gadgetzone on 08/08/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationController: UIViewController {
    
    // MARK: - Properties

    let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private let newMessageButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chatico.png"), for: .normal)
        button.tintColor = .systemPink
//        button.imageView?.setDimensions(height: 80, width: 80)
//        button.layer.cornerRadius = 80 / 2
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        print("this is view did load from cnover ")
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(withTitle: "Messages", preferLargeTitles: true)
    }
    
    // MARK: - Selector
    
    @objc func showProfile() {
        let controller      = ProfileController(style: .insetGrouped )
        controller.delegate = self
        
        let nav                     = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle  = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showNewMessage() {
        let controller      = NewMessageController()
        controller.delegate = self
        
        let nav                    = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchConversations() {
        showLoader(true)
        conversations.removeAll()
        conversationsDictionary.removeAll()
        
        self.tableView.reloadData()
        
        Service.fetchConversation { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            
            self.conversations = Array(self.conversationsDictionary.values)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.showLoader(false)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        }
//        else {
//            fetchConversations()
//
//        }
    }
    
    func logout() {
        do {
            try  Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error in signing out ")
        }
    }
    
    // MARK: - Helper
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller      = LoginController()
            controller.delegate = self
            let nav                    = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        
        view.backgroundColor = .white

        configureTableView()
        
        let config = UIImage.SymbolConfiguration(pointSize  : 28,
                                                 weight     : .bold,
                                                 scale      : .unspecified)
        let profileIcon = UIImage(systemName: "person.crop.circle", withConfiguration: config )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showProfile))
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 60, width: 60)
        newMessageButton.layer.cornerRadius = 60 / 2
        newMessageButton.anchor(bottom       : view.safeAreaLayoutGuide.bottomAnchor,
                                right        : view.rightAnchor,
                                paddingBottom: 10,
                                paddingRight : 10)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight       = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate        = self
        tableView.dataSource      = self
        
        view.addSubview(tableView)
        tableView.frame           = view.frame
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
}

// MARK: - NewMessageControllerDelegate

extension ConversationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}

// MARK: - ProfileControllerDelegate

extension ConversationController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}

// MARK: - AuthenticatioDelegate

extension ConversationController: AuthenticatioDelegate {
    func authenticationComplite() {
        print("this is dlegate calllllllllllll")
        fetchConversations()
        configureUI()
        dismiss(animated: true, completion: nil)
    }
}
