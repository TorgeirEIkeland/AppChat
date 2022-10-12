//
//  ChatTableView.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 03/10/2022.
//

import UIKit
import Firebase


class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        addAllSubViews()
        settupViewConstraints()
       // observeMessages()
        //observeUserMessages()
        
        makeViewFollowKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageList = []
        observeUserMessages()
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    print("\(message.text): \((message.toId == uid || message.toId == self.chatWithUser?.id) && (message.fromId == uid || message.fromId == self.chatWithUser?.id))")
                    if (message.toId == uid || message.toId == self.chatWithUser?.id) && (message.fromId == uid || message.fromId == self.chatWithUser?.id) {
                        self.messageList.append(message)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.chatTableView.reloadData()
                    })
                }
            }
        }
    }
    
    
    var loggedInUserMessages: [Message] = [] {
        didSet {
            
        }
    }
    
    var messageList: [Message] = []
        
    var chatWithUser: User? {
        didSet {
            title = chatWithUser?.name
        }
    }
    
    var loggedInUser: User? {
        didSet {
            self.chatTableView.reloadData()
        }
    }
    
    let chatTextFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var chatTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Type here"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var chatTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        
    }()
    
    lazy var sendChatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(SendMessage), for: .touchUpInside)
        return button
    }()
    
    @objc func SendMessage() {
        //Upload message to server
        
        
        guard let message = chatTextField.text else {
            print("message is corrupted")
            return
        }
        if message != "" {
            
            let ref = Firebase.Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            
            
            
            let toId = chatWithUser!.id!
            let fromId = Firebase.Auth.auth().currentUser!.uid
            let timestamp: Int = Int(Date().timeIntervalSince1970)
            let values = ["text": message, "toId": toId, "fromId" : fromId, "timestamp" : timestamp] as [String : Any]
            
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId).child(messageId)
                recipientUserMessageRef.setValue(1)
            }
            return
        }
        print("Empty message")
    }
    
    let seperatorLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        return line
    }()
    
    let seccondSeperatorLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        return line
    }()
    
    let verticalSeperatorLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        return line
    }()
    

    
    func makeViewFollowKeyboard() {
        // Make view follow keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    func addAllSubViews() {
        
        view.addSubview(chatTableView)
        view.addSubview(chatTextFieldContainer)
        chatTextFieldContainer.addSubview(chatTextField)
        chatTextFieldContainer.addSubview(sendChatButton)
        chatTextFieldContainer.addSubview(seperatorLine)
        chatTextFieldContainer.addSubview(seccondSeperatorLine)
        chatTextFieldContainer.addSubview(verticalSeperatorLine)
        
    }
    
    
    func settupViewConstraints() {
        
        chatTableView.register(
            RecieverCell.self,
            forCellReuseIdentifier: "RecieverCell"
        )
        chatTableView.register(
            SenderCell.self,
            forCellReuseIdentifier: "SenderCell"
        )
        chatTableView.allowsSelection = false
        
        chatTableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: sendChatButton.topAnchor,
            trailing: view.trailingAnchor
        )
        
        chatTextFieldContainer.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor
        )
        chatTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        chatTextField.anchor(
            top: chatTextFieldContainer.topAnchor,
            leading: chatTextFieldContainer.leadingAnchor,
            bottom: chatTextFieldContainer.safeAreaLayoutGuide.bottomAnchor,
            trailing: sendChatButton.leadingAnchor,
            padding: .init(
                top: 0,
                left: 8,
                bottom: 0,
                right: 8
            )
        )
        chatTextField.heightAnchor.constraint(
            equalTo: chatTextFieldContainer.heightAnchor
        ).isActive = true
        
        sendChatButton.anchor(
            top: nil,
            leading: nil,
            bottom: chatTextFieldContainer.bottomAnchor,
            trailing: chatTextFieldContainer.trailingAnchor
        )
        sendChatButton.heightAnchor.constraint(equalTo: chatTextFieldContainer.heightAnchor).isActive = true
        sendChatButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        seperatorLine.anchor(
            top: nil,
            leading: chatTextFieldContainer.leadingAnchor,
            bottom: chatTextFieldContainer.topAnchor,
            trailing: chatTextFieldContainer.trailingAnchor
        )
        seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        seccondSeperatorLine.anchor(
            top: chatTextFieldContainer.bottomAnchor,
            leading: chatTextFieldContainer.leadingAnchor,
            bottom: nil,
            trailing: chatTextFieldContainer.trailingAnchor
        )
        seccondSeperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        verticalSeperatorLine.anchor(
            top: sendChatButton.topAnchor,
            leading: sendChatButton.leadingAnchor,
            bottom: sendChatButton.bottomAnchor,
            trailing: nil
        )
        verticalSeperatorLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func deleteAlert(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "DELETE MESSAGE", message: "Are you sure you want to delete this message?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(
            title: "YES",
            style: UIAlertAction.Style.default
        ) { UIAlertAction in
            
            print("Yes Pressed")
            self.messageList.remove(at: indexPath.row)
        }
        
        let noAction = UIAlertAction(
            title: "NO",
            style: UIAlertAction.Style.default
        ) { UIAlertAction in
            print("No pressed")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.contentSize.height + self.contentInset.bottom - self.frame.height)
            if point.y >= 0 {
                self.setContentOffset(point, animated: animated)
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageList[indexPath.row]
        let currentUser = Auth.auth().currentUser?.uid
        
        
        if message.fromId == currentUser {
            let recieverCell = tableView.dequeueReusableCell(withIdentifier: "RecieverCell", for: indexPath) as! RecieverCell
            recieverCell.indexPath = indexPath
            recieverCell.setupViews()
            recieverCell.message = messageList[indexPath.row].text!
            recieverCell.mainMessage = message
            
            return recieverCell
        } else {
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            senderCell.indexPath = indexPath
            senderCell.setupViews()
            senderCell.message = messageList[indexPath.row].text!
            senderCell.mainMessage = message
            
            return senderCell
        }
    }
    
    
}
