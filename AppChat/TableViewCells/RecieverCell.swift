//
//  RecieverCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 05/10/2022.
//

import UIKit
import Firebase

class RecieverCell: ChatBubble {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func chatBoxViewConstraints() {
        chatBoxView.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        cornerBox.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        
        chatBoxView.centerYInSuperview()
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
        cornerBox.anchor(
            top: nil,
            leading: nil,
            bottom: chatBoxView.bottomAnchor,
            trailing: chatBoxView.trailingAnchor
        )

        
        fromLabel.anchor(
            top: chatBoxView.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: chatBoxView.trailingAnchor,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

