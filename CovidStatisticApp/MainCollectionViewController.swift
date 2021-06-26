//
//  ViewController.swift
//  CovidStatisticApp
//
//  Created by Anna Ostapenko on 26.06.21.
//

import UIKit

class MainCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var covidData: CovidStatistic = CovidStatistic(response: ["Germany"])
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicator.startAnimating()
        
        getDataButtonPressed()
    }
    
    
    
    func getDataButtonPressed() {
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
                let httpResponse = response as? HTTPURLResponse
                
                //                print(httpResponse ?? "")
                guard let data = data else { return }
                do {
                    self.covidData = try JSONDecoder().decode(CovidStatistic.self, from: data)
                    print("covidData \(self.covidData)")
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activityIndicator.stopAnimating()
                        //                self.successAlert()
                    }
                } catch let error {
                    print("error====>\(error)")
                    DispatchQueue.main.async {
                        //                self.failedAlert()
                    }
                }
                
            }
        })
        
        dataTask.resume()
        
    }
    
    
    
    @IBAction func onGetDataPressed(_ sender: Any) {
        getDataButtonPressed()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        covidData.response.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
}

extension MainCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
        if covidData.response.count > 1 {
            let country = covidData.response[indexPath.row]
            print("country \(country), row\(indexPath)")
            cell.countryNameLabel.text = country
        }
        
        return cell
    }
}
