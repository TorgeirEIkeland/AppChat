//
//  LoginController+Handlers.swift
//  AppChat
//
//  Created by Torgeir Eikeland on 06/10/2022.
//

import UIKit

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleImageTap() {
        print("Winter is comming!")
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.present(imagePicker, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print(editedImage.size)
            print("Edited image")
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print(originalImage.size)
            print("Original image")
        }
        
        self.dismiss(animated: true, completion: nil)


    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel")
        self.dismiss(animated: true)
    }
    
    
}
