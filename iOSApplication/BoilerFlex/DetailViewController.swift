//
//  DetailViewController.swift
//  BoilerFlex
//
//  Created by jeremy on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    var log: [String: Any]!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var calories: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let imageUrl = URL(string: log["photo_url"] as! String)!
        photoView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "image_placeholder"), completion: { (response) in
            self.photoView.image = response.result.value
        })
        
        self.name.text = log["food_name"] as? String
        
        let rawdate = (log["time"] as! Timestamp).dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date.text = formatter.string(from: rawdate)
        
        self.calories.text = log["calories"] as? String
        
        
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
