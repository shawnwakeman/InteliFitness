//
//  Charts.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/13/23.
//

import SwiftUI

import Charts

import PolynomialRegressionSwift


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
                HStack {
                    Text("Views")
                        .onTapGesture {
                            showingAve.toggle()
                        }
                    
                    CustomSegmentedPickerChart(selection: customBinding, labels: ["3 Months", "1 Year", "All Time"])
                }
                
                let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                    item.views + partialResult
                }
                if let item = currentActiveItem {
                    Text(item.views.stringFormat)
                    
                } else {
                    Text(totalValue.stringFormat)
                }
              
                
                AnimatedChart()

            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            )

            
            
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle("cume")
        .onChange(of: currentTab) { newValue in
      
            if newValue != "7 Days" {
                for (index,_) in sampleAnalytics.enumerated() {
                    sampleAnalytics[index].views = .random(in: 1500...10000)
                }
            }
            
            animatePlot(fromChange: true)
        }
            
            

            
          
       
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        
        let curColor = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
              
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
  
            Chart {
                ForEach(sampleAnalytics) { item in
                    


                    PointMark(
                        x: .value("Hour", item.day, unit: .day),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .symbol() {
                        Circle()
                            .stroke(Color.red, lineWidth: 2.5)
                            .frame(width: 10, height: 10)
                    }
                    .symbolSize(30)

                   

                    RuleMark(y: .value("Limit", 200))
                        .foregroundStyle(.cyan)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .background(.green)
                        }

                    if let currentActiveItem,currentActiveItem.id == item.id {
                        RuleMark(x: .value("Hour", currentActiveItem.day))
                            .lineStyle(.init(lineWidth: 2))
                            .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2)
                            .foregroundStyle(.red)

                        PointMark(
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )

                        .foregroundStyle(.red)



                    }
                }
            
                ForEach(lineOfBestFitDataFormatted) { item in

                        LineMark (
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("New View", item.animate ? item.views : 0)

                        )
                   
                        .foregroundStyle(.red)
                       
                        
                       
                        



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
                                            self.plotWidth = proxy.plotAreaSize.width - 440
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

           
        


    }
    
    func animatePlot(fromChange: Bool = false) {
        let animationDuration = fromChange ? 0.3 : 0.5 // Ad
        
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

enum chartType: Int {
    case volume = 0
    case heaviestSet
    case page3

}


struct Graph: View {
    @State var sampleAnalytics: [SiteView]
    @State var currentTab: String
    @State var currentActiveItem: SiteView?
    @State var plotWidth: CGFloat = 0
    @State var showingAve: Bool = false
    @State var isLine: Bool
    
    @State var selectedTab: chartTab = .page1
    
    var currentChart: chartType = .heaviestSet
    

    
    private var customBinding: Binding<chartTab> {
        Binding<chartTab>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )
    }
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        switch currentChart {
                        case .volume:
                            TextHelvetica(content: "Volume", size: 20)
                                .bold()
                            
                             .onTapGesture {
                                 showingAve.toggle()
                             }
                        case .heaviestSet:
                            TextHelvetica(content: "Heaviest Weight", size: 20)
                                .bold()
                            
                             .onTapGesture {
                                 showingAve.toggle()
                             }
                        case .page3:
                            TextHelvetica(content: "Volume", size: 20)
                                .bold()
                            
                             .onTapGesture {
                                 showingAve.toggle()
                             }
                        }
                       
          
                            
                        Spacer()
                        CustomSegmentedPickerChart(selection: customBinding, labels: ["3 Months", "1 Year", "All Time"])
                    }
                    
                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
                        item.views + partialResult
                    }
                    if let item = currentActiveItem {
                        Text(item.views.stringFormat)
                        
                    } else {
                        Text(totalValue.stringFormat)
                    }
                  
                    
                    AnimatedChart()
  
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                )

                
                
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("cume")
            .onChange(of: currentTab) { newValue in
     
                if newValue != "7 Days" {
                    for (index,_) in sampleAnalytics.enumerated() {
                        sampleAnalytics[index].views = .random(in: 1500...10000)
                    }
                }
                
                animateGraph(fromChange: true)
            }
            

            
          
        }
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        
        let curColor = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
              
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
                    .foregroundStyle(Color(.blue).gradient)

                    
                    PointMark(
                        x: .value("Hour", item.day, unit: .day),
                        y: .value("Views", item.animate ? item.views : 0)
                    )

                    .foregroundStyle(.white)

                    RuleMark(y: .value("Limit", 200))
                        .foregroundStyle(.cyan)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .background(.green)
                        }

                    if let currentActiveItem,currentActiveItem.id == item.id {
                        RuleMark(x: .value("Hour", currentActiveItem.day))
                            .lineStyle(.init(lineWidth: 2))
                            .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2)
                            .foregroundStyle(.red)

                        PointMark(
                            x: .value("Hour", item.day, unit: .day),
                            y: .value("Views", item.animate ? item.views : 0)
                        )

                        .foregroundStyle(.red)



                    }
                }
                else {
                    BarMark (
                        x: .value("Hour", item.day, unit: .day),
                        y: .value("Views", item.animate ? item.views : 0)
                    )

                
                    .foregroundStyle(currentActiveItem?.id == item.id ? Color(.blue).gradient: Color(.red).gradient)
                    .lineStyle(.init(lineWidth: 1))

                    RuleMark(y: .value("Limit", 100))
                        .foregroundStyle(.cyan)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .background(.green)
                        }

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
                                        self.plotWidth = proxy.plotAreaSize.width - 440
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











struct FreqencyChart: View {
    let eventFrequency: [Int] = [4, 7, 3, 12, 8, 5, 10, 2, 1, 3, 9, 6, 4, 5, 7, 8, 2, 1, 10, 4, 6, 8, 4, 3, 7, 5, 10, 3, 9, 2]

    func frequencyColor(frequency: Int) -> Color {
        if frequency == 0 {
            return Color.clear
        } else {
            let intensity = Double(frequency) / Double(eventFrequency.max() ?? 1)
            return Color.red.opacity(intensity)
        }
    }

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(eventFrequency.indices, id: \.self) { index in
                    VStack {
                        Text("\(index + 1)")
                            .font(.caption)
                        Circle()
                            .fill(frequencyColor(frequency: eventFrequency[index]))
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding()
            Text("Calendar View with Event Frequency")
                .font(.title)
        }
    }
}












