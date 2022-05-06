//
//  WeatherData.swift
//  Clima
//
//  Created by Nathan Mora on 02/05/22.
//  Copyright © 2022 Nathan Mora. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
   let name: String
   let main: Main
   let weather: [Weather]
   
}

struct Main: Codable {
   let temp: Double
}

struct Weather: Codable {
   let description: String
   let id: Int
}
