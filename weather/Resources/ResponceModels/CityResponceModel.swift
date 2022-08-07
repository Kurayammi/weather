//
//  CityResponceModel.swift
//  weather
//
//  Created by Kito on 8/7/22.
//

import Foundation

struct GetLocation: Codable {
    let lat: Double
    let long: Double
}
struct Place: Codable {
    let name: String
    let countryFull: String
}
struct GetCity: Codable {
    let loc: GetLocation
    let place: Place
}

struct GetCityResponceModel: Codable {
    let response: [GetCity]
}
