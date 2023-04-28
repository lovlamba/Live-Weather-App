//
//  File.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 04/04/23.
//

import Foundation
import CoreLocation

class MainViewModel: NSObject, ObservableObject{
    private var weatherService = WeatherService()
    @Published var location: CLLocation?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init ()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getCurrentWeather(location: CLLocation) async -> Weather?{
        do{
            let weatherResponse = try await weatherService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let weather = Weather(place: weatherResponse.name, time: Date().getTimeString(), weatherId: String(weatherResponse.weather[0].id), weatherType: weatherResponse.weather[0].main, description: weatherResponse.weather[0].description, icon: weatherResponse.weather[0].icon, temp: String(weatherResponse.main.temp), feelsLike: String(weatherResponse.main.feels_like), tempMin: String(weatherResponse.main.temp_min), tempMax: String(weatherResponse.main.temp_max), pressure: String(weatherResponse.main.pressure), humidity: String(weatherResponse.main.humidity), windSpeed: String(weatherResponse.wind.speed), windDeg: String(weatherResponse.wind.deg))
            return weather
        }catch{
            print(error.localizedDescription)
        }
        print("Unable to get weather")
        return nil
    }
    
    func getWeatherForecastData(location : CLLocation) async -> [WeatherDailyReport]?{
        do{
            let report = try await weatherService.getForecastReport(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            return self.getWeatherData(weatherApiResponse: report)
        }
        catch{
            print(error.localizedDescription)
        }
        print("Unable to get forecast data")
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
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    static func getVideoName(iconName: String) -> String{
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

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        self.location = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
