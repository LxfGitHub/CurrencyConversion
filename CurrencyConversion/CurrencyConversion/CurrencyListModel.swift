//
//  CurrencyListModel.swift
//  CurrencyConversion
//
//  Created by luoxiaofeng on 2019/08/12.
//  Copyright © 2019年 luoxiaofeng. All rights reserved.
//

import SwiftyJSON

struct CurrencyListModel {
    var success: Bool
    var terms: String?
    var privacy: String?
    var currencies: [String: String]?
    

}
