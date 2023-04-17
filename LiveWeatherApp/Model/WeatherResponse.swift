//
//  File.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 30/03/23.
//

import Foundation

struct WeatherResponse: Decodable {
    var id: Double
    var coord: CoordinatesResponse
    var weather: [WeatherDetails]
    var main: WeatherOtherDetails
    var name: String
    var wind: WindDetails
}
 
