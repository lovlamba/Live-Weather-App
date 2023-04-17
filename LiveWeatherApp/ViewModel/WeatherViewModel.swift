//
//  File.swift
//  Forecast Report
//
//  Created by Lov Lamba on 03/04/23.
//

import Foundation
import CoreLocation

class WeatherViewModel{
    private var weatherService = WeatherService()
    
    func getWeatherForecastData(location : CLLocation) async -> [WeatherDailyReport]?{
        do{
            let report = try await weatherService.getForecastReport(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            return self.getWeatherData(weatherApiResponse: report)
        }
        catch{
            print(error)
        }
        return nil
    }
    
    private func getWeatherData( weatherApiResponse: ForecastResponse) -> [WeatherDailyReport]{
        var data = [WeatherDailyReport]()
        var currentDate = weatherApiResponse.list[0].dt_txt.getDate()
        var dailyReport = WeatherDailyReport(date: currentDate, hourlyReports: [Weather]())
        for response in weatherApiResponse.list {
            if response.dt_txt.getDate() != currentDate{
                data.append(dailyReport)
                dailyReport = WeatherDailyReport(date: response.dt_txt.getDate(), hourlyReports: [Weather]())
                currentDate = response.dt_txt.getDate()
            }
            let hourlyReport = Weather(place: weatherApiResponse.city.name, time: response.dt_txt.getTime(), weatherId: String(response.weather[0].id), weatherType: response.weather[0].main, description: response.weather[0].description, icon: response.weather[0].icon, temp: String(response.main.temp), feelsLike: String(response.main.feels_like), tempMin: String(response.main.temp_min), tempMax: String(response.main.temp_max), pressure: String(response.main.pressure), humidity: String(response.main.humidity), windSpeed: String(response.wind.speed), windDeg: String(response.wind.deg))
            dailyReport.hourlyReports.append(hourlyReport)
        }
        data.append(dailyReport)
        return data
    }
    
    func getVideoName(iconName: String) -> String{
        switch iconName {
          case "01d":
            return "day"
          case "01n":
            return "night"
          case "03d", "04d":
            return "cloudyDay"
          case "03n", "04n":
            return "cloudyNight"
          case "11d", "11n":
            return "thunderstorm"
          case "09d", "10d", "09n", "10n":
            return "rain"
          default:
            return "day"
        }
    }
}
