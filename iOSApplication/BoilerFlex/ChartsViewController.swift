//
//  ChartsViewController.swift
//  BoilerFlex
//
//  Created by jeremy on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChartsViewController: UIViewController {

    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var choLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let db = Firestore.firestore()
        
        db.collection("data").document("2019-03-03").getDocument { (snapshot, error) in
            let log = snapshot?.data()
            
            self.calorieLabel.text = (log?["calories"] as? NSNumber)?.stringValue
            self.carbsLabel.text = ((log?["carbs"] as? NSNumber)?.stringValue)! + " g"
            self.proteinLabel.text = ((log?["protein"] as? NSNumber)?.stringValue)! + " g"
            self.fatLabel.text = ((log?["fat"] as? NSNumber)?.stringValue)! + " g"
            self.sugarLabel.text = ((log?["sugar"] as? NSNumber)?.stringValue)! + " g"
            self.sodiumLabel.text = ((log?["sodium"] as? NSNumber)?.stringValue)! + " mg"
            self.choLabel.text = ((log?["cholesterol"] as? NSNumber)?.stringValue)! + " mg"
            
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
