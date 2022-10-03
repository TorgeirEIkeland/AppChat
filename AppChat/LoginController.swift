//
//  LoginController.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 28/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    lazy private var inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return
            }
            //Succesfull login
            print("login success")
            self.navigationController?.popViewController(animated: true)
        }
    }
        
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("Something went wrong creating user")
            }
            let ref = FirebaseDatabase.Database.database().reference(fromURL: "https://chatapp-las-default-rtdb.europe-west1.firebasedatabase.app")
            
            guard let uid = result?.user.uid else {
                return
            }
            
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email, "id": uid]
            usersReference.updateChildValues(values) { (err, ref) in
                if err != nil {
                    print("err")
                    return
                }
                print("Saved user succesfully into firebase db")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email adress"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.tintColor = .white
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Change height of constraints for container
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150

        //Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXInSuperview()
        loginRegisterSegmentedControl.anchor(top: nil, leading: inputsContainerView.leadingAnchor, bottom: inputsContainerView.topAnchor, trailing: inputsContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 12, right: 0))
        
        
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        inputsContainerView.centerInSuperview()
        inputsContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true

        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperator)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperator)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.anchor(top: inputsContainerView.topAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
 
        nameTextFieldHeightAnchor?.isActive = true

        
        nameSeperator.anchor(top: nameTextField.bottomAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor)
        nameSeperator.constrainHeight(constant: 1)
        
        
        emailTextField.anchor(top: nameTextField.bottomAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeperator.anchor(top: emailTextField.bottomAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor)
        emailSeperator.constrainHeight(constant: 1)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12))
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXInSuperview()
        loginRegisterButton.anchor(top: inputsContainerView.bottomAnchor, leading: inputsContainerView.leadingAnchor, bottom: nil, trailing: inputsContainerView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        loginRegisterButton.constrainHeight(constant: 50)
    }
    
    func setupProfileImageView() {
        profileImageView.centerXInSuperview()
        profileImageView.anchor(top: nil, leading: nil, bottom: loginRegisterSegmentedControl.topAnchor, trailing: nil)
        profileImageView.constrainHeight(constant: 150)
        profileImageView.constrainWidth(constant: 150)
    }
    
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
