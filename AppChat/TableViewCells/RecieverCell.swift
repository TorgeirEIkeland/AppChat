//
//  RecieverCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 05/10/2022.
//

import UIKit

class RecieverCell: ChatBubble {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                print("RecieverCell")
        
    }
    

    
    override func chatBoxViewConstraints() {
        chatBoxView.backgroundColor = .cyan

        
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
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

