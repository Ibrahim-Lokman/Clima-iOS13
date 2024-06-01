//
//  WeatherManager.swift
//  Clima
//
//  Created by Ibrahim Lokman on 1/6/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=dd2cd435b3cb44a7eaeaf368e86e36e7&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){
                (data,  response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safetData = data {
//                    let dataString = String(data: safetData , encoding: .utf8)
//                    print(dataString)
                    self.parseJSON(weatherData: safetData)
                }
            }
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        if let safetData = data {
            self.parseJSON(weatherData: safetData)
           
        }
    }
    
    func parseJSON(weatherData: Data){
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
            
           
            
        } catch{
            print(error)
        }
    }
    
//    func getConditionName(weatherId: Int) -> String{
//        switch weatherId {
//        case 200...232:
//            return "cloud.bolt"
//        case 300...321:
//            return "cloud.drizzle"
//        case 500...531:
//            return "cloud.rain"
//        case 600...622:
//            return "cloud.snow"
//        case 701...781:
//            return "cloud.fog"
//        case 800:
//            return "sun.max"
//        case 801...804:
//            return "cloud.bolt"
//        default:
//            return "cloud"
//        }
//    }
}
