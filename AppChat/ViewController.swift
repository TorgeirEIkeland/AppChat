//
//  ViewController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 28/09/2022.
//

import UIKit
import Firebase

class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    var testArray = ["1", "2", "3", "4"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //      let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
  //      cell.label.text = testArray[indexPath.row]
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "PreLoadText"
        let image = UIImage(systemName: "square.and.pencil")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        
        
        view.addSubview(chatTableView)
//        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        chatTableView.backgroundColor = UIColor(r: 61, g: 91, b: 151)

        chatTableView.fillSuperview()
        
    }

    @objc func handleNewMessage() {
//        let newMessageController = NewMessageController()
//        navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshoot) in
                print(snapshoot)
                if let dictionary = snapshoot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }
        }
    }
    
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        
        let loginController = LoginController()
//        loginController.textToChange(text: "Text som skal byttes")
        navigationController?.pushViewController(loginController, animated: true)
    }


}

protocol HasTextToChange: AnyObject {
    func textToChange(text: String)
}
