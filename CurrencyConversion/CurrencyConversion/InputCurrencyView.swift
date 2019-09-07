//
//  InputCurrencyView.swift
//  CurrencyConversion
//
//  Created by luoxiaofeng on 2019/08/10.
//  Copyright © 2019年 luoxiaofeng. All rights reserved.
//

import UIKit

protocol DidSelectCurrencyDelegate {
    func currencySelected(_ currency: String, _ amount: String)
}

typealias TapGesAction = (_ isOpen: Bool) -> Void
typealias DidSelectCurrency = (_ currency: String, _ amount: String) -> Void

class InputCurrencyView: UIView {

    @IBOutlet weak var currencyInputField: UITextField!
    @IBOutlet weak var selectedRateLabel: UILabel!
    @IBOutlet weak var expandImage: UIImageView!
    @IBOutlet weak var rateTable: UITableView!
    
    var currencies: [String]?
    var tapGesAction: TapGesAction?
    var delegate: DidSelectCurrencyDelegate?
    var isSelect: Bool = false
    var isSelected: Bool? {
        didSet {
            isSelect = isSelected!
            if isSelected! {
                UIView.animate(withDuration: 0.2, animations: {
                    self.expandImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.expandImage.transform = CGAffineTransform.identity
                })
            }
        }
    }
    var toConvertAmount: String = "0"
    var currentCurrency: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var contentView: UIView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView = loadXib()
//        addSubview(contentView)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadXib()
        addSubview(contentView)
        setupView()
    }
    
    func loadXib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setupView() {
        selectedRateLabel.layer.borderWidth = 1
        rateTable.layer.borderWidth = 1
        rateTable.register(UITableViewCell.self, forCellReuseIdentifier: "CurrencyView")
        let gesture = UITapGestureRecognizer(target:self, action: #selector(tapAction))
        expandImage.addGestureRecognizer(gesture)
        let selectGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        selectedRateLabel.addGestureRecognizer(selectGes)
    }
    
    @objc func tapAction() {
        rotateImage()
    }
    
    fileprivate func rotateImage() {
        isSelect = !isSelect
        isSelected = isSelect
        if let action = tapGesAction {
            action(isSelected!)
        }
    }
    
    fileprivate func didSelect() {
        if let currency = currentCurrency {
            delegate?.currencySelected(currency, toConvertAmount)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currencyInputField.endEditing(true)
        didSelect()
    }
    
}

extension InputCurrencyView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        toConvertAmount = textField.text ?? "0"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyInputField.resignFirstResponder()
        didSelect()
        return true
    }
    
}

extension InputCurrencyView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let values = currencies else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyView", for: indexPath) as UITableViewCell
        cell.textLabel?.text = values[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let values = currencies {
            currentCurrency = values[indexPath.row]
            selectedRateLabel.text = values[indexPath.row]
        }
        rotateImage()
        didSelect()
    }
    
}
