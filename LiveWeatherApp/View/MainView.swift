//
//  ContentView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 04/04/23.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @StateObject var model = MainViewModel()
    @State var forecastData : [WeatherDailyReport]?
    @State var dayWeather: WeatherDailyReport?
    @State var weather: Weather?
    @State var refreshed = false
    
    var body: some View {
        VStack {
            if model.location != nil {
                ZStack{
                    VideoPlayerView(weather: $weather).edgesIgnoringSafeArea(.top)
                    VStack {
                        VStack{
                            Text(weather?.place ?? "")
                                .bold()
                                .font(.title)
                            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)
                        }.padding(.top, 20.0)
                        Spacer()
                        HStack {
                            VStack(spacing: 20) {
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather?.icon ?? "")@2x.png")).frame(maxWidth: 30, maxHeight: 30)
                                Text(weather?.description ?? "")
                            }
                            .frame(width: 100, alignment: .center)
                            Spacer()
                            Text(self.weather == nil ? "-" : (Double(weather!.temp) ?? 0.0).roundDouble() + "°")
                                .font(.system(size: 100))
                                .fontWeight(.bold)
                                .padding()
                        }.padding(.bottom, -20.0)
                        WeatherForecastView(forecastData: self.$forecastData, dayWeather: self.$dayWeather, weather: self.$weather)
                        WeatherDetailView(weather: self.weather)
                        
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.height > 200 {
                            self.refreshed = true
                            self.getData()
                        }
                    }))
                .onAppear{
                    self.getData()
                }
                .onChange(of: refreshed){ isRefreshed in
                    if isRefreshed{
                        self.getData()
                        self.refreshed = false
                    }
                }
            } else {
                Text("Unable to access location. Try Again Later.").onAppear{
                    self.model.locationManager.requestWhenInUseAuthorization()
                }
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
    
    func getData(){
        Task{
            if let location = model.location{
                self.weather = await model.getCurrentWeather(location: location)
                self.forecastData = await model.getWeatherForecastData(location: location)
                if let forecastData = forecastData{
                    self.dayWeather = forecastData[0]
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
