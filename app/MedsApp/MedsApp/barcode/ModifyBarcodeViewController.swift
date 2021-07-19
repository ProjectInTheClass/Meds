//
//  ModifyBarcodeViewController.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/07/19.
//

import UIKit

class ModifyBarcodeViewController: UIViewController {

    let pickerController = UIImagePickerController()// 직접 카메라로 상품을 찍을 때 사용하는 변수.
    var imageView : UIImage? //카메라로 찍은 상품 사진.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerController.sourceType = UIImagePickerController.SourceType.camera
        pickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        present(pickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let saveProduct = segue.destination as? saveProduct else { return }
        
        if let imageView = imageView
        {
            saveProduct.tempImage = imageView
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ModifyBarcodeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        
        
        imageView = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        performSegue(withIdentifier: "storeProduct", sender: self)
    }
}
