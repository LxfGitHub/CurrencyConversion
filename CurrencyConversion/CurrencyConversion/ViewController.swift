//
//  ViewController.swift
//  CurrencyConversion
//
//  Created by luoxiaofeng on 2019/08/10.
//  Copyright © 2019年 luoxiaofeng. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

struct RateModle {
    var image: UIImage?
    var name: String?
    var shotName: String?
    var converValue: String?
    init(image: UIImage?, name: String?, shotName: String?, converValue: String?) {
        self.image = image
        self.name = name
        self.shotName = shotName
        self.converValue = converValue
    }
}

class ViewController: UIViewController, DidSelectCurrencyDelegate {

    @IBOutlet weak var currencyInputView: InputCurrencyView!
    @IBOutlet weak var converResults: UICollectionView!
    @IBOutlet weak var converResultsFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    var currencies: [String] = ["yen", "dollar", "yuan"]
    var rateList: [RateModle]?
    
    let BASE_URL: String = "http://www.apilayer.net/api/"
    let ACCESS_KEY: String = "09ba91ed61f93c56099b276d5182274d"
    let ENDPOINT_LIVE: String = "live"
    let ENDPOINT_LIST: String = "list"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        converResultsFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 2*16 - 10)/2 , height: 60)
        converResults.register(UINib(nibName: "RateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RateCollectionViewCell")
        converResults.backgroundColor = UIColor.white
        rateList = [RateModle]()
        rateList?.append(RateModle(image: nil, name: "アメリカドル", shotName: "USD", converValue: "100.00"))
        rateList?.append(RateModle(image: nil, name: "ユーロ", shotName: "EUR", converValue: "89.20"))
        rateList?.append(RateModle(image: nil, name: "日本円", shotName: "JPY", converValue: "10,566.00"))
        rateList?.append(RateModle(image: nil, name: "中国人民元", shotName: "CNY", converValue: "706.12"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrencyList()
        currencyInputView.delegate = self
        currencyInputView.tapGesAction = { (isSelected) -> Void in
            if isSelected {
                self.currencyInputView.currencies = self.currencies
                self.inputViewHeightConstraint.constant = CGFloat(71 + self.currencies.count * 30)
                self.currencyInputView.rateTable.reloadData()
            } else {
                self.inputViewHeightConstraint.constant = 71
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currencySelected(_ currency: String, _ amount: String) {
//        let urlString =  + "live" + "?access_key=" + "YOUR_ACCESS_KEY"
//        Alamofire.request(<#T##url: URLConvertible##URLConvertible#>)
    }
    
    func getCurrencyList() {
        let urlString = BASE_URL + ENDPOINT_LIST + "?access_key=" + ACCESS_KEY
        Alamofire.request(urlString).responseJSON { response in
            if response.result.isSuccess, let object = response.result.value {
                let json = JSON(object)
            } else {
                self.currencies = [String]()
                print(response.result)
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rateList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = rateList else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateCollectionViewCell", for: indexPath) as! RateCollectionViewCell
        cell.setupView(data: list[indexPath.row])
        return cell
    }
    
    
}

