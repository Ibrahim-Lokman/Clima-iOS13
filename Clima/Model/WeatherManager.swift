//
//  WeatherManager.swift
//  Clima
//
//  Created by Ibrahim Lokman on 1/6/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dd2cd435b3cb44a7eaeaf368e86e36e7&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){
                (data,  response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                if let safetData = data {
//                    let dataString = String(data: safetData , encoding: .utf8)
//                    print(dataString)
                    if let weather =   self.parseJSON(safetData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
//    func handle(data: Data?, response: URLResponse?, error: Error?){
//        if error != nil {
//            print(error!)
//            return
//        }
//        if let safetData = data {
//            self.parseJSON(weatherData: safetData)
//           
//        }
//    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
       
        do {
        let decodedData =  try  decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            print(weather.temperatureString)
            
            return weather
            
           
            
        } catch{
            print(error)
            delegate?.didFailedWithError(error: error)
            return nil
        }
    }
    }
