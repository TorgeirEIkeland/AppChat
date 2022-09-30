//
//  ChatViewController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 30/09/2022.
//

import UIKit

class MessagesViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var messages: [Message] = [Message(sender: "Mike", content: "Mike sent a message"), Message(sender: "Lasse", content: "Lasse sent a message")]
    
//    lazy var chatCollectionView: UICollectionView = {
//        let collectionView = UICollectionView()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        return collectionView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}


struct Message {
    let sender: String
    let content: String
}
