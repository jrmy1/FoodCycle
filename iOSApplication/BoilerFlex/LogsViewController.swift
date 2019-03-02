//
//  LogsViewController.swift
//  BoilerFlex
//
//  Created by Tobi Ola on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var logs = [QueryDocumentSnapshot]()

    @IBOutlet weak var logTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresh()
        self.logTable.reloadData()


    }
    
    func refresh() {
        let db = Firestore.firestore()
        db.collection("logs").getDocuments { (snapshot, error) in
            self.logs = (snapshot?.documents)!
            print(self.logs[0].data())
            
            self.logTable.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.logs.count)
        return self.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell
        
        let log = self.logs[indexPath.row].data()
        print(self.logs[indexPath.row].data())
        cell.calorieCountLabel.text = log["calories"] as? String
        cell.foodNameLabel.text = log["food_name"] as? String
        
        return cell
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
