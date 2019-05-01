//
//  Route.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import Foundation
typealias Route = [PurpleRoute]

struct PurpleRoute: Codable {
    let cases: Cases?
    let iata: String
    let coordinates: [Double]
    let countryIata: String
    let indexStrings: [String]
    let name: String
    let location: Location
    let searchesCount: Int
    let airportName: String?
    let cityIata: String?
    let cityCases: Cases?

    enum CodingKeys: String, CodingKey {
        case cases, iata, coordinates
        case countryIata = "country_iata"
        case indexStrings = "index_strings"
        case name, location
        case searchesCount = "searches_count"
        case airportName = "airport_name"
        case cityIata = "city_iata"
        case cityCases = "city_cases"
    }
}

struct Cases: Codable {
    let pr, vi, ro, da: String
    let tv: String
}

struct Location: Codable {
    let lon, lat: Double
}
