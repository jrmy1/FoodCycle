//
//  DetailViewController.swift
//  BoilerFlex
//
//  Created by jeremy on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import Firebase
import WebKit
import Alamofire

class DetailViewController: UIViewController {

    var log: [String: Any]!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var calories: UILabel!
    @IBOutlet var carbs: UILabel!
    @IBOutlet var cholesterol: UILabel!
    @IBOutlet var fat: UILabel!
    @IBOutlet var protein: UILabel!
    @IBOutlet var saturated_fat: UILabel!
    @IBOutlet var sodium: UILabel!
    @IBOutlet var sugar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = log["food_name"] as? String
        
        let rawdate = (log["time"] as! Timestamp).dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date.text = formatter.string(from: rawdate)
        self.calories.text = String(log["calories"] as! Int) + " cal"
        self.carbs.text = String(log["carbs"] as! Int) + " g"
        self.cholesterol.text = String(log["cholesterol"] as! Int) + " mg"
        self.fat.text = String(log["fat"] as! Int) + " g"
        self.protein.text = String(log["protein"] as! Int) + " g"
        self.saturated_fat.text = String(log["saturated_fat"] as! Int) + " g"
        self.sodium.text = String(log["sodium"] as! Int) + " mg"
        self.sugar.text = String(log["sugar"] as! Int) + " g"
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
