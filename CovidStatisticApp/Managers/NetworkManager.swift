//
//  File.swift
//  CovidStatisticApp
//
//  Created by Anna Ostapenko on 29.06.21.
//

import Foundation

enum URLS: String {
    case countries = "https://covid-193.p.rapidapi.com/countries"
    case covidCountryStatistic = "https://covid-193.p.rapidapi.com/statistics?country="
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCountries(from url: String?, completion: @escaping(CovidCountries) -> Void) {
        guard let stringURL = url else { return }
        
        let headers = [
            "x-rapidapi-key": "975ff1a773msh6dc6b5e99f5c3ccp1025f4jsnf831f3c4e791",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]
        
        
        let request = NSMutableURLRequest(url: NSURL(string: stringURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let covidData = try JSONDecoder().decode(CovidCountries.self, from: data)
                DispatchQueue.main.async {
                    completion(covidData)
                }
            } catch let error {
                print("error \(error)")
            }
            
        }.resume()
    }
    
    func fetchCountryStatistic(from url: String?, with countryName: String, completion: @escaping(CovidStatisticData) -> Void) {
        guard let stringURL = url else { return }
        
        let headers = [
            "x-rapidapi-key": "975ff1a773msh6dc6b5e99f5c3ccp1025f4jsnf831f3c4e791",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(stringURL)\(countryName)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let covidStatisticData = try JSONDecoder().decode(CovidStatisticData.self, from: data)
                DispatchQueue.main.async {
                    completion(covidStatisticData)
                }
            } catch let error {
                print("error \(error)")
            }
            
        }.resume()
    }
}
