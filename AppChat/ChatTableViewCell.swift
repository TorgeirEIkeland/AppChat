//
//  ChatTableViewCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 29/09/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let identifier = "chatTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Label text"
        return label
    }()
    
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        setupLabel()
    }
    
    func setupLabel() {
        label.anchor(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: nil,
            padding: .init(
                top: 10,
                left: 12,
                bottom: 10,
                right: 0
            )
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
