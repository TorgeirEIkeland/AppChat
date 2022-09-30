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
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)

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
                self.users.append(user)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
}


class UserCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
