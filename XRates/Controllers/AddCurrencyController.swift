//
//  AddCurrencyController.swift
//  XRates
//
//  Created by nulldef on 17.05.2020.
//  Copyright © 2020 nulldef. All rights reserved.
//

import UIKit

protocol AddCurrencyDelegate {
    func chosen(_ currencies: [Currency])
}

class AddCurrencyController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var delegate: AddCurrencyDelegate?
    
    var fetcher = GetRates()
    var currencies: [Currency] = []
    var checked: Set<Currency> = ["EUR", "USD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "CheckableRateCell", bundle: nil), forCellReuseIdentifier: "CheckableRateCell")
        self.table.dataSource = self
        self.table.delegate = self
        
        self.fetcher.delegate = self
        self.fetcher.get()
    }
    
    func setChecked(_ currencies: [Currency]) {
        self.checked = Set(currencies)
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        delegate?.chosen(Array(self.checked))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table data source
extension AddCurrencyController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckableRateCell") as! CheckableRateCell
        let currency = currencies[indexPath.row]
        let isChecked = checked.contains(currency)
        cell.setItem(currency, checked: isChecked)
        return cell
    }
}

// MARK: - Table delegate
extension AddCurrencyController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        if checked.contains(currency) {
            self.checked.remove(currency)
        } else {
            self.checked.insert(currency)
        }
        self.table.reloadData()
    }
}

// MARK: - Rate fetcher delegate
extension AddCurrencyController: GetRatesDelegate {
    func getRates(_ rates: [Rate]) {
        self.currencies = rates.map { x in x.currency }.sorted()
        self.table.reloadData()
    }
}
