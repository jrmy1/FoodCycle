//
//  LogsViewController.swift
//  BoilerFlex
//
//  Created by Tobi Ola on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import AlamofireImage

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
        let imageUrl = URL(string: log["photo_url"] as! String)!
        
        let rawdate = (log["time"] as! Timestamp).dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: rawdate)
        
        cell.dateLabel.text = date
        cell.foodNameLabel.text = log["food_name"] as? String
        
        cell.photoView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "image_placeholder"), completion: { (response) in
            cell.photoView.image = response.result.value
        })
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView .indexPath(for: cell)!
        let log = logs[indexPath.row].data()
        
        // Pass the selected object to the new view controller.
        //let navigationController = segue.destination as! UINavigationController
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.log = log
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
