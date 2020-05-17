//
//  DetailsController.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!
    
    @IBOutlet weak var currencyInput: UITextField!
    @IBOutlet weak var baseInput: UITextField!
    
    var rate: Rate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.title = rate.currency
        
        rateLabel.text = String(format: "%.2f %@", 1 / rate.rate, rate.base)
        deltaLabel.text = String(format: "%+f", rate.delta)
        currencyLabel.text = rate.currency
        baseLabel.text = rate.base
        
        currencyInput.text = String(1)
        baseInput.text = String(format: "%.2f", 1 / rate.rate)
        
        currencyInput.delegate = self
        baseInput.delegate = self
        
        setupInputs()
    }
    
    func setRate(_ rate: Rate) {
        self.rate = rate
    }
    
    func setupInputs() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25)
        let toolbar = UIToolbar(frame: frame)
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Convert", style: .done, target: self, action: #selector(dismissKeyboard))
        ]
        
        toolbar.sizeToFit()
        currencyInput.inputAccessoryView = toolbar
        baseInput.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        currencyInput.endEditing(true)
        baseInput.endEditing(true)
    }
    
    @IBAction func onCurrencyChange(_ sender: UITextField) {
        let value = Double(sender.text ?? "1") ?? 1
        baseInput.text = String(format: "%.2f", value / rate.rate)
    }
    
    @IBAction func onBaseChange(_ sender: UITextField) {
        let value = Double(sender.text ?? "1") ?? 1
        currencyInput.text = String(format: "%.2f", value * rate.rate)
    }
}

// MARK: - Text field delegate
extension DetailsController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let result = text + string
        if text.isEmpty && string == "0" { return false }
        if result.isEmpty { return true }
        if Double(result) == nil { return false }
        return result.count <= 6
    }
}
