//
//  Profile.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/17/23.
//

import SwiftUI


struct Profile: View {
    @ObservedObject var viewModel: HomePageViewModel
    @Binding var isNavigationBarHidden: Bool
    var body: some View {
       
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
            ProfileMain(viewModel: viewModel, topEdge: topEdge)
                .navigationBarTitle("back")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
        
    }
}

struct ProfileMain: View {
    @ObservedObject var viewModel: HomePageViewModel
    var topEdge: CGFloat
    
    let maxHeight = UIScreen.main.bounds.height / 3
    @Environment(\.presentationMode) var presentationMode
    @State var offset: CGFloat = 0
    
    @State private var search: String = ""
    @State private var showTitle = true
    @State private var rectanglePosition: CGFloat = .zero
    @State private var showingExpandedExercise: Bool = false
    @State private var showingHistoryMenu: Bool = false
    @State private var selectedWorkout: HomePageModel.Workout?
    private let scrollId = "scrollId"
    

    var body: some View {
        ZStack {
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    GeometryReader { proxy in
                        TopBar(topEdge: topEdge, name: "Profile", offset: $offset, maxHeight: maxHeight)
                            
                                .frame(maxWidth: .infinity)
                                .frame(height: getHeaderHeight(), alignment: .bottom)
                               
                                .overlay(
                                    GeometryReader { geoProxy in
                                        CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: borderWeight)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                            .clipShape(CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: 0))
                                            .frame(height: geoProxy.size.height + 100) // Increase the height by adding an arbitrary value, e.g., 10
                                            .offset(y: -100)
                                            .opacity((-1 * topBarTitleOpacityForBorder()))// Move the overlay up by the same value
                                    }
                                )
                                
                                
                        
                                

                        
                            .background(Color("MainGray"), in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius()))
                            .shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.7), radius: 10, x: 0, y: 0)
                        
                    }
                    .frame(height: maxHeight)
                    .offset(y: -offset)
                    .zIndex(1)
        
                  




                


                    VStack{
                        Text("RADAR CHART").font(.system(size: 30, weight: .semibold))
                        RadarChartView(width: 370, MainColor: Color.init(white: 0.8), SubtleColor: Color.init(white: 0.6), quantity_incrementalDividers: 4, dimensions: dimensions, data: data)
                        RadarChartView(width: 370, MainColor: Color.init(white: 0.8), SubtleColor: Color.init(white: 0.6), quantity_incrementalDividers: 4, dimensions: dimensions, data: data2)
                        FreqencyChart()
                        
                        VStack {
                            Text("Wokrouts")
                            Text("Total Volume")
                            Text("Total Reps")
                            Text("12 weeks training")
                            Text("23 sets")
                        }
                        
                     
                     
                        VStack {
                            Text("goals")
                       
                        }
                        
                        VStack {
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                            Text("bench press - 1 time")
                        }
                        
                        Spacer()
                    }.foregroundColor(.white)
                        
                    .zIndex(0)
                    
                       
                


                      



                    
                    
             
                   
                    
                }
                
                .modifier(OffsetModifier(modifierID: "SCROLL", offset: $offset))
            }
            .background(Color("DBblack"))
            .coordinateSpace(name: "SCROLL")
            
            VStack {
                HStack(spacing: 15) {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            TextHelvetica(content: "back", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                            Spacer()
                        }
                        .frame(width: 100)
                    }
                    Spacer()
                    TextHelvetica(content: "History", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                        .opacity(topBarTitleOpacity())
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Spacer()
                      
                    
                            Image(systemName: "ruler.fill")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            Image(systemName: "photo.artframe")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                  
                                
                        }.frame(width: 120)
                       
                    }
                    
                }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .padding(.top, topEdge)
                
                Spacer()
            }
           
           
      
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(showingExpandedExercise ? 1 : 0)

              
                if let workoutToUse = selectedWorkout {
                    let offset = viewModel.ongoingWorkout ? 0 : 0.07
                    ExpandedHistory(workout: workoutToUse, viewModel: viewModel, showingExpandedExercise: $showingExpandedExercise)
                        .position(x: getScreenBounds().width/2, y: showingExpandedExercise ? getScreenBounds().height * (0.47 + offset) : getScreenBounds().height * 1.5)
                }
                
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .opacity(showingHistoryMenu ? 0.4 : 0)
                
                let offset = viewModel.ongoingWorkout ? 0 : 0.12
                historyMenu(showingHistoryMenu: $showingHistoryMenu)
                    .shadow(radius: 10)

                    .position(x: getScreenBounds().width/2, y: showingHistoryMenu ? getScreenBounds().height * (0.52 + offset) : getScreenBounds().height * 1.5)
                

            }
        }
        .background(Color("DBblack"))
       
    }
    
   

    struct ExpandedHistory: View {
        var workout: HomePageModel.Workout
        @ObservedObject var viewModel: HomePageViewModel

        @Binding var showingExpandedExercise: Bool
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        TextHelvetica(content: workout.WorkoutName, size: 27)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        TextHelvetica(content: viewModel.formatDate(workout.competionDate), size: 17)
                            .foregroundColor(Color("GrayFontOne"))
                    }
                    Spacer()

                    ZStack{





                        Button(action: {
                            withAnimation(.spring()) {
                                showingExpandedExercise.toggle()
                            }
                            HapticManager.instance.impact(style: .rigid)

                        }, label: {


                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                    .foregroundColor(Color("MainGray"))
                                Image(systemName: "xmark")
                                    .bold()
                            }.frame(width: 50, height: 30)
                        })


                    }
                    .offset(y: 3)

                }

                .padding(.all, 12)
                .background(Color("MainGray"))

                Rectangle()
                    .frame(height: getScreenBounds().height * 0.006)
                    .foregroundColor(Color("MainGray"))

                HStack {
                    let workoutTimeInSeconds = workout.workoutTime  // assuming this is your integer value
                    let hours = workoutTimeInSeconds / 3600
                    let minutes = (workoutTimeInSeconds % 3600) / 60

                    let workoutTimeFormatted = hours > 0 ?  "\(hours) hr \(minutes) mins" :  "\(minutes) mins"
                    TextHelvetica(content: workoutTimeFormatted, size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    let metrics = viewModel.returnWorkoutMetrics(workout: workout)
                    let volume = metrics[0]
                    let reps = metrics[1]
                    TextHelvetica(content: Double(volume).stringFormat + " lbs", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    TextHelvetica(content: Double(reps).stringFormat + " sets", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                   

                }
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .background(Color("MainGray"))

                Divider()

                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))

                VStack {
                    HStack {
                        TextHelvetica(content: "Exercise", size: 22)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                        TextHelvetica(content: "1RM", size: 20)
                            .foregroundColor(Color("WhiteFontOne"))


                    }
                    .padding(.trailing)
                    .padding(.top, 15)
                    .padding(.bottom, -20)
                    .padding(.leading, 20)
                    .padding(.leading, 20)


                        VStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.006)
                                .foregroundColor(.clear)
                            ScrollView {
                                ForEach(workout.exercises) {exercise in


                                    VStack(spacing: 5) {
                                        HStack {
                                            TextHelvetica(content: exercise.exersiseName, size: 20)
                                                .bold()
                                                .foregroundColor(Color("WhiteFontOne"))
                                            Spacer()
                                        }.padding(.horizontal)




                                        ForEach(exercise.setRows) { sets in
                                            HStack(spacing: 0) {
                                                Text("\(sets.setIndex) ")
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("LinkBlue"))

                                                Text("\(sets.weight.clean) lbs x \(sets.reps) ")
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("GrayFontOne"))
                                                if sets.repMetric != 0 {
                                                    Text(" @ \(sets.repMetric.clean)")
                                                        .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                Spacer()
                                                let RepMax = viewModel.calculateOneRepMax(weight: Double(sets.weight), reps: sets.reps)
                                                Text(RepMax.stringFormat)
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("GrayFontOne"))

                                            }



                                        }.padding(.horizontal)
                                    }


                                    Divider()
                                        .frame(height: borderWeight)
                                        .overlay(Color("BorderGray"))

                                }
                            }





                        }

                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                        .padding(.vertical, 20)
                    .padding(.horizontal, 15)

                    HStack {
                        TextHelvetica(content: "Notes", size: 22)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                    }       .padding(.horizontal)
                    ScrollView {
                        TextHelvetica(content: workout.notes, size: 20)
                            .foregroundColor(Color("GrayFontOne"))

                    }
                    .frame(maxHeight: getScreenBounds().height * 0.1)
                    .padding(7)
                    .background(Color("DDB"))
                    
                    .cornerRadius(10)
                    .padding(.all, 15)


                }

            }

            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

            .padding(.vertical)
            .padding(.horizontal, 12)
            .frame(maxHeight: getScreenBounds().height * 0.8)
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight > (80 + topEdge) ? topHeight : (80 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        let progess = -offset / (maxHeight - (80 + topEdge))
        let value = 1 - progess
        let radius = value * 25
        
        return offset < 5 ? radius : 25
    }
    
    func topBarTitleOpacity() -> CGFloat {
        
        let progress = -(offset + 60) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }
    
    func topBarTitleOpacityForBorder() -> CGFloat {
        
        let progress = -(offset + 150) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }
}




import SwiftUI

struct Ray:Identifiable {
    var id = UUID()
    var name:String
    var maxVal:Double
    var rayCase:RayCase
    init(maxVal:Double, rayCase:RayCase) {
        self.rayCase = rayCase
        self.name = rayCase.rawValue
        self.maxVal = maxVal
        
    }
}

struct RayEntry{
    var rayCase:RayCase
    var value:Double
}

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
}

func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return 360 * (CGFloat((numerator))/CGFloat(denominator))
    
}

struct RadarChartView: View {
    
    var MainColor:Color
    var SubtleColor:Color
    var center:CGPoint
    var labelWidth:CGFloat = 70
    var width:CGFloat
    var quantity_incrementalDividers:Int
    var dimensions:[Ray]
    var data:[DataPoint]
    
    init(width: CGFloat, MainColor:Color, SubtleColor:Color, quantity_incrementalDividers:Int, dimensions:[Ray], data:[DataPoint]) {
        self.width = width
        self.center = CGPoint(x: width/2, y: width/2)
        self.MainColor = MainColor
        self.SubtleColor = SubtleColor
        self.quantity_incrementalDividers = quantity_incrementalDividers
        self.dimensions = dimensions
        self.data = data
    }
    
    @State var showLabels = false
    
    var body: some View {
        
        ZStack{
            //Main Spokes
            Path { path in
                
                
                for i in 0..<self.dimensions.count {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            //Labels
            ForEach(0..<self.dimensions.count){ i in
                
                Text(self.dimensions[i].rayCase.rawValue)
                    
                    .font(.system(size: 10))
                    .foregroundColor(self.SubtleColor)
                    .frame(width:self.labelWidth, height:10)
                    .rotationEffect(.degrees(
                        (degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) > 90 && degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) < 270) ? 180 : 0
                        ))
                    
                    
                    .background(Color.clear)
                    .offset(x: (self.width - (50))/2)
                    .rotationEffect(.radians(
                        Double(radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    )))
            }
            //Outer Border
            Path { path in
                
                for i in 0..<self.dimensions.count + 1 {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    if i == 0 {
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                    
                    
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            //Incremental Dividers
            ForEach(0..<self.quantity_incrementalDividers){j in
                Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(j + 1)/CGFloat(self.quantity_incrementalDividers + 1))
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (50 + self.labelWidth)))
                        print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                .stroke(self.SubtleColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                
                
            }
            
            //Data Polygons
            ForEach(0..<self.data.count){j -> AnyView in
                //Create the path
                let path = Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
                        let maxVal = thisDimension.maxVal
                        let dataPointVal:Double = {
                            
                            for DataPointRay in self.data[j].entrys {
                                if thisDimension.rayCase == DataPointRay.rayCase {
                                    return DataPointRay.value
                                }
                            }
                            return 0
                        }()
                        let angle = radAngle_fromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
                        
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (50 + self.labelWidth)))
                        print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                //Stroke and Fill
                return AnyView(
                    ZStack{
                        path
                            
                            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        path
                            .foregroundColor(self.data[j].color).opacity(0.2)
                    }
                )
                
                
            }
            
        }.frame(width:width, height:width)
    }
}




enum RayCase:String, CaseIterable {
    case Intelligence = "Intelligence"
    case Funny = "Funny"
    case Empathy = "Empathy"
    case Veracity = "Veracity"
    case Selflessness = "Selflessness"
    case Authenticity = "Authenticity"
    case Boldness = "Boldness"
}

let dimensions = [
    Ray(maxVal: 10, rayCase: .Empathy),
    Ray(maxVal: 10, rayCase: .Funny),
    Ray(maxVal: 10, rayCase: .Intelligence),
    Ray(maxVal: 10, rayCase: .Veracity),
    Ray(maxVal: 10, rayCase: .Selflessness),
    Ray(maxVal: 10, rayCase: .Authenticity),
    
]

struct DataPoint:Identifiable {
    var id = UUID()
    var entrys:[RayEntry]
    var color:Color
    
    init(intelligence:Double, funny:Double, empathy:Double, veracity:Double, selflessness:Double, authenticity:Double, color:Color){
        self.entrys = [
            RayEntry(rayCase: .Intelligence, value: intelligence),
            RayEntry(rayCase: .Authenticity, value: authenticity),
            RayEntry(rayCase: .Empathy, value: empathy),
            RayEntry(rayCase: .Veracity, value: veracity),
            RayEntry(rayCase: .Funny, value: funny),
            RayEntry(rayCase: .Selflessness, value: selflessness),
        ]
        self.color = color
    }
}

let data = [
    DataPoint(intelligence: 0, funny: 1, empathy: 1, veracity: 0, selflessness: 0, authenticity: 0, color: .red)
]
let data2 = [
    DataPoint(intelligence: 1, funny: 3, empathy: 7, veracity: 0, selflessness: 0, authenticity: 0, color: .blue)
]

