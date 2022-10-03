//
//  ChatTableViewCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 29/09/2022.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    let loggedInUser: String? = "Torgeir"
    lazy var sender: String? = "No sender" {
        didSet {
            setChatBoxSide()
        }
    }
    lazy var message: String? = "No message" {
        didSet {
            messageLabel.text = message
        }
    }
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Text not given"
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let chatBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(r: 80, g: 101, b: 161)
        
        contentView.addSubview(containerView)
        containerView.addSubview(chatBoxView)
        chatBoxView.addSubview(messageLabel)
        
        viewSettup()
        
    }
    
    func viewSettup() {
        containerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor
        )
        containerView.heightAnchor.constraint(
            equalTo: chatBoxView.heightAnchor,
            multiplier: 1.2
        ).isActive = true
        
        containerView.constrainWidth(
            constant: contentView.frame.width - 40
        )
        
        
        //ChatBoxView gets constraints from sender variable when data has been changed
        
        
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
        messageLabel.preferredMaxLayoutWidth = contentView.frame.width - 40
        
        
    }
    
    func setChatBoxSide() {
        chatBoxView.centerYInSuperview()
        if sender == loggedInUser {
            chatBoxView.backgroundColor = .cyan
            //ChatBox on right side
            chatBoxView.anchor(
                top: nil,
                leading: nil,
                bottom: nil,
                trailing: containerView.trailingAnchor,
                padding: .init(
                    top: 10,
                    left: 10,
                    bottom: 10,
                    right: 10
                )
            )
        } else {
            //ChatBox on left side
            chatBoxView.backgroundColor = .lightGray
            
            chatBoxView.anchor(
                top: nil,
                leading: containerView.leadingAnchor,
                bottom: nil,
                trailing: nil,
                padding: .init(
                    top: 10,
                    left: 10,
                    bottom: 10,
                    right: 10
                )
            )
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
