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
    
    var logs: [QueryDocumentSnapshot] = []
    @IBOutlet weak var tableView: UITableView!
    let refreshLogs = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        refresh()
        refreshLogs.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshLogs
    }
    
    @objc func refresh() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let db = Firestore.firestore()
        db.collection("logs").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            }
            else {
                self.logs = snapshot!.documents
                print(self.logs[0].data())
                self.tableView.reloadData()
            }
        }
        self.refreshLogs.endRefreshing()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let db = Firestore.firestore()
        db.collection("logs").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            }
            else {
                self.logs = snapshot!.documents
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell
        let log = self.logs[indexPath.row].data()
        
        cell.calorieCountLabel.text = String(log["calories"] as! Int)
        cell.foodNameLabel.text = log["food_name"] as? String
        
        let rawdate = (log["time"] as! Timestamp).dateValue()
        print(rawdate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: rawdate)
        
        cell.dateLabel.text = date
        
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
