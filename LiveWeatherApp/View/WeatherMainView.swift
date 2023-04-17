//
//  WeatherView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 30/03/23.
//

import SwiftUI
import CoreLocation

struct WeatherMainView: View {
    let model = WeatherViewModel()
    @State var forecastData : [WeatherDailyReport]?
    @State var dayWeather : WeatherDailyReport?
    @State var weather: Weather
    var location: CLLocation
    
    var body: some View {
        ZStack{
            VideoPlayerView(videoName: weather.icon)
            VStack {
                VStack{
                    VStack{
                        Text(weather.place)
                            .bold()
                            .font(.title)
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }.padding(.top, 40.0)
                    Spacer()
                    HStack {
                        VStack(spacing: 20) {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")).frame(maxWidth: 30, maxHeight: 30)
                            Text("\(weather.description)")
                        }
                        .frame(width: 100, alignment: .center)
                        Spacer()
                        Text((Double(weather.temp) ?? 0.0).roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }.padding(.bottom, -20.0)
                }
                if let _ = self.forecastData, let _ = self.dayWeather{
                    WeatherForecastView(forecastData: self.$forecastData, dayWeather: self.$dayWeather, weather: self.$weather)
                }
                WeatherDetailView(weather: self.weather)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        .onAppear{
            Task{
                if let forecastData = await model.getWeatherForecastData(location: self.location){
                    self.forecastData = forecastData
                    self.dayWeather = forecastData[0]
                }
                else{
                    print("Unable to fetch forecast data")
                }
            }
        }
    }
}
