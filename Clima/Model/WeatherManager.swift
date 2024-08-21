//
//  File.swift
//  Clima
//
//  Created by Gözde Aydin on 11.08.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//
import Foundation
import UIKit

protocol WeatherManagerDelegate {
    func didWeatherUpdate(weather: WeatherModel, _ weatherManager: WeatherManager)
    func didFailWithError(error: Error?)
}

struct WeatherManager {

    let apiKey = "dcacb5fd111442f009273bbfdcddc291"
    var delegate: WeatherManagerDelegate?

    func getWeather(lat: String, lon: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
    }

    func getWeather(cityName: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
    }

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            // let task = session.dataTask(with: url, completionHandler: handler(data:res:error:))

            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data { // if data is not nil
                    if let decodedWeather = self.parseJson(data: safeData) {
                        delegate?.didWeatherUpdate(weather: decodedWeather, self)
                    }
                }
            }
            task.resume()
        }
    }

    func handler(data: Data?, res: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data { // if data is not nil assing its value to safedata
            print(safeData)
        }
    }

    func parseJson(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data) // given data must be decodable (or codable)
            let id = decodedData.weather[0].id // weather list
            let name = decodedData.name
            let temp = decodedData.main.temp

            let weather = WeatherModel(conditionId: id, cityName: name, tempature: temp)
            return weather
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
