//
//  Charts.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/13/23.
//

import SwiftUI

import Charts

import PolynomialRegressionSwift



func format(date: Date) -> String {
    let dayFormatter = NumberFormatter()
    dayFormatter.numberStyle = .ordinal

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d" // day
    let day = Int(dateFormatter.string(from: date))!
    let dayString = dayFormatter.string(from: NSNumber(value: day))!
    
    dateFormatter.dateFormat = "MMMM" // month
    let monthString = dateFormatter.string(from: date)
    
    return "\(monthString) \(dayString)"
}


enum chartTab: Int {
    case page1 = 0
    case page2
    case page3

}

struct PolynomialRegressionGraph: View {
    @State var sampleAnalytics: [SiteView]
    @State var lineOfBestFitDataFormatted: [SiteView]

    @State var currentTab: String = "7 Days"
    @State var currentActiveItem: SiteView?
    @State var plotWidth: CGFloat = 0
    @State var showingAve: Bool = false
    @State var selectedTab: chartTab = .page1
    
    private var customBinding: Binding<chartTab> {
        Binding<chartTab>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )
    }
    
    var body: some View {
     
        VStack {
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    TextHelvetica(content: "Predicted 1RM", size: 22)
                        .lineLimit(2)
                        .bold()
                        .foregroundColor(Color("LinkBlue"))
                        .onTapGesture {
                            showingAve.toggle()
                        }
                        .padding(.trailing, 5)
                    
                    Spacer()
                        
//
                    CustomSegmentedPickerChart(selection: customBinding, labels: ["3 Months", "1 Year", "All Time"])
                }
                
                if let maxViews = sampleAnalytics.map({ $0.views }).max() {
                   
                
                    if let item = currentActiveItem {
                        
                        
                        TextHelvetica(content: "\(item.views.stringFormat) lbs", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                    } else {
                        TextHelvetica(content: "\(maxViews.stringFormat) lbs", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                    }
                }
                
                AnimatedChart()

            }
            .padding()
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))

            
            
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle("cume")
        .onChange(of: selectedTab) { newValue in
            let calendar = Calendar.current
            var comparisonDate: Date?
            
            for (index, _) in sampleAnalytics.enumerated() {



            
                   
                
                sampleAnalytics[index].animate = false
                lineOfBestFitDataFormatted[index].animate = false
       
            }
            
          
            
            if newValue == .page1 {
                comparisonDate = calendar.date(byAdding: .month, value: -3, to: Date()) // Last 3 months
            } else if newValue == .page2 {
                comparisonDate = calendar.date(byAdding: .year, value: -1, to: Date()) // Last year
            }
            
            let filteredAnalytics = sampleAnalytics.filter { data in
                   guard let comparisonDate = comparisonDate else {
                       // If there is no comparison date (selectedTab == 2), include all data
                       return true
                   }

                   // Only include the data if its date is more recent than the comparison date
                   return data.day >= comparisonDate
               }
               
               // Replace sampleAnalytics with the filtered version
               sampleAnalytics = filteredAnalytics

               animatePlot(fromChange: true)
        }

            

            
          
       
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        
        

        let max = sampleAnalytics.max { item1, item2 in
            return item2.views > item1.views
            
       
            
        }?.views ?? 0
  
        ZStack {
            Chart {
                    
                    ForEach(lineOfBestFitDataFormatted) { item in

                            LineMark (
                                x: .value("Hour", item.day, unit: .day),
                                y: .value("New View", item.animate ? item.views : 0)

                            )
                            .lineStyle(StrokeStyle(dash: [5, 2]))
                            .foregroundStyle(Color("WhiteFontOne"))
                           
                            
                           
                            



                    }
                    
                    
                    ForEach(sampleAnalytics) { item in
                        


                        PointMark(
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )
                        .symbol() {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                Circle()
                                    .stroke(Color("LinkBlue"), lineWidth: 2)
                            }
                            .frame(width: 10, height: 10)
                        }
                        .symbolSize(30)
                        
                        if let currentActiveItem,currentActiveItem.id == item.id {
//                            let _ = print(sampleAnalytics.count)
                            

                            PointMark(
                                x: .value("Hour", item.day, unit: .day),
                                y: .value("Views", item.animate ? item.views : 0)
                            )

                            .foregroundStyle(Color("LinkBlue"))



                        }

                       

    //                    RuleMark(y: .value("Limit", 200))
    //                        .foregroundStyle(.cyan)
    //                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
    //                        .annotation(alignment: .leading) {
    //                            Text("Goal")
    //                                .background(.green)
    //                        }

                        
                    }
                
                   
            }
                .chartPlotStyle { plotContent in
                  plotContent
                       
                   
                }
       
                
                .chartXAxis {
                
                    AxisMarks(values: .automatic) { _ in
                      AxisGridLine()
                        .foregroundStyle(Color("GrayFontOne"))
                        AxisTick(stroke: StrokeStyle())
                        
                            .foregroundStyle(Color("GrayFontOne"))
                        AxisGridLine(centered: true, stroke: StrokeStyle())
                        .foregroundStyle(Color("GrayFontOne"))
                   
                  }
                }
                .chartYAxis {
                  AxisMarks(values: .automatic) { value in
                   
                      AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2]))
                      .foregroundStyle(Color("GrayFontOne"))

                    AxisValueLabel()
                          .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                          .foregroundStyle(Color("WhiteFontOne"))
                  }
                }
            
                


                .chartYScale(domain: 0...(max + max * 0.3))

                .chartOverlay(content: { proxy in
                    GeometryReader { innerProxy in
                        Rectangle()
                            .fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x) {
                                            let calendar = Calendar.current
                                            let hour = calendar.component(.day, from: date)
                                            if let currentItem = sampleAnalytics.first(where: { item in
                                                calendar.component(.day, from: item.day) == hour
                                            }) {
                                                self.currentActiveItem = currentItem
                                                self.plotWidth = proxy.plotAreaSize.width * 0.18
                                            }
                                        }
                                    }
                                    .onEnded { value in
                                        self.currentActiveItem = nil
                                    }
                                    .simultaneously(with: LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                                    self.currentActiveItem = nil
                                })
                            )
                    }

                })
                .frame(height: 250)
                .onAppear {
                    animatePlot()
                    
            }
            VStack {
                Spacer()
                HStack {
                    
                    let formattedDate1 = format(date: sampleAnalytics.first!.day)
           
                    let date24HoursEarlier = sampleAnalytics.last!.day.addingTimeInterval(-86400)
                    let formattedDate2 = format(date: date24HoursEarlier)
                  
                    Text(formattedDate1)
                        .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                        .foregroundStyle(Color("WhiteFontOne"))
                    Spacer()
                    Text(formattedDate2)
                        .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                        .foregroundStyle(Color("WhiteFontOne"))
                    
                    
                }.padding(.horizontal, 20)
                    .offset(x: -getScreenBounds().width * 0.03, y: getScreenBounds().height * 0.025)
                
            }
        }.padding(.bottom, 15)

           
        


    }
    
    func animatePlot(fromChange: Bool = false) {
        let animationDuration = fromChange ? 0.3 : 0.5 // Ad
        if sampleAnalytics.count <= 20 {
            for (index,_) in sampleAnalytics.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                    withAnimation(fromChange ? .easeInOut(duration: 0.56) : .easeInOut(duration: 0.8)) {
                        sampleAnalytics[index].animate = true
                        lineOfBestFitDataFormatted[index].animate = true
                    }
                }
               
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    for (index, _) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].animate = true
                        lineOfBestFitDataFormatted[index].animate = true
                        
                    }
                }
            }
        }

    }
}

enum chartType: Int {
    case volume = 0
    case heaviestSet
    case bestSetVolume
    case totalReps
    case wightperRep

}


struct Graph: View {
    @State var sampleAnalytics: [SiteView]
    @State var currentTab: String
    @State var currentActiveItem: SiteView?
    @State var plotWidth: CGFloat = 0
    @State var showingAve: Bool = false
    @State var isLine: Bool
    
    @State var selectedTab: chartTab = .page1
    
    var currentChart: chartType
    

    
    private var customBinding: Binding<chartTab> {
        Binding<chartTab>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )
    }
    var body: some View {
 
        VStack {
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    
                    switch currentChart {
                    case .volume:
                        TextHelvetica(content: "Volume", size: 22)
                            .lineLimit(2)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
//                            .onTapGesture {
//                                showingAve.toggle()
//                            }
                            .padding(.trailing, 5)
                        
                        
                         
                    case .heaviestSet:
                        TextHelvetica(content: "Heaviest Weight", size: 22)
                            .lineLimit(2)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
//                            .onTapGesture {
//                                showingAve.toggle()
//                            }
                    case .bestSetVolume:
                        TextHelvetica(content: "Best Set Volume", size: 22)
                            .lineLimit(2)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
//                            .onTapGesture {
//                                showingAve.toggle()
//                            }
                        
                        
                        
                        
                    case .wightperRep:
                        TextHelvetica(content: "Weight/Rep", size: 22)
                            .lineLimit(2)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
//                            .onTapGesture {
//                                showingAve.toggle()
//                            }
                      
                        
                    case .totalReps:
                        TextHelvetica(content: "Total Reps", size: 22)
                            .lineLimit(2)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
//                            .onTapGesture {
//                                showingAve.toggle()
//                            }
                       
                    }
                   
                    
                    
                    
                        
                    Spacer()
                    CustomSegmentedPickerChart(selection: customBinding, labels: ["3 Months", "1 Year", "All Time"])
                }
                
                switch currentChart {
                case .volume:
                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                        item.views + partialResult
                    }
                    
                    if let item = currentActiveItem {
                        TextHelvetica(content: "\(item.views.stringFormat) lbs", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        
                    } else {
                    
                        TextHelvetica(content: "\(totalValue.stringFormat) lbs", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                    
                    
                     
                case .heaviestSet:
                    
                    if let maxViews = sampleAnalytics.map({ $0.views }).max() {
                       
                    
                        if let item = currentActiveItem {
                            
                            
                            TextHelvetica(content: "\(item.views.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        } else {
                            TextHelvetica(content: "\(maxViews.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        }
                    }
                case .bestSetVolume:
                    if let maxViews = sampleAnalytics.map({ $0.views }).max() {
                       
                    
                        if let item = currentActiveItem {
                            
                            
                            TextHelvetica(content: "\(item.views.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        } else {
                            TextHelvetica(content: "\(maxViews.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        }
                    }
                    
                case .wightperRep:
                    if let maxViews = sampleAnalytics.map({ $0.views }).max() {
                       
                    
                        if let item = currentActiveItem {
                            
                            
                            TextHelvetica(content: "\(item.views.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        } else {
                            TextHelvetica(content: "\(maxViews.stringFormat) lbs", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                        }
                    }
                    
                case .totalReps:
                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                        item.views + partialResult
                    }
                    
                    if let item = currentActiveItem {
                        TextHelvetica(content: "\(item.views.stringFormat) reps", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        
                    } else {
                    
                        TextHelvetica(content: "\(totalValue.stringFormat) reps", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                   
                }
                

                

              
                
                AnimatedChart()

            }
            .padding()
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))

            
            
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle("cume")
        .onChange(of: selectedTab) { newValue in
            let calendar = Calendar.current
            var comparisonDate: Date?
            
            for (index, _) in sampleAnalytics.enumerated() {



            
                   
                
                sampleAnalytics[index].animate = false
       
            }
            
            animateGraph(fromChange: true)
            
            if newValue == .page1 {
                comparisonDate = calendar.date(byAdding: .month, value: -3, to: Date()) // Last 3 months
            } else if newValue == .page2 {
                comparisonDate = calendar.date(byAdding: .year, value: -1, to: Date()) // Last year
            }
            
            let filteredAnalytics = sampleAnalytics.filter { data in
                   guard let comparisonDate = comparisonDate else {
                       // If there is no comparison date (selectedTab == 2), include all data
                       return true
                   }

                   // Only include the data if its date is more recent than the comparison date
                   return data.day >= comparisonDate
               }
               
               // Replace sampleAnalytics with the filtered version
               sampleAnalytics = filteredAnalytics

               animateGraph(fromChange: true)
        }
            
          
        
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        
        let curColor = Color("LinkBlue")
              
        let curGradient = LinearGradient(
                    gradient: Gradient (
                        colors: [
                            
                            curColor.opacity(0.5),
                            curColor.opacity(0.2),
                            curColor.opacity(0.05),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
        let max = sampleAnalytics.max { item1, item2 in
            return item2.views > item1.views
            
       
            
        }?.views ?? 0
        
        ZStack {
            Chart {

                ForEach(sampleAnalytics) {item in
                    if isLine {
                        AreaMark(
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )
                       
                        .foregroundStyle(curGradient)



                        LineMark (
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)

                        )
                  
                        .foregroundStyle(.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2.5))
                        .symbol() {
                            Circle()
                                .stroke(Color.red, lineWidth: 2.5)
                                .frame(width: 10, height: 10)
                        }
                        .symbolSize(30)
                        .foregroundStyle(Color("LinkBlue"))

                        
                        PointMark(
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )
                        .symbol() {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                Circle()
                                    .stroke(Color("LinkBlue"), lineWidth: 2)
                            }
                            .frame(width: 10, height: 10)
                        }
                        .symbolSize(30)


                   

    //                    RuleMark(y: .value("Limit", 200))
    //                        .foregroundStyle(.cyan)
    //                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
    //                        .annotation(alignment: .leading) {
    //                            Text("Goal")
    //                                .background(.green)
    //                        }

                        if let currentActiveItem,currentActiveItem.id == item.id {
//                            let _ = print(sampleAnalytics.count)
                           
                            PointMark(
                                x: .value("Hour", item.day, unit: .day),
                                y: .value("Views", item.animate ? item.views : 0)
                            )

                            .foregroundStyle(Color("LinkBlue"))

                        }
                    }
                    else {
                        BarMark (
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )

                    
                        .foregroundStyle(currentActiveItem?.id == item.id ? Color("WhiteFontOne").gradient: Color("LinkBlue").gradient)
                        .lineStyle(.init(lineWidth: 1))

    //                    RuleMark(y: .value("Limit", 100))
    //                        .foregroundStyle(.cyan)
    //                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
    //                        .annotation(alignment: .leading) {
    //                            Text("Goal")
    //                                .background(.green)
    //                        }
                        
                        

                        if showingAve {
                            RuleMark(y: .value("average", 100))
                                .foregroundStyle(.cyan)
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                                .annotation(alignment: .leading) {
                                    Text("average")
                                        .background(.green)
                                }

                            }
                    }
                    
                }
            }
            
            .chartPlotStyle { plotContent in
              plotContent
                   
               
            }

            
            .chartXAxis {
            

                
                AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color("GrayFontOne"))
                    AxisTick(stroke: StrokeStyle())
                    
                        .foregroundStyle(Color("GrayFontOne"))
                    AxisGridLine(centered: true, stroke: StrokeStyle())
                        .foregroundStyle(Color("GrayFontOne"))
                    
                }
            }
            .chartYAxis {
              AxisMarks(values: .automatic) { value in
               
                  AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2]))
                  .foregroundStyle(Color("GrayFontOne"))

                AxisValueLabel()
                      .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                      .foregroundStyle(Color("WhiteFontOne"))
              }
            }
        



            .chartYScale(domain: 0...(max + max * 0.3))

            .chartOverlay(content: { proxy in
                GeometryReader { innerProxy in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    if let date: Date = proxy.value(atX: location.x) {
                                        let calendar = Calendar.current
                                        let hour = calendar.component(.day, from: date)
                                        if let currentItem = sampleAnalytics.first(where: { item in
                                            calendar.component(.day, from: item.day) == hour
                                        }) {
                                            self.currentActiveItem = currentItem
                                            self.plotWidth = proxy.plotAreaSize.width * 0.18
                                        }
                                    }
                                }
                                .onEnded { value in
                                    self.currentActiveItem = nil
                                }
                                .simultaneously(with: LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                                self.currentActiveItem = nil
                            })
                        )
                }


            })
            .frame(height: 250)
          
            .onAppear {
                animateGraph()
                

        }
            VStack {
                Spacer()
                HStack {
                    let formattedDate1 = format(date: sampleAnalytics.first!.day)
                   
                    let date24HoursEarlier = sampleAnalytics.last!.day.addingTimeInterval(-86400)
                    let formattedDate2 = format(date: date24HoursEarlier)
                    Text(formattedDate1)
                        .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                        .foregroundStyle(Color("WhiteFontOne"))
                    Spacer()
                    Text(formattedDate2)
                        .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (11 * 0.0025)))
                        .foregroundStyle(Color("WhiteFontOne"))
                    
                    
                }.padding(.horizontal, 20)
                    .offset(x: -getScreenBounds().width * 0.03, y: getScreenBounds().height * 0.025)
                
            }
            
        }.padding(.bottom, 15)
    }
    
    func animateGraph(fromChange: Bool = false) {
        let animationDuration = fromChange ? 0.3 : 0.5 // Ad
        if sampleAnalytics.count <= 20 {
            for (index,_) in sampleAnalytics.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                    withAnimation(fromChange ? .easeInOut(duration: 0.56) : .easeInOut(duration: 0.8)) {
                        sampleAnalytics[index].animate = true
                    }
                }
               
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    for (index, _) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].animate = true
                    }
                }
            }
        }

    }
    

}















struct MonthlyWorkoutFrequencyView: View {
    let monthlyWorkoutFrequencyData: [Int]
    
    func frequencyColor(frequency: Int) -> Color {
        if frequency == 0 {
            return Color.clear
        } else {
            let intensity = Double(frequency) / Double(monthlyWorkoutFrequencyData.max() ?? 1)
            return Color("LinkBlue").opacity(intensity)
        }
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(monthlyWorkoutFrequencyData.indices, id: \.self) { index in
                    VStack {
                        Circle()
                            .fill(frequencyColor(frequency: monthlyWorkoutFrequencyData[index]))
                            .frame(width: 20, height: 20)
                        Text("\(index + 1)")
                            .font(.caption)
                            .foregroundColor(Color("GrayFontOne"))
                        
                    }
                }
            }
            .padding()
        }
    }
}








