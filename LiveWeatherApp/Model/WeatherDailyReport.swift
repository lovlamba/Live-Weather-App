//
//  ForecastReport.swift
//  Forecast Report
//
//  Created by Lov Lamba on 03/04/23.
//

import Foundation

struct WeatherDailyReport{
    var date: String = ""
    var hourlyReports : [Weather] = [Weather]()
}

struct Weather{
    var place : String = ""
    var time : String = ""
    var weatherId: String = ""
    var weatherType: String = ""
    var description: String = ""
    var icon: String = ""
    var temp: String = ""
    var feelsLike: String = ""
    var tempMin: String = ""
    var tempMax: String = ""
    var pressure: String = ""
    var humidity: String = ""
    var windSpeed: String = ""
    var windDeg: String = ""
}
