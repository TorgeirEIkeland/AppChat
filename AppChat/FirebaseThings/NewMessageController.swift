//
//  NewMessageController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 30/09/2022.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellID = "CellID"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItems()
        fetchUser()
        
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellID)
        
    }
    
    @objc func handleCancel(){
        print("Operation canceled")
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(handleCancel)
        )
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                if user.id != Auth.auth().currentUser?.uid {
                    self.users.append(user)
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellID, for: indexPath
        ) as! UsersTableViewCell
        let user = users[indexPath.row]
        
        cell.nameTextLabel.text = user.name
        cell.subText.text = user.email
        
        
        return cell
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: {
            print("Controller dismissed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        })
    }
    
}
