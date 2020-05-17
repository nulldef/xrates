//
//  RateCell.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layerView.layer.cornerRadius = 5
    }
    
    func setRate(_ rate: Rate) {
        self.currencyLabel.text = rate.currency
        self.rateLabel.text = String(format: "%.2f %@", 1.0 / rate.rate, rate.base)
        self.deltaLabel.text = String(format: "%+f", rate.delta)
        self.deltaLabel.textColor = rate.delta >= 0 ? UIColor.success : UIColor.danger
    }
}
