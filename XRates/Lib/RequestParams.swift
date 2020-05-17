//
//  RequestParams.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import Foundation

struct RequestParams {
    let base: Currency
    let currencies: [Currency]?
    let date: Date?
}
