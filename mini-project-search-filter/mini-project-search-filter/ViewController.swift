//
//  ViewController.swift
//  mini-project-search-filter
//
//  Created by Dinna Ayu Karunniawati on 9/18/18.
//  Copyright © 2018 Dinna Ayu Karunniawati. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterPageControllerDalegate {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var responseData :[JSON] = []
    var minRange: Int = 10000
    var maxRange: Int = 100000
    var isWholeSale: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.filterButton.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.3, alpha: 1)
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        performRequest() { success, error in
            guard let response = success, error == nil else {
                print("Error message: \(error)")
                return
            }
            self.responseData = success!["data"].arrayValue
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.responseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 10, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if (self.responseData.count > 0){
            cell.setData(title: self.responseData[indexPath.row]["name"].stringValue, urlImage: self.responseData[indexPath.row]["image_uri"].stringValue, price: self.responseData[indexPath.row]["price"].stringValue)
        }
        return cell
    }
    
    func performRequest(completionHandler: @escaping (JSON?, String?) -> Void) {
        let url: String = "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=" + String(minRange) + "&pmax=" + String(maxRange) + "&wholesale=true&official=" + String(isWholeSale) + "&fshop=2&start=0&rows=10"
        print(url)
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .failure:
                completionHandler(nil, response.result.error?.localizedDescription)
            case .success:
                let swiftyJsonVar = JSON(response.result.value!)
                completionHandler(swiftyJsonVar, nil)
            }
        }
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FilterPageController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterPageController") as! FilterPageController
        viewController.delegate = self
        self.present(viewController, animated: true)
    }
    
    func dataFromFilter(minRange: Int, maxRange: Int, isWholeSale: Bool) {
        self.minRange = minRange
        self.maxRange = maxRange
        self.isWholeSale = isWholeSale
    }
}
