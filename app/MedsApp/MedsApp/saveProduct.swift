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
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDate: UIDatePicker!
    @IBOutlet weak var productButton: UIButton!

    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = tempImage
    }
    
    func takePicture()
    {
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let date = productDate.date
        let calendar = Calendar(identifier: .gregorian)
        if let productName = productName.text
        {
            ProductData.name.insert(productName, at: ProductData.name.count)
        }
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let sdateTemp = ProductData.dayToString(year: year, month: month, day: day)
        let dateTemp = ProductData.dayToInt(year: year, month: month, day: day)
        
        ProductData.date.insert(dateTemp, at: ProductData.date.count)
        ProductData.sdate.insert(sdateTemp, at: ProductData.sdate.count)
        
        UserDefaults.standard.set(ProductData.name, forKey:"savedName")
        UserDefaults.standard.set(ProductData.date, forKey:"savedDate")
        UserDefaults.standard.set(ProductData.sdate, forKey:"savedSdate")
        
        
        
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
