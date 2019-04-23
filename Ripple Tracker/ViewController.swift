//
//  ViewController.swift
//  Ripple Tracker
//
//  Created by Suciu Stefan on 4/24/19.
//  Copyright © 2019 Suciuss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    let baseURL = "https://min-api.cryptocompare.com/data/price?fsym=XRP&tsyms="
    let currencyArray = ["USD","RON","EUR","GBP","JPY","AUD"]
    var finalURL = ""
    var firstCurrencyShown = "USD"
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
     //   print(finalURL)
        getCurrencyData(url: finalURL)
        firstCurrencyShown = currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currencyArray[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(red:0.73, green:0.76, blue:0.77, alpha:1.0)])
        return attributedString
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
    @IBOutlet weak var ripplePriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var gifView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifView.loadGif(name: "priceBg")
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        getCurrencyData(url: "https://min-api.cryptocompare.com/data/price?fsym=XRP&tsyms=USD")

        
    }
    
    func getCurrencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON {response in
                if response.result.isSuccess {
                    
                    //print("Sucess! Got the currency data")
                    let currencyJSON : JSON = JSON(response.result.value!)
                    
                    self.updateCurrencyData(json: currencyJSON)

                } else {
                    //print("Error: \(String(describing: response.result.error))")
                    self.ripplePriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    func updateCurrencyData(json : JSON) {
        
        if json[firstCurrencyShown].double != nil {
            ripplePriceLabel.text = json[firstCurrencyShown].stringValue
        } else {
            ripplePriceLabel.text = "Currency Unavailable"
        }
    }
    
}



