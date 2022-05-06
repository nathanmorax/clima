//
//  WeatherManager.swift
//  Clima
//
//  Created by Nathan Mora on 02/05/22.
//  Copyright © 2022 Nathan Mora. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
   
   func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
   func didFailWithError(error: Error)
   
}

struct WeatherManager {
   let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1011a0bb76d2ef4fd22aed0724b594c6&units=metric"
   
   var delegate: WeatherManagerDelegate?
   
   func fetchWeather(cityName : String) {
      let urlString = "\(weatherURL)&q=\(cityName)"
      
      perfomRequest(with: urlString)
   }
   
   func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
      let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
      perfomRequest(with: urlString)
   }
   
   func perfomRequest(with urlString: String) {
      
      if let url = URL(string: urlString) {
         
         let session = URLSession(configuration: .default)
         
         let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
               print(error!)
               self.delegate?.didFailWithError(error: error!)
               return
            }
            
            if let safeData = data {
               if let weather = self.parseJSON(safeData) {
                  self.delegate?.didUpdateWeather(self, weather: weather)
               }
            }
         }
         
         task.resume()
         
      }
      
   }
   
   func parseJSON(_ weatherData: Data) -> WeatherModel? {
      let decoder = JSONDecoder()
      do {
         let decoded = try decoder.decode(WeatherData.self, from: weatherData)
         let id = decoded.weather[0].id
         let name = decoded.name
         let temp = decoded.main.temp
         
         let weather = WeatherModel(conditionalId: id, cityName: name, temperature: temp)
         return weather
      } catch {
         print(error)
         delegate?.didFailWithError(error: error)
         return nil
      }
   }

}
