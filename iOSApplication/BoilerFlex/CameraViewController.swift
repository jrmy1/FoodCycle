//
//  CameraViewController.swift
//  BoilerFlex
//
//  Created by jeremy on 3/2/19.
//  Copyright © 2019 Jeremy Chang. All rights reserved.
//

import UIKit
import CoreML
import Alamofire
import SwiftyJSON
import FirebaseFirestore

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var percentage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPress(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        
        alert.addAction(UIAlertAction(title: "Choose Image", style: .default) { _ in
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("hello")

        dismiss(animated: true, completion: nil)
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        processImage(image)
    }
    
    func processImage(_ image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)
        
        photoView.image = image
        percentage.text = "\(result.classLabel) - \(converted) %"
        
        let headers: HTTPHeaders = [
            "x-app-id": "a51d3f5d",
            "x-app-key": "0cc6ebdbce2242015fc21ec1de96c780"
        ]
        
        var urlString = "https://trackapi.nutritionix.com/v2/search/instant?query=" + result.classLabel
        urlString = urlString.replacingOccurrences(of: "_", with: "%20")

        let url = URL(string: urlString)!
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET")
                print(response.result.error!)
                return
            }
            
            if let value = response.result.value {
                let nixItemId = JSON(value)["branded"].array?[0]["nix_item_id"].string
                let urlString = "https://trackapi.nutritionix.com/v2/search/item?nix_item_id=" + nixItemId!
                print(urlString)
                let url = URL(string: urlString)!
                Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (res) in
                    guard res.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling GET")
                        print(res.result.error!)
                        return
                    }
                    
                    if let value = res.result.value {
                        
                        let json = JSON(value) // JSON comes from SwiftyJSON
                        print("printing nix item")
                        print(json) // to see the JSON response
                        let foodData = json["foods"].array?[0]
                        let db = Firestore.firestore()
                        
                        let foodName = foodData?["food_name"].string
                        let calories = foodData?["nf_calories"].number
                        let cholesterol = foodData?["nf_cholesterol"].number
                        let carbs = foodData?["nf_total_carbohydrate"].number
                        let sugars = foodData?["nf_sugars"].number
                        let photoUrl = foodData?["photo"]["thumb"].string
                        let sodium = foodData?["nf_sodium"].number
                        let protein = foodData?["nf_protein"].number
                        let fat = foodData?["nf_total_fat"].number
                        let saturatedFat = foodData?["nf_saturated_fat"].number
                        
                        db.collection("logs").addDocument(data: [
                            "food_name": foodName!,
                            "calories": calories!,
                            "cholesterol": cholesterol!,
                            "carbs": carbs!,
                            "sugars": sugars!,
                            "photo_url": photoUrl!,
                            "sodium": sodium!,
                            "protein": protein!,
                            "fat": fat!,
                            "saturated_fat": saturatedFat!,
                            "time": Timestamp(date: Date())
                        ])
                    }
                })
            }
            
            
        }
        /*
            
            if let value = response.result.value {
                
                let json = JSON(value) // JSON comes from SwiftyJSON
                let foodData = json["branded"].array?[0]
                let db = Firestore.firestore()
                
                let foodName = foodData?["food_name"].string
                let nixItemId = JSON(value)["branded"].array?[0]["nix_item_id"].string
                
                let urlString = "https://trackapi.nutritionix.com/v2/search/item?nix_item_id=" + nixItemId!
                
                let url = URL(string: urlString)!

                Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
                    
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling GET")
                        print(response.result.error!)
                        return
                    }
                    
                    if let value = response.result.value {
                        
                        let json = JSON(value) // JSON comes from SwiftyJSON
                        print(json) // to see the JSON response
                        let foodData = json["branded"].array?[0]
                        let db = Firestore.firestore()
                        
                        let foodName = foodData?["food_name"].string
                    
                    }
                }
                
                    /*
                db.collection("logs").addDocument(data: [
                    "food_name": foodName ?? "food unknown", //foodData["foot_name"] as? String,
                    "calories": "420"
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added")
                    }
                }*/
                
                }
            }
        }
        */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
