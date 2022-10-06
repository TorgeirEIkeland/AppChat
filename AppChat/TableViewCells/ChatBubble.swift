//
//  SenderTableViewCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 04/10/2022.
//

import UIKit

class ChatBubble: UITableViewCell {
    
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
    
    func setupViews() {
        backgroundColor = UIColor(r: 80, g: 101, b: 161)
        
        contentView.addSubview(containerView)
        containerView.addSubview(chatBoxView)
        chatBoxView.addSubview(messageLabel)
        
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
            equalTo: chatBoxView.heightAnchor,
            multiplier: 1
        ).isActive = true
        
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
