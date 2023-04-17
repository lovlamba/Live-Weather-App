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
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getCurrentWeather(location: CLLocation) async -> Weather?{
        do{
            let weatherResponse = try await weatherService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let weather = Weather(place: weatherResponse.name, time: Date().getTimeString(), weatherId: String(weatherResponse.weather[0].id), weatherType: weatherResponse.weather[0].main, description: weatherResponse.weather[0].description, icon: weatherResponse.weather[0].icon, temp: String(weatherResponse.main.temp), feelsLike: String(weatherResponse.main.feels_like), tempMin: String(weatherResponse.main.temp_min), tempMax: String(weatherResponse.main.temp_max), pressure: String(weatherResponse.main.pressure), humidity: String(weatherResponse.main.humidity), windSpeed: String(weatherResponse.wind.speed), windDeg: String(weatherResponse.wind.deg))
            return weather
        }catch{
            print(error)
        }
        return nil
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
