//
//  ViewController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 28/09/2022.
//

import UIKit
import Firebase

class MessagesController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatTableView()

        checkIfUserIsLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // checkIfUserIsLoggedIn()
    }
        
    var messageList: [Message] = [Message]()
    var messagesDictionary = [String: Message]()
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func setupChatTableView() {
        view.addSubview(chatTableView)
        chatTableView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        chatTableView.fillSuperview()
        chatTableView.register(
            UsersTableViewCell.self,
            forCellReuseIdentifier: "UserCell"
        )
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
                        self.messageList = Array(self.messagesDictionary.values)
                        self.messageList.sort(by: { (message1, message2) -> Bool in
                            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                                return timestamp1.intValue > timestamp2.intValue
                            }
                            return false
                        })
                        print(self.messageList)

                    }
                    
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func showChatControllerForUser(user: User) {
        let chatController = ChatViewController()
        chatController.chatWithUser = user
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshoot) in
                if let dictionary = snapshoot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    self.settupNavBarWithUser(user: user)
                    self.clearAndLoadDataToTableView()
                }
            }
        }
    }
    
    func clearAndLoadDataToTableView() {
        messageList.removeAll()
        messagesDictionary.removeAll()
        chatTableView.reloadData()
        
        observeUserMessages()
    }

    func settupNavBarWithUser(user: User) {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = user.name
            return label
        }()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(systemName: "square.and.pencil")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        navigationController?.present(newMessageController, animated: true)
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
            print("tries to logout")
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
}

extension MessagesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messageList[indexPath.row]
        let currentUser = Auth.auth().currentUser?.uid
        var id: String?
        
        if message.fromId == currentUser {
            id = message.toId
        } else {
            id = message.fromId
        }
        
        if let parnerId = id {
            let ref = Database.database().reference().child("users").child(parnerId)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    
                    self.showChatControllerForUser(user: user)
                }
            }
        }
    }
}

extension MessagesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        
        let message = messageList[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
}
