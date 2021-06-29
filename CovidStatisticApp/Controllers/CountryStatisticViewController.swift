//
//  CountryStatisticViewController.swift
//  CovidStatisticApp
//
//  Created by Anna Ostapenko on 27.06.21.
//

import UIKit

class CountryStatisticViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var covidStatistic: CovidStatisticData = CovidStatisticData(response: [])
    
    var country = String()
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var recoveredCases: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        countryName.text = country.self
        
        fetchData(from: URLS.covidCountryStatistic.rawValue, with: country)
        
    }
    
    private func fetchData(from url: String?, with countryName: String) {
        NetworkManager.shared.fetchCountryStatistic(from: URLS.covidCountryStatistic.rawValue, with: country) {  covidStatistic in
            self.covidStatistic = covidStatistic
            self.generateDisplayData()
            self.view.reloadInputViews()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func generateDisplayData() {
        if covidStatistic.response.count != 0{
            guard let country = covidStatistic.response[0] as CovidStatisticCountry? else { return }
            countryName.text = "\(country.country ?? "unknown")"
            population.text = "Population: \(country.population ?? 0)"
            date.text = "Day: \(country.day ?? "unknown")"
            newCases.text = "new: \(country.cases?.new ?? "unknown")"
            recoveredCases.text = "recovered: \(String(country.cases?.recovered ?? 0))"
            totalCases.text = "total: \(country.cases?.total ?? 0)"
        }
    }
}
