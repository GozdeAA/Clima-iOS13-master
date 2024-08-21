//
//  WeatherModel.swift
//  Clima
//
//  Created by Gözde Aydin on 21.08.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let tempature: Double
    
    var tempatureString: String {
        return String(format: "%.1f", tempature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
            
        case 500...531:
            return "cloud.rain"
            
        case 600...622:
            return "snowflake"
            
        case 700...781:
            return "tornado"
            
        default:
            return "rainbow"
        }
    }
}
