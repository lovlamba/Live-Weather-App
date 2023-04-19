//
//  WeatherForecastView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 06/04/23.
//

import SwiftUI

struct WeatherForecastView: View {
    @Binding var forecastData : [WeatherDailyReport]?
    @Binding var dayWeather : WeatherDailyReport?
    @Binding var weather: Weather?
    var body: some View {
        VStack{
            HStack{
                ScrollView(.horizontal){
                    HStack{
                        if let dayWeather = dayWeather, let weather = weather{
                            ForEach(0..<dayWeather.hourlyReports.count, id: \.self) { index in
                                Button(action: {
                                    self.weather = dayWeather.hourlyReports[index]
                                }){
                                    Text(dayWeather.hourlyReports[index].time)
                                }.padding().background(weather.time == dayWeather.hourlyReports[index].time ? Color.gray : Color.white).cornerRadius(8).foregroundColor(weather.time == dayWeather.hourlyReports[index].time ? Color.white : Color.black)
                            }
                        }
                    }
                }
            }
            HStack{
                ScrollView(.horizontal){
                    HStack{
                        if let forecastData = forecastData, let dayWeather = dayWeather{
                            ForEach(0..<forecastData.count, id: \.self) { index in
                                Button(action: {
                                    self.dayWeather = forecastData[index]
                                    self.weather = forecastData[index].hourlyReports[0]
                                }){
                                    Text(forecastData[index].date)
                                }.padding().background(dayWeather.date == forecastData[index].date ? Color.gray : Color.white).foregroundColor(dayWeather.date == forecastData[index].date ? Color.white : Color.black)
                            }
                        }
                    }
                }
            }.background(Color.white).cornerRadius(10)
        }
    }
}
