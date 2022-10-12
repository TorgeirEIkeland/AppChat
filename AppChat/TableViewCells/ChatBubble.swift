//
//  SenderTableViewCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 04/10/2022.
//

import UIKit
import Firebase

class ChatBubble: UITableViewCell {
    
    
    var mainMessage: Message? {
        didSet {
            setFromLabel()
        }
    }
    
    func setFromLabel() {
        if let fromId = mainMessage?.fromId {
            let ref = Firebase.Database.database().reference().child("users").child(fromId)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.fromLabel.text = dictionary["name"] as? String
                }
            }
        }
    }
    
    var indexPath = IndexPath()
    var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chatBoxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "No text given"
        return label
    }()
    
    let fromLabel: UILabel = {
        let label = UILabel()
        label.text = "Navn her"
        
        return label
    }()
    
    let chatContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let cornerBox: UIView = {
        let  view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        return view
    }()
    
    
    
    func setupViews() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(fromLabel)
        containerView.addSubview(chatContainer)
        containerView.addSubview(chatBoxView)
        chatBoxView.addSubview(messageLabel)
        chatContainer.addSubview(cornerBox)

        
        setupConstraints()
        chatTapGesture()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupConstraints() {
        containerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(
                top: 8,
                left: 0,
                bottom: 0,
                right: 0
            )
        )
        
        containerView.heightAnchor.constraint(
            equalTo: chatContainer.heightAnchor,
            multiplier: 1
        ).isActive = true
        
        chatContainer.anchor(
            top: chatBoxView.topAnchor,
            leading: nil,
            bottom: fromLabel.bottomAnchor,
            trailing: nil
        )
                
        
        cornerBox.constrainHeight(constant: 8)
        cornerBox.constrainWidth(constant: 8)
        chatBoxViewConstraints()
        
        messageLabel.anchor(
            top: chatBoxView.topAnchor,
            leading: chatBoxView.leadingAnchor,
            bottom: chatBoxView.bottomAnchor,
            trailing: chatBoxView.trailingAnchor,
            padding: .init(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            )
        )
        messageLabel.widthAnchor.constraint(
            lessThanOrEqualTo: contentView.widthAnchor,
            multiplier: 5/7
        ).isActive = true

    }
    
    func chatTapGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.chatLongPress))
        chatBoxView.addGestureRecognizer(longPress)
    }
    
    @objc func chatLongPress() {
        if
            let parentView = self.superview as? UITableView,
            let parentViewController = parentView.delegate as? ChatViewController
        {
            parentViewController.deleteAlert(indexPath: indexPath)
        }
    }
    

    
    func chatBoxViewConstraints() {     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
