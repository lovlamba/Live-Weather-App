//
//  WeatherRowView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 30/03/23.
//

import SwiftUI

struct WeatherDetailView: View {
    var weather: Weather
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Weather now")
                .bold()
                .padding(.bottom)
            HStack {
                HStack(spacing: 20) {
                    Image(systemName: "thermometer")
                        .font(.title2)
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                        .cornerRadius(50)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Min temp")
                            .font(.caption)
                        Text((Double(weather.tempMin) ?? 0.0).roundDouble() + "°")
                            .bold()
                            .font(.title)
                    }
                }
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: "thermometer")
                        .font(.title2)
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                        .cornerRadius(50)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Max temp")
                            .font(.caption)
                        Text((Double(weather.tempMax) ?? 0.0).roundDouble() + "°")
                            .bold()
                            .font(.title)
                    }
                }
            }
            HStack {
                HStack(spacing: 20) {
                    Image(systemName: "wind")
                        .font(.title2)
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                        .cornerRadius(50)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wind speed")
                            .font(.caption)
                        Text((Double(weather.windSpeed) ?? 0.0).roundDouble() + " m/s")
                            .bold()
                            .font(.title)
                    }
                }
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: "humidity")
                        .font(.title2)
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                        .cornerRadius(50)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Humidity")
                            .font(.caption)
                        Text((Double(weather.humidity) ?? 0.0).roundDouble() + "%")
                            .bold()
                            .font(.title)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom, 20)
        .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .background(.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct WeatherRowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weather: Weather(place: "", time: "", weatherId: "", weatherType: "", description: "", icon: "", temp: "", feelsLike: "", tempMin: "", tempMax: "", pressure: "", humidity: "", windSpeed: "", windDeg: ""))
    }
}
