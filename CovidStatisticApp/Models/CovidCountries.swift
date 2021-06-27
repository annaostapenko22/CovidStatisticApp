//
//  CovidStatistic.swift
//  CovidStatisticApp
//
//  Created by Anna Ostapenko on 26.06.21.
//

import Foundation


struct CovidCountries: Decodable {
    var response: [String]
}

struct CovidStatisticCountry: Decodable {
    var continent: String?
    var country: String?
    var population: Int?
    var day: String?
    var cases: CovidCase?
}

struct CovidStatisticData: Decodable {
    var response: [CovidStatisticCountry]
}

struct CovidCase: Decodable {
    var active: Int?
    var critical: Int?
    var new: String?
    var recovered: Int
    var total: Int?
}
