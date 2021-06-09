//
//  ModifyViewController.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/06/09.
//

import UIKit

class ModifyViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDate: UIDatePicker!
    var tableView : UITableView?
    var indexPath : IndexPath?
    var pname : String?
    var pimage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let name = pname, let image = pimage {
            productImage?.image = image
            productName?.text = name
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
    @IBAction func buttonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        let date = productDate.date
        let calendar = Calendar(identifier: .gregorian)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let sdateTemp = ProductData.dayToString(year: year, month: month, day: day)
        let dateTemp = ProductData.dayToInt(year: year, month: month, day: day)
        
        var mi = 0
        var ma = ProductData.date.count
        var tmp = 0
        
        while mi<ma{
            tmp = (mi+ma)/2
            if dateTemp<ProductData.date[tmp]{
                ma = tmp
            }
            else{
                mi = tmp+1
            }
        }
        
        ProductData.date.insert(dateTemp, at: mi)
        ProductData.sdate.insert(sdateTemp, at: mi)
        if let productName = productName.text
        {
            ProductData.name.insert(productName, at: mi)
        }
        else{
            ProductData.name.insert("", at: mi)
        }
        if let productImage = productImage.image{
            ProductData.images.insert(productImage, at: mi)
            let imageName = ProductData.saveImage(image: productImage)
            ProductData.imageNames.insert(imageName, at: mi)
        }
        else{
            ProductData.images.insert(UIImage(), at: mi)
            ProductData.imageNames.insert("", at: mi)
        }
        
        
        
//        print("indexPath row")
//        print(indexPath!.row)
        ProductData.name.remove(at: indexPath!.row)
        ProductData.date.remove(at: indexPath!.row)
        ProductData.sdate.remove(at: indexPath!.row)
        ProductData.images.remove(at: indexPath!.row)
        ProductData.imageNames.remove(at: indexPath!.row)
        
//        print("save")
        UserDefaults.standard.set(ProductData.name, forKey:"savedName")
        UserDefaults.standard.set(ProductData.date, forKey:"savedDate")
        UserDefaults.standard.set(ProductData.sdate, forKey:"savedSdate")
        UserDefaults.standard.set(ProductData.imageNames, forKey:"savedImageName")
        
        tableView?.reloadData()
        
        
        
//        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    
}
