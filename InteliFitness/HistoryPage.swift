//
//  HistoryPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/22/23.
//
//  MyExercisesPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import Foundation
//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI


struct HistoryPage: View {
    @ObservedObject var viewModel: HomePageViewModel


    @Binding var isNavigationBarHidden: Bool
    var body: some View {
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
            Home(viewModel: viewModel, topEdge: topEdge)
                .navigationBarTitle(" ")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct Home: View {
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
                
                LazyVStack(spacing: 15) {
                    GeometryReader { proxy in
                        TopBar(topEdge: topEdge, name: "History", offset: $offset, maxHeight: maxHeight)
                            
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
                            
                        
                    }
                    .frame(height: maxHeight)
                    .offset(y: -offset)
                    .zIndex(1)
        
                  




                


                        VStack {

                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.06)
                                .foregroundColor(.clear)


                            if !viewModel.history.isEmpty {
                                ForEach(viewModel.history.reversed()) { workout in

                                    
              
                                    if !workout.exercises.isEmpty {
                                        Button {
                                            selectedWorkout = workout
                                            withAnimation(.spring()) {
                                                showingExpandedExercise.toggle()

                                            }
                                            HapticManager.instance.impact(style: .rigid)

                                        }
                                        label: {

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
//                                                                           self.showingAlert = true
                                                                    selectedWorkout = workout
                                                                    withAnimation(.spring()) {
                                                                        showingHistoryMenu.toggle()
                                                                    }
                                                                            
                                                                            HapticManager.instance.impact(style: .rigid)
                                                                       }) {
                                                                           HStack(spacing: 4) {
                                                                               Circle()
                                                                               Circle()
                                                                               Circle()
                                                                               
                                                                           }
                                                                           .scaleEffect(0.76)
                                                                           .foregroundColor(Color("BorderGray"))
                                                                           .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                                                                       }
                                                                       


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
                                                                TextHelvetica(content: "Best Set", size: 22)
                                                                    .foregroundColor(Color("WhiteFontOne"))
                                                                    .offset(x: -10)
                                                                Spacer()
                                                            }
                                                            .padding(.top, 15)
                                                            .padding(.bottom, -20)
                                                            .padding(.leading, 20)


                                                                VStack(alignment: .leading) {
                                                                    Rectangle()
                                                                        .frame(height: getScreenBounds().height * 0.006)
                                                                        .foregroundColor(.clear)
                                                                    
                                                                    ForEach(workout.exercises) {exercise in




                                                                        HStack {


                                                                            HStack {
                                                                                TextHelvetica(content: "\(exercise.setRows.count) x \(exercise.exersiseName)", size: 16)
                                                                                    .foregroundColor(Color("GrayFontOne"))
                                                                                    .lineLimit(1)

                                                                                    .padding(.leading, 10)
                                                                                Spacer()
                                                                            }.frame(width: getScreenBounds().width * 0.4)


                                                                            let rows = exercise.setRows
                                                                            if let bestRow = calculateBestSet(rows: rows) {
                                                                                
                                                                               
                                                                                HStack(spacing: 0){
                                                                                    if exercise.moduleType == WorkoutLogModel.moduleType.reps {
                                                                                        TextHelvetica(content: "\(bestRow.reps) reps", size: 16)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                            .lineLimit(1)
                                                                                        if bestRow.repMetric != 0 {
                                                                                            TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                                .lineLimit(1)
                                                                                        }
                                                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.weightedReps) {
                                                                                        TextHelvetica(content: "\(bestRow.reps) reps", size: 16)
                                                                                            .lineLimit(1)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                        if bestRow.weight != 0 {
                                                                                            TextHelvetica(content: " + \(bestRow.weight) lbs", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                                .lineLimit(1)
                                                                                        }
                                                                                        if bestRow.repMetric != 0 {
                                                                                            TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                                .lineLimit(1)
                                                                                        }
                                                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.assistedReps) {
                                                                                        TextHelvetica(content: "\(bestRow.reps) reps", size: 16)
                                                                                            .lineLimit(1)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                        if bestRow.weight != 0 {
                                                                                            TextHelvetica(content: " - \(bestRow.weight) lbs", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                                .lineLimit(1)
                                                                                        }
                                                                                        if bestRow.repMetric != 0 {
                                                                                            TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                        }
                                                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.duration) {
                                                                                        TextHelvetica(content: "\(formatTime(minutesSeconds: bestRow.reps))", size: 16)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                            .lineLimit(1)


                                                                                        
                                                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.cardio) {
                                                                                        TextHelvetica(content: "\(bestRow.weight.clean) mi in \(formatTime(minutesSeconds: bestRow.reps))", size: 16)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                            .lineLimit(1)
                                                                                        
                                                                                    } else {
                                                                                        TextHelvetica(content: "\(bestRow.weight.clean) lbs x \(bestRow.reps)", size: 16)
                                                                                            .lineLimit(1)
                                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                                        if bestRow.repMetric != 0 {
                                                                                            TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                                                                .foregroundColor(Color("GrayFontOne"))
                                                                                                .lineLimit(1)
                                                                                        }
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                }
                                                                                Spacer()
                                                                            }



                                                                        }
                                                                        Divider()
                                                                            .frame(height: borderWeight)
                                                                            .overlay(Color("BorderGray"))

                                                                    }




                                                                }

                                                                .cornerRadius(10)
                                                                .overlay(
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                                                .padding(.vertical, 20)
                                                            .padding(.horizontal, 15)



                                                        }

                                                    }

                                                    .background(Color("DBblack"))
                                                    .cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

                                                    .padding(.vertical)
                                                    .padding(.horizontal, 18)
                                        }
                                    }
                              


                                }
                            } else {
                                TextHelvetica(content: "Completed workouts will apear here", size: 18)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .padding()
                                    .padding(.top, 50)
                            }
                           

                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.2)
                                .foregroundColor(.clear)
                        }
                        
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
                            TextHelvetica(content: "calander", size: 17)
                                .foregroundColor(Color(.clear))
                                
                        }.frame(width: 100)
                       
                    }
                    
                }
                .frame(height: 60)
                .padding(.top, topEdge)
                .padding(.bottom, 20)
                .padding(.horizontal)
                .background(Color("MainGray")
                            .shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.1), radius: 10, x: 0, y: 0)
                            .edgesIgnoringSafeArea(.all)
                            .padding(.all, UIScreen.main.bounds.width * 0.005))
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
                if let workoutToUse = selectedWorkout {
                    historyMenu(showingHistoryMenu: $showingHistoryMenu, workout: workoutToUse, viewModel: viewModel)
                        .shadow(radius: 10)

                        .position(x: getScreenBounds().width/2, y: showingHistoryMenu ? getScreenBounds().height * (0.52 + offset) : getScreenBounds().height * 1.5)
                }
                
                

            }
        }
        .background(Color("DBblack"))
       
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


func calculateOneRepMax(weight: Double, reps: Int) -> Double {
    return weight + (weight * Double(reps) * 0.0333)
}


struct CalendarView: View {
    var body: some View {
        VStack {
            Text("Calendar View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Calendar", displayMode: .inline)
    }
}

struct History: View {
    
    var body: some View {
       Text("view ho")
    }
}


struct historyMenu: View {
    @Binding var showingHistoryMenu: Bool
    var workout: HomePageModel.Workout
    @ObservedObject var viewModel: HomePageViewModel
    @State private var exerciseName: String = ""
    
    @State private var hours: Int = 1
    @State private var minutes: Int = 10
    
    let hourOptions = Array(0...24)
    let minuteOptions = Array(0...59)
    
    @State private var showingAlert: Bool = false
    var body: some View {
        // Add a blur effect to the background
        VStack{


            Spacer()
            VStack {
                

                HStack {

                    
                    
                    TextHelvetica(content: "Workout Options", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.setEdits(hours: hours, Minutes: minutes, Name: exerciseName, WorkoutId: workout.id)
                        HapticManager.instance.impact(style: .rigid)
                        withAnimation(.spring()) {
                                showingHistoryMenu.toggle()
                        }

                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            Image("checkMark")
                           
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundColor(Color("LinkBlue"))
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                   
                    TextField("", text: $exerciseName, prompt: Text(workout.WorkoutName).foregroundColor(Color("GrayFontOne")))
                        .frame(width: getScreenBounds().width * 0.82)
                        .font(.custom("SpaceGrotesk-Medium", size: 18))
                       
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color("DBblack"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                     
                        .padding(.top, 25)
             
                   
//                        .onChange(of: isTextFieldFocused) { newValue in
//                            if newValue == false {
//                                // TextField has lost focus
//                                if !exerciseName.isEmpty {
//                                    viewModel.setExerciseName(exerciseID: exercise.id, newName: exerciseName)
//                                }
//
//
//                            }
                        }
                
               
                  
                    TextHelvetica(content: "Edit Workout Time:", size: 19)
                        .foregroundColor(Color("GrayFontOne"))
                        .padding(.vertical, 10)
                       
                        
                 
                 
                   
                    HStack {
                            Picker("Hours", selection: $hours) {
                                ForEach(hourOptions, id: \.self) { hour in
                                    Text("\(hour) h")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                            .clipped()
                            .labelsHidden()
                            
                            Picker("Minutes", selection: $minutes) {
                                ForEach(minuteOptions, id: \.self) { minute in
                                    Text("\(minute) m")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                            .clipped()
                            .labelsHidden()
                        }
               
                    
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        showingAlert.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("MainRed"))
                                .padding(.vertical)
                                .padding(.horizontal, 10)
                
                            


                         
                                
                         
                            
                            
                            TextHelvetica(content: "Delete Workout", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .alert(isPresented: $showingAlert) {
                                    Alert(
                                        title: Text("Delete exercise history"),
                                        message: Text("Are you sure you want to delete this workout?"),
                                        primaryButton: .destructive(Text("Delete")) {
                                            showingAlert.toggle()
                                            withAnimation(.spring()) {
                                                showingHistoryMenu.toggle()
                                            }
                                       
                                            viewModel.deleteExerciseHistory(workoutID: workout.id)
                                            viewModel.saveExersiseHistory()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                        }
                        .frame(width: getScreenBounds().width * 0.9, height: getScreenBounds().height * 0.12)
                    }
                    
                }
                .frame(width: getScreenBounds().width * 0.95)
                .background(Color("DBblack"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                .padding()
                .onChange(of: showingHistoryMenu) { newValue in
//                    print(workout.workoutTime)
                    exerciseName = workout.WorkoutName
                    hours = workout.workoutTime / 3600
                    minutes = (workout.workoutTime / 60) % 60
  
            
                    
                    
                }

            
        }
     

        .frame(height: getScreenBounds().height * 0.7)
        


            
    }
}


func calculateBestSet(rows: [WorkoutLogModel.ExersiseSetRow]) -> WorkoutLogModel.ExersiseSetRow? {
    var mostDifficultSet: WorkoutLogModel.ExersiseSetRow? = nil
    var highestDifficulty: Float = 0

    for row in rows {
        var nonZeroValues: Int = 0
        var totalValue: Float = 0

        if row.repMetric != 0 {
            totalValue += row.repMetric
            nonZeroValues += 1
        }

        if row.weight != 0 {
            totalValue += row.weight
            nonZeroValues += 1
        }

        if row.reps != 0 {
            totalValue += Float(row.reps)
            nonZeroValues += 1
        }

        if nonZeroValues == 0 {
            continue
        }

        let averageValue: Float = totalValue / Float(nonZeroValues)

        if averageValue > highestDifficulty {
            highestDifficulty = averageValue
            mostDifficultSet = row
        }
    }

    return mostDifficultSet
}


func formatTime(minutesSeconds: Int) -> String {
    let minutes = minutesSeconds / 100
    let seconds = minutesSeconds % 100
    
    let hours = minutes / 60
    let remainingMinutes = minutes % 60

    var timeString = ""

    if hours > 0 {
        timeString += "\(hours) hr "
    }
    
    if remainingMinutes > 0 {
        timeString += "\(remainingMinutes) min "
    }
    
    if seconds > 0 {
        timeString += "\(seconds) sec"
    }

    return timeString
}

struct ExpandedHistory: View {
    var workout: HomePageModel.Workout
    @ObservedObject var viewModel: HomePageViewModel

    @Binding var showingExpandedExercise: Bool
    var isforFinish = false
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    TextHelvetica(content: workout.WorkoutName, size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    TextHelvetica(content: viewModel.formatDate2(workout.competionDate), size: 17)
                        .foregroundColor(Color("GrayFontOne"))
                }
                Spacer()

                ZStack{



                    if !isforFinish {
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
                                    .foregroundColor(Color("LinkBlue"))
                            }.frame(width: 50, height: 30)
                        })
                    }

                   


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
                                            
                                       
                                            if sets.setType == "N" {
                                                TextHelvetica(content: String(sets.setIndex) + " ", size: 18)
                                                     
                                       
                                                           .foregroundColor(Color("LinkBlue"))
                                                           
                                                           
                                            } else {
                                                TextHelvetica(content: sets.setType + " ", size: 18)
                                                          
                                                           
                                                           .foregroundColor(getTextColor(string: sets.setType))
                                                         
                                                           
                                            }
                                            
                                            if exercise.moduleType == WorkoutLogModel.moduleType.reps {
                                                TextHelvetica(content: "\(sets.reps) reps", size: 16)
                                                    .foregroundColor(Color("GrayFontOne"))
                                                
                                                if sets.repMetric != 0 {
                                                    TextHelvetica(content: " @ \(sets.repMetric.clean)", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                Spacer()
                                            } else if (exercise.moduleType == WorkoutLogModel.moduleType.weightedReps) {
                                                TextHelvetica(content: "\(sets.reps) reps", size: 16)

                                                    .foregroundColor(Color("GrayFontOne"))
                                                if sets.weight != 0 {
                                                    TextHelvetica(content: " + \(sets.weight) lbs", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                if sets.repMetric != 0 {
                                                    TextHelvetica(content: " @ \(sets.repMetric.clean)", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                Spacer()
                                            } else if (exercise.moduleType == WorkoutLogModel.moduleType.assistedReps) {
                                                TextHelvetica(content: "\(sets.reps) reps", size: 16)

                                                    .foregroundColor(Color("GrayFontOne"))
                                                if sets.weight != 0 {
                                                    TextHelvetica(content: " - \(sets.weight.clean) lbs", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                if sets.repMetric != 0 {
                                                    TextHelvetica(content: " @ \(sets.repMetric.clean)", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                Spacer()
                                            } else if (exercise.moduleType == WorkoutLogModel.moduleType.duration) {
                                                TextHelvetica(content: "\(formatTime(minutesSeconds: sets.reps))", size: 16)
                                                    .foregroundColor(Color("GrayFontOne"))
                                                Spacer()

                                                
                                            } else if (exercise.moduleType == WorkoutLogModel.moduleType.cardio) {
                                                TextHelvetica(content: "\(sets.weight.clean) mi in \(formatTime(minutesSeconds: sets.reps))", size: 16)
                                                    .foregroundColor(Color("GrayFontOne"))
                                                Spacer()
                                            } else {
                                                TextHelvetica(content: "\(sets.weight.clean) lbs x \(sets.reps)", size: 16)

                                                    .foregroundColor(Color("GrayFontOne"))
                                                if sets.repMetric != 0 {
                                                    TextHelvetica(content: " @ \(sets.repMetric.clean)", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                
                                                Spacer()
                                                let RepMax = viewModel.calculateOneRepMax(weight: Double(sets.weight), reps: sets.reps)
                                                Text(RepMax.stringFormat)
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("GrayFontOne"))
                                            }
                                         

                                           

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

               
                if !workout.notes.isEmpty {
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
