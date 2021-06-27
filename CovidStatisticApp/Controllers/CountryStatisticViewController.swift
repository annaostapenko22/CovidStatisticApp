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
        getStatisticData()
       
    }
    
    func getStatisticData(){
        let headers = [
            "x-rapidapi-key": "975ff1a773msh6dc6b5e99f5c3ccp1025f4jsnf831f3c4e791",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-193.p.rapidapi.com/statistics?country=\(country)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
            } else {
                //                let httpResponse = response as? HTTPURLResponse
                //                print(httpResponse ?? "")
                guard let data = data else { return }
                do {
                    self.covidStatistic = try JSONDecoder().decode(CovidStatisticData.self, from: data)
                    print("self.covidStatistic \(self.covidStatistic)")
                    
                    DispatchQueue.main.async {
                        self.generateDisplayData()
                        self.view.reloadInputViews()
                        self.activityIndicator.stopAnimating()
                    }
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                    }
                }
                
            }
        })
        
        dataTask.resume()
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
