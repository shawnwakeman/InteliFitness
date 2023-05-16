//
//  ExerciseChartDataModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/13/23.
//

import SwiftUI

struct SiteView: Identifiable {
    var id = UUID().uuidString
    var day: Date
    var views: Double
    var animate: Bool = false
}


struct exerciseChartDataModel {
    var volume: [SiteView] = []
    var heaviestWeight: [SiteView] = []
    var Projected1RM: [SiteView] = []
    var bestSetVolume: [SiteView] = []
    var TotalReps: [SiteView] = []
    var WeightPerRep: [SiteView] = []
    var LastMonthFreq: [SiteView] = []
    
    mutating func setData(volume: [SiteView], heaviestWeight: [SiteView], Projected1RM: [SiteView], bestSetVolume: [SiteView], TotalReps: [SiteView], WeightPerRep: [SiteView], LastMonthFreq: [SiteView]) {
        self.volume = volume
        self.heaviestWeight = heaviestWeight
        self.Projected1RM = Projected1RM
        self.bestSetVolume = bestSetVolume
        self.TotalReps = TotalReps
        self.WeightPerRep = WeightPerRep
        self.LastMonthFreq = LastMonthFreq
    }
    
    mutating func clearData() {
        self.volume = []
        self.heaviestWeight = []
        self.Projected1RM = []
        self.bestSetVolume = []
        self.TotalReps = []
        self.WeightPerRep = []
        self.LastMonthFreq = []
    }
}



func convertToCGPoints(data: [SiteView]) -> [CGPoint] {

    return data.enumerated().map { CGPoint(x: CGFloat($0.offset), y: CGFloat($0.element.views)) }
}



func calculateBestFitLine(points: [CGPoint], coefficients: [Double], extrapolatedXValues: [CGFloat]) -> [CGPoint] {


    let xValues = points.map { $0.x }
    var yValues: [CGFloat] = []

    // Calculate y-values for the original data points
    for x in xValues {
        var y: CGFloat = 0.0
        for (i, coefficient) in coefficients.enumerated() {
            y += CGFloat(coefficient) * pow(x, CGFloat(i))
        }
        yValues.append(y)
    }

    // Extrapolate additional data points
    var extrapolatedYValues: [CGFloat] = []

    for x in extrapolatedXValues {
        var y: CGFloat = 0.0
        for (i, coefficient) in coefficients.enumerated() {
            y += CGFloat(coefficient) * pow(x, CGFloat(i))
        }
        extrapolatedYValues.append(y)
    }

    // Create array of CGPoint for the best fit line (including extrapolation)
    var bestFitLinePoints: [CGPoint] = []
    for (i, x) in xValues.enumerated() {
        bestFitLinePoints.append(CGPoint(x: x, y: yValues[i]))
    }
    for (i, x) in extrapolatedXValues.enumerated() {
        bestFitLinePoints.append(CGPoint(x: x, y: extrapolatedYValues[i]))
    }

    return bestFitLinePoints
}
func getCoefficients(regression: [Double]?) -> [Double] {
    var coefficientsDone: [Double] = []
    for i in 0..<regression!.count {
        let coefficient = regression![i]
        coefficientsDone.append(coefficient)
        
    }
    
    return coefficientsDone
    
}


func getYValues(from points: [CGPoint]) -> [Double] {
    return points.map { Double($0.y) }
}






extension Date {
    func updateDay(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: value, to: self) ?? .now
    }
}



func generateSiteViews(startDate: Date, endDate: Date, viewCounts: [Double]) -> [SiteView] {
    let calendar = Calendar.current
    let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    let stepSize = totalDays / (viewCounts.count - 1)

    return viewCounts.enumerated().map { index, views in
        let day = startDate.updateDay(value: index * stepSize)
        return SiteView(day: day, views: views)
    }
}

extension Double {
    var stringFormat: String {
        if self > 10000 && self < 999999 {
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self >  999999 {
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
        
    }
}
