//
//  CheckableRateCell.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import UIKit

class CheckableRateCell: UITableViewCell {
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var mark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    func setItem(_ currency: Currency, checked: Bool) {
        self.currency.text = currency
        self.mark.isHidden = !checked
    }
}
