//
//  UserTableViewCell.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 06/10/2022.
//

import UIKit
import Firebase

class UsersTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            messageSetup()
        }
    }
    
    func messageSetup() {
        let currentUser = Auth.auth().currentUser?.uid
        var notCurrentUser = ""
        guard let message = message else { return }
        
        if message.toId == currentUser{
            notCurrentUser = message.fromId!
        } else {
            notCurrentUser = message.toId!
        }
        
        let ref = Database.database().reference().child("users").child(notCurrentUser)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.nameTextLabel.text = dictionary["name"] as? String
            }
        }
        
        self.subText.text = message.text
        
        if let seconds = message.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            self.timeLabel.text = dateFormatter.string(from: timestampDate)
        }
    }
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let spacerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let subText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "person.crop.circle")!
        
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(spacerView)
        containerView.addSubview(nameTextLabel)
        containerView.addSubview(subText)
        containerView.addSubview(timeLabel)
        addViewConstraints()
    }
    
    func addViewConstraints() {
        containerView.centerInSuperview()
        
        containerView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        
        profileImageView.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: nil,
            padding: .init(top: 16, left: 16, bottom: 16, right: 0)
        )
        
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        nameTextLabel.anchor(
            top: profileImageView.topAnchor,
            leading: profileImageView.trailingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 16, bottom: 0, right: 0)
        )
        
        subText.anchor(
            top: nameTextLabel.bottomAnchor,
            leading: nameTextLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 0, bottom: 0, right: 0)
        )
        
        timeLabel.anchor(
            top: nameTextLabel.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 16)
        )
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
