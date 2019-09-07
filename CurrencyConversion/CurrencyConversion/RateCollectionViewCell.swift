//
//  RateCollectionViewCell.swift
//  CurrencyConversion
//
//  Created by luoxiaofeng on 2019/08/10.
//  Copyright © 2019年 luoxiaofeng. All rights reserved.
//

import UIKit

class RateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyShotName: UILabel!
    @IBOutlet weak var currencyRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
    }
    
    func setupView(data: RateModle) {
        if let image = data.image {
            flagImage.image = image
        }
        currencyName.text = data.name
        currencyShotName.text = data.shotName
        currencyRate.text = data.converValue
    }
    
}
