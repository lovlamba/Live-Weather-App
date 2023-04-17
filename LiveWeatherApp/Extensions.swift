//
//  Extensions.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 30/03/23.
//

import Foundation
import SwiftUI

extension String{
    func getDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d"
        let cdate = dateFormatter.string(from: date ?? Date())
        return cdate
    }
    func getTime()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "h a"
        let ctime = dateFormatter.string(from: date ?? Date())
        return ctime
    }
}

extension Date{
    func getTimeString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let cdate = dateFormatter.string(from: self)
        return cdate
    }
}

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
