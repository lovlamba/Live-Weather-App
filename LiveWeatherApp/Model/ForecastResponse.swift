//
//  ForecastReport.swift
//  Forecast Report
//
//  Created by Lov Lamba on 03/04/23.
//

import Foundation

struct ForecastResponse : Decodable{
    var list : [WeatherReport]
    var city : CityDetails
}

struct WeatherReport : Decodable{
    var main : WeatherOtherDetails
    var weather : [WeatherDetails]
    var dt_txt : String
    var wind : WindDetails
}

struct WeatherOtherDetails : Decodable{
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct WeatherDetails : Decodable{
    var id: Double
    var main: String
    var description: String
    var icon: String
}

struct WindDetails : Decodable{
    var speed: Double
    var deg: Double
}

struct CityDetails : Decodable{
    var name : String
    var coord : CoordinatesResponse
}

struct CoordinatesResponse: Decodable {
    var lon: Double
    var lat: Double
}
