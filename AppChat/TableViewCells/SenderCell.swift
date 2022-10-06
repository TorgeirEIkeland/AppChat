//
//  SenderCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 05/10/2022.
//

import UIKit

class SenderCell: ChatBubble {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("SenderCell")
    }
    

    
    override func chatBoxViewConstraints() {
        chatBoxView.backgroundColor = .lightGray
        
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
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
