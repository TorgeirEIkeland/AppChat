//
//  ChatTableView.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 03/10/2022.
//

import UIKit
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messageList: [Message] = [Message(sender: "Torgeir", message: "Melding fra Torgeir"), Message(sender: "Lasse", message: "Melding fra Lasse"),Message(sender: "Torgeir", message: "Melding fra Torgeir"), Message(sender: "Lasse", message: "Melding fra Lasse"),Message(sender: "Torgeir", message: "Torgeir har bestemt seg for å sende en litt lengre medlig nå"), Message(sender: "Lasse", message: "Melding fra Lasse")]{
        didSet {
            self.chatTableView.reloadData()
        }
    }
    var loggedInUser: String = "Torgeir"
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! NewTableViewCell
        cell.sender = messageList[indexPath.row].sender
        cell.message = messageList[indexPath.row].message
        
        return cell
    }
    
    let chatTextFieldContainer: UIView = {
        let view = UIView()
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
        button.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        return button
    }()
    
    @objc func sendChat() {
        //Upload message to server
        print("send message")
        messageList.append(
            Message(
                sender: loggedInUser,
                message: chatTextField.text ?? ""
            )
        )
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(chatTableView)
        view.addSubview(chatTextFieldContainer)
        chatTextFieldContainer.addSubview(chatTextField)
        chatTextFieldContainer.addSubview(sendChatButton)
        chatTextFieldContainer.addSubview(seperatorLine)
        chatTextFieldContainer.addSubview(seccondSeperatorLine)
        chatTextFieldContainer.addSubview(verticalSeperatorLine)
        
        settupViewConstraints()
        
    }
    
    func settupViewConstraints() {
        
        chatTableView.register(
            NewTableViewCell.self,
            forCellReuseIdentifier: "ChatCell"
        )
        
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
    
}

struct Message {
    let sender: String
    let message: String
}
