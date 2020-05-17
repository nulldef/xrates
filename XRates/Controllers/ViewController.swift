//
//  ViewController.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var rates: [Rate] = []
    
    var fetcher: GetRates = GetRates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "RateCell", bundle: nil), forCellReuseIdentifier: "RateCell")
        self.table.dataSource = self
        self.table.delegate = self
        
        self.fetcher.currencies = ["EUR", "USD"]
        self.fetcher.delegate = self
        self.fetcher.get()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddCurrencyController {
            controller.setChecked(fetcher.currencies ?? [])
            controller.delegate = self
        }
        
        if let controller = segue.destination as? DetailsController {
            let sender = sender as! Int
            let rate = rates[sender]
            
            controller.setRate(rate)
        }
    }
}

// MARK: - Table data source
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! RateCell
        let rate = self.rates[indexPath.row]
        cell.setRate(rate)
        return cell
    }
}

// MARK: - Table delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "ShowDetails", sender: indexPath.row)
    }
}

// MARK: - Get rates delegate
extension ViewController: GetRatesDelegate {
    func getRates(_ rates: [Rate]) {
        self.rates = rates
        self.table.reloadData()
    }
}

// MARK: - Add currency delegate
extension ViewController: AddCurrencyDelegate {
    func chosen(_ currencies: [Currency]) {
        self.fetcher.currencies = currencies
        self.fetcher.get()
    }
}
