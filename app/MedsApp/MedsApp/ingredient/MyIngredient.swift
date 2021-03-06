//
//  MyIngredient.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/04/18.
//

import UIKit
import UserNotifications

class MyIngredient: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let calendar = Calendar(identifier: .gregorian)
    
    var todayDate:Int!;
    var todayTime:Int!;
    
    //전역변수.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductData.name.count
    }//name count에 따라 tableview만듬
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier : "customCell", for:indexPath) as! CustomTableViewCell
        
        cell.ingredientName.text = ProductData.name[indexPath.row]
        cell.ingredientDate.text = ProductData.sdate[indexPath.row]
        cell.IngredientImage.image = ProductData.images[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            ProductData.name.remove(at: indexPath.row)
            ProductData.date.remove(at: indexPath.row)
            ProductData.sdate.remove(at: indexPath.row)
            ProductData.images.remove(at: indexPath.row)
            ProductData.imageNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            let defaults = UserDefaults.standard
            defaults.set(ProductData.name, forKey:"savedName")
            defaults.set(ProductData.date, forKey:"savedDate")
            defaults.set(ProductData.sdate, forKey:"savedSdate")
            defaults.set(ProductData.imageNames, forKey: "savedImageName")
            //데이터를 저장.
        }
    }//삭제하는거.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let hour = calendar.component(.hour, from: today)
        let minute = calendar.component(.minute, from: today)
        
        todayDate = ProductData.dayToInt(year: year, month: month, day: day)
        todayTime = (1440-minute-(hour*60))*60
        
        if(ProductData.name.count>0)
        {
            notification()
        }
        
        while ProductData.images.count < ProductData.name.count{
            ProductData.images.append(UIImage())
            ProductData.imageNames.append("")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(ProductData.name)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextViewController = segue.destination as? ModifyViewController else{return}
        let cell = sender as! CustomTableViewCell

        let indexPath = tableView.indexPath(for: cell)
        
        
        
//        static var name = UserDefaults.standard.stringArray(forKey: "savedName") ?? [String]()
//        static var date : [Int] = UserDefaults.standard.array(forKey: "savedDate")as? [Int] ?? [Int]()
//
//        static var sdate : [String] = UserDefaults.standard.stringArray(forKey: "savedSdate") ?? [String]()
//
//        static var imageNames : [String] = UserDefaults.standard.stringArray(forKey: "savedImageName") ?? [String]()
//        static var images : [UIImage] = loadImages(imageNames: imageNames)
        
        let name = ProductData.name[indexPath!.row]
        let image = ProductData.images[indexPath!.row]
        nextViewController.pname = name
        nextViewController.pimage = image
        
        nextViewController.tableView = tableView
        nextViewController.indexPath = indexPath
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func notification()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in})
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        content.title = "유통기한 알림"
        content.body = "유통기한이 임박한 식품이 있습니다"
        
        print(TimeInterval((32400+todayTime+(ProductData.date[0]-todayDate)*86400)))
        
        var tmpInt = 0
        
        if(todayTime > 54000){tmpInt = -1}
        
        let dist = ProductData.date[0] - (todayDate+tmpInt)
        
        var target1 = Date(timeIntervalSinceNow: TimeInterval(todayTime + 32400 + (tmpInt * 86400)))
        var target2 = Date(timeIntervalSinceNow: TimeInterval(todayTime + 32400 + ((tmpInt+1) * 86400)))
        
        if((dist+tmpInt)>3) {
            target1 = Date(timeIntervalSinceNow: TimeInterval(todayTime + 32400 + ((tmpInt+dist-4) * 86400)))
            target2 = Date(timeIntervalSinceNow: TimeInterval(todayTime + 32400 + ((tmpInt+dist-3) * 86400)))
        }
        
        let t1 = Calendar.current.dateComponents([.year,.month,.day,.hour], from: target1)
        let t2 = Calendar.current.dateComponents([.year,.month,.day,.hour], from: target2)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: t1, repeats: false)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: t2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        let request2 = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger2)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
    }
}
