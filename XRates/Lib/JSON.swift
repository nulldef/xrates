//
//  JSON.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import Foundation

struct JSON {
    static let shared = JSON()
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func parse(_ data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print(error)
            return nil
        }
    }
    
    func decode<T: Decodable>(_ data: Data, to: T.Type) -> T? {
        do {
            return try decoder.decode(to, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
