//
//  ContainerSettingViewController.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/27.
//

import UIKit

class ContainerSettingViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
         profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true

            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor.black.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @objc func touchToPickPhoto()
    {
        showImagePickerControllerActionSheet()
    }

}


extension ContainerSettingViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func showImagePickerControllerActionSheet()
    {
        
        let alertPrompt = UIAlertController(title: "Choose you image", message: nil, preferredStyle: .actionSheet)//창을 띄어줌.
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        
        let cameraAction = UIAlertAction(title: "Take from Camera", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            self.showImagePickerController(sourceType: .camera)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        
        alertPrompt.addAction(photoLibraryAction)
        alertPrompt.addAction(cameraAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
        
        
    }
    
    
    func showImagePickerController(sourceType : UIImagePickerController.SourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImage.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            profileImage.image = originalImage
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
