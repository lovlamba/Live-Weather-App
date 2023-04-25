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
    @State var showTextfield = false
    @State var placeName = ""
    @State var searchLocation: CLLocation?
    
    var body: some View {
        VStack {
            if refreshed{
                ProgressView().frame(width: 20.0,height: 20.0)
            }
            ZStack{
                VideoPlayerView(weather: $weather).edgesIgnoringSafeArea(.top).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.height > 200 {
                            self.refreshed = true
                            self.getData(isSearched: false)
                            self.showTextfield = false
                            placeName = ""
                        }
                    }))
                if model.location != nil {
                    VStack {
                        VStack{
                            if !showTextfield{
                                HStack{
                                    Text(weather?.place ?? "")
                                        .bold()
                                        .font(.title)
                                    Button(action: {
                                        self.showTextfield = true
                                    }){
                                        Image(systemName: "magnifyingglass").resizable()
                                            .frame(width: 20.0, height: 20.0).foregroundColor(.white)
                                    }
                                }
                            }
                            else{
                                HStack {
                                    TextField("Search Place...", text: self.$placeName)
                                        .frame(width: 150.0)
                                    Button(action: {
                                        model.getCoordinateFrom(address: placeName) { coordinate, error in
                                            guard let coordinate = coordinate, error == nil else {
                                                print(error?.localizedDescription as Any)
                                                return
                                            }
                                            self.searchLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                            self.refreshed = true
                                            self.getData(isSearched: true)
                                        }
                                        self.showTextfield = false
                                        placeName = ""
                                    }){
                                        Image(systemName: "magnifyingglass").resizable()
                                            .frame(width: 20.0, height: 20.0).foregroundColor(.white)
                                    }
                                }
                                .padding(8.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0).stroke(.white, lineWidth: 2.0)
                                )
                            }
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
                    .onAppear{
                        self.refreshed = true
                        self.getData(isSearched: false)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
    
    func getData(isSearched: Bool){
        Task{
            if let location = isSearched ? self.searchLocation : model.location{
                self.weather = await model.getCurrentWeather(location: location)
                self.forecastData = await model.getWeatherForecastData(location: location)
                if let forecastData = forecastData{
                    self.dayWeather = forecastData[0]
                }
                self.refreshed = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
