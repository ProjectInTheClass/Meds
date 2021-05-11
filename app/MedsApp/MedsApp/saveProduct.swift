//
//  saveProduct.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/07.
//

import UIKit

class saveProduct: UIViewController {

    var tempImage : UIImage?
    @IBOutlet weak var productImage: UIImageView!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = tempImage
    }
    
    func takePicture()
    {
        
        present(pickerController, animated: true, completion: nil)
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
