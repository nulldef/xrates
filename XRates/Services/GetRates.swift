//
//  GetRates.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import Foundation
import Combine

protocol GetRatesDelegate {
    func getRates(_ rates: [Rate])
}

fileprivate struct RatesResponse: Decodable {
    let rates: [String: Double]
    let base: String
}

struct URLBuilder {
    private let baseUrl = "https://api.exchangeratesapi.io"
    
    let params: RequestParams
    
    func build() -> URL {
        let path = params.date?.format() ?? "latest"
        let url = URL(string: baseUrl)!.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem(name: "base", value: params.base)]
        
        if let currencies = params.currencies {
            queryItems.append(URLQueryItem(name: "symbols", value: currencies.joined(separator: ",")))
        }
        
        components?.queryItems = queryItems
        return components!.url!
    }
}

class GetRates {
    var base: Currency = "RUB"
    var date: Date?
    var currencies: [Currency]?
    
    var delegate: GetRatesDelegate?
    var cancellable: Set<AnyCancellable> = []
    
    func get() {
        let params = RequestParams(base: base, currencies: currencies, date: date)
        let currentPub = getPublisher(params.date)
        let prevPub = getPublisher((params.date ?? Date()).adding(-1))
        
        currentPub.combineLatest(prevPub)
            .map { (current, prev) -> [Rate] in
                current.rates.map { (currency, rate) -> Rate in
                    let delta = rate - (prev.rates[currency] ?? 0)
                    let date = params.date ?? Date()
                    return Rate(base: params.base, currency: currency, rate: rate, date: date, delta: delta)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (compl) in
                switch compl {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            }) { (rates) in self.delegate?.getRates(rates) }
            .store(in: &cancellable)
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
    
    private func getPublisher(_ date: Date?) -> AnyPublisher<RatesResponse, Error> {
        let params = RequestParams(base: base, currencies: currencies, date: date)
        let url = URLBuilder(params: params).build()
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RatesResponse.self, decoder: JSON.shared.decoder)
            .eraseToAnyPublisher()
    }
}
