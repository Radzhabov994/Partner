//
//  NewPartnerViewController.swift
//  Partner
//
//  Created by Гамид Раджабов on 16.04.2020.
//  Copyright © 2020 Gamid Radzhabov. All rights reserved.
//

import UIKit

class NewPartnerViewController: UITableViewController {
    
    var currentPartner: Partner?
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var partnerName: UITextField!
    @IBOutlet weak var partnerLocation: UITextField!
    @IBOutlet weak var partnerType: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false

        partnerName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
        
    }
    
    func savePartner() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = partnerImage.image
        } else {
            image = #imageLiteral(resourceName: "imageplaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPartner = Partner(name: partnerName.text!,
                                 location: partnerLocation.text,
                                 type: partnerType.text,
                                 imageData: imageData)
        
        if currentPartner != nil {
            try! realm.write{
                currentPartner?.name = newPartner.name
                currentPartner?.location = newPartner.location
                currentPartner?.type = newPartner.type
                currentPartner?.imageData = newPartner.imageData
            }
        } else {
            StorageManager.saveObject(newPartner)
        }

    }
    
    private func setupEditScreen(){
        if currentPartner != nil{
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPartner?.imageData, let image = UIImage(data: data) else {return}
            
            partnerImage.image = image
            partnerImage.contentMode = .scaleAspectFill
            partnerName.text = currentPartner?.name
            partnerLocation.text = currentPartner?.location
            partnerType.text = currentPartner?.type
        }
    }

    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPartner?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    
}

// MARK: Text field delegate

extension NewPartnerViewController: UITextFieldDelegate{
    
    // Скрываем клавиатуру по нажатию Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if partnerName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: Work with image

extension NewPartnerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        partnerImage.image = info[.editedImage] as? UIImage
        partnerImage.contentMode = .scaleAspectFill
        partnerImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
        
    }
}
