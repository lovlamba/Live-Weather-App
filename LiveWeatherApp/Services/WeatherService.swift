//
//  WeatherManager.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 30/03/23.
//

import Foundation
import CoreLocation

class WeatherService{
    private var baseURL = "https://api.openweathermap.org/data/2.5/"
    private var apiKey = "dfe308c3796eb655b3542be6c97fef2e"
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse{
        guard let url = URL(string: baseURL + "weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return decodedData
    }
    
    func getForecastReport(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastResponse {
        guard let url = URL(string: baseURL + "forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        let decodedData = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return decodedData
    }
}
