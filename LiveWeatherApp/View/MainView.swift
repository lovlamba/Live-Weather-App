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
            ZStack{
                VideoPlayerView(weather: $weather).edgesIgnoringSafeArea(.top)
                if model.location != nil {
                    VStack {
                        ScrollView{
                            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                                self.refreshed = true
                                self.getData(isSearched: false)
                                self.showTextfield = false
                                placeName = ""
                            }
                            if !showTextfield{
                                if refreshed{
                                    ProgressView().frame(width: 30.0,height: 30.0).overlay(
                                        RoundedRectangle(cornerRadius: 3.0).stroke(.black, lineWidth: 2.0)
                                    ).background{Color.black}
                                }else{
                                    Text("Swipe down to refresh ⬇️")
                                }
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
                                .fontWeight(.light).padding(.bottom, 50.0)
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
                            }.padding(.bottom, 70.0)
                            WeatherForecastView(forecastData: self.$forecastData, dayWeather: self.$dayWeather, weather: self.$weather)
                        }.coordinateSpace(name: "pullToRefresh")
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


struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
            }
        }.padding(.top, -50)
    }
}
