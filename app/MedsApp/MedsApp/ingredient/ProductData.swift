//
//  ProductData.swift
//  MedsApp
//
//  Created by Yong Seong Kim on 2021/05/31.
//

import Foundation
import UIKit

class ProductData
{
    static var name = UserDefaults.standard.stringArray(forKey: "savedName") ?? [String]()
    static var date : [Int] = UserDefaults.standard.array(forKey: "savedDate")as? [Int] ?? [Int]()
    
    static var sdate : [String] = UserDefaults.standard.stringArray(forKey: "savedSdate") ?? [String]()
    
    static var imageNames : [String] = UserDefaults.standard.stringArray(forKey: "savedImageName") ?? [String]()
    static var images : [UIImage] = loadImages(imageNames: imageNames)
    
    static let dPerMonth = [0,31,59,90,120,151,181,212,243,273,304,334]
    //불러오기.
    
    
    static func dayToString(year:Int,month:Int,day:Int) -> String {
        
        return String(year) + "-" + String(month) + "-" + String(day)
    }//연 월 일을 string으로.
    
    static func dayToInt(year:Int,month:Int,day:Int) -> Int{
        
        var flag = 0;
        var ret = 0;
        let ty = year - 2021;
        
        if (year%4==0){flag = 1;}
        
        ret += dPerMonth[month]
        if(flag==1 && month>2){ret+=1}
        
        ret += ty*365 + (ty/4)
        
        return ret
    }
            
    
    
    static func saveImage(image: UIImage)->String{
        let imageData = image.pngData()! as NSData
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let mpath = paths[0] as URL
        let uuid = NSUUID.init().uuidString + ".png"
        let fullPath = mpath.appendingPathComponent(uuid)
        
        _ = imageData.write(to: fullPath, atomically: true)
        
        return uuid
    }
    
    static func loadImages(imageNames: [String]) -> [UIImage]{
        var savedImages: [UIImage] = [UIImage]()
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        var filePath: String = ""
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        let dirPath = paths[0] as NSString
        
        for imageName in imageNames{
            if imageName == ""{
                savedImages.append(UIImage())
            }
            else{
                filePath = dirPath.appendingPathComponent(imageName)
                savedImages.append(UIImage(contentsOfFile: filePath)!)
            }
        }
        return savedImages
    }
}
