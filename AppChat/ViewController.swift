//
//  ViewController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 28/09/2022.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel()
        label.text = "UILabel"
        cell.addSubview(label)
        label.centerInSuperview()
        
        return cell
    }
    
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        view.addSubview(chatTableView)
        chatTableView.backgroundColor = .gray
        chatTableView.fillSuperview()
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
