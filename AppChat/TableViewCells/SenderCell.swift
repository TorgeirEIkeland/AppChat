//
//  SenderCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 05/10/2022.
//

import UIKit
import Firebase

class SenderCell: ChatBubble {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func chatBoxViewConstraints() {
        chatBoxView.backgroundColor = .lightGray
        cornerBox.backgroundColor = .lightGray
        
        chatBoxView.centerYInSuperview()
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
        
        cornerBox.anchor(
            top: nil,
            leading: chatBoxView.leadingAnchor,
            bottom: chatBoxView.bottomAnchor,
            trailing: nil
        )
        
        fromLabel.anchor(
            top: chatBoxView.bottomAnchor,
            leading: chatBoxView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
