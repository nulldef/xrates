//
//  Rate.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import Foundation

struct Rate {
    let base: Currency
    let currency: Currency
    let rate: Double
    let date: Date
    let delta: Double
}
