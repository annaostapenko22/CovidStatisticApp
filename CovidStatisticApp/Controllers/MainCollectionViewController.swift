//
//  ViewController.swift
//  CovidStatisticApp
//
//  Created by Anna Ostapenko on 26.06.21.
//

import UIKit

class MainCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchCountryTextField: UITextField!
    
    var covidData: CovidCountries = CovidCountries(response: [""])
    
    var country: String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.searchCountryTextField.delegate = self
        activityIndicator.startAnimating()
        
        getCountriesData()
    }
    
    func getCountriesData() {
        let headers = [
            "x-rapidapi-key": "975ff1a773msh6dc6b5e99f5c3ccp1025f4jsnf831f3c4e791",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-193.p.rapidapi.com/countries")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
            } else {
                guard let data = data else { return }
                do {
                    self.covidData = try JSONDecoder().decode(CovidCountries.self, from: data)
                    //                    print("covidData \(self.covidData)")
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let covidCountryVC = navigationVC.topViewController as? CountryStatisticViewController else { return }
        covidCountryVC.country = "\(sender as! String)"
    }
}

extension MainCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
        if covidData.response.count > 1 {
            let country = covidData.response[indexPath.row]
            cell.countryNameLabel.text = country
            cell.layer.cornerRadius = 15
            cell.backgroundColor = self.view.hexStringToUIColor(hex: "#6A7EFC")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
        if covidData.response.count > 1 {
            let covidCountry = covidData.response[indexPath.row]
            performSegue(withIdentifier: "covidCountrySegue", sender: covidCountry.lowercased())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        covidData.response.count > 1 ? covidData.response.count : 0
    }

}
