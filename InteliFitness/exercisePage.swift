//
//  exercisePage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/28/23.
//

import SwiftUI
import PolynomialRegressionSwift

enum Page: Int {
    case page1 = 0
    case page2
    case page3
    case page4

}



struct ExercisePage: View {
    @State private var selectedPage: Page = .page1
    @ObservedObject var viewModel: HomePageViewModel
    @Binding var showingExrcisePage: Bool
    @State var exerciseName = ""
    var ignoringOffset: Bool = false
    


    private var customBinding: Binding<Page> {
        Binding<Page>(
            get: { selectedPage },
            set: { selectedPage = $0 }
        )
    }
    
    var offset: CGFloat {
        if ignoringOffset {
            return 0.13
        } else {
           
            return viewModel.ongoingWorkout ? 0 : 0.13
        }
    }

    var body: some View {

        if let exercise = viewModel.homePageModel.currentExervice {
            VStack {
                HStack {
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        withAnimation(.spring()) {
                            showingExrcisePage = false
                        }
                        viewModel.setExerciseName(exerciseID: exercise.id, newName: exerciseName)
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            Image(systemName: "xmark")
                                .bold()
                                .foregroundColor(Color("LinkBlue"))
                        }
                    }.frame(width: 50, height: 30)
                    
                    Spacer()
                    TextHelvetica(content: exerciseName, size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    Button {
                        selectedPage = .page4
                    }
                    label: {
                        TextHelvetica(content: "Edit", size: 18)
                            .foregroundColor(Color("LinkBlue"))
                    }
                }
                .onChange(of: showingExrcisePage) { newValue in
                    if newValue == true {
                        print(exercise.id)
                        exerciseName = exercise.exerciseName
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            if exercise.exerciseHistory.count > 1 {
                                if let volume = viewModel.getVolumeData(exerciseHistory: exercise.exerciseHistory) {
                                    if let heaviestWeight = viewModel.getHeaviestWeightPerDay(exerciseHistory: exercise.exerciseHistory) {
                                        if let Projected1RM = viewModel.getProjected1RM(exerciseHistory: exercise.exerciseHistory) {
                                            if let BestSetVolume = viewModel.getBestVolumeSet(exerciseHistory: exercise.exerciseHistory) {
                                                if let totalReps = viewModel.getTotalReps(exerciseHistory: exercise.exerciseHistory) {
                                                    if let WeightPerRep = viewModel.getWeightPerRep(exerciseHistory: exercise.exerciseHistory) {

                                                        viewModel.setExerciseChartData(volume: volume, heaviestWeight: heaviestWeight, Projected1RM: Projected1RM, BestSetVolume: BestSetVolume, TotalReps: totalReps, WeightPerRep: WeightPerRep, exercise: exercise)
                                                       
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    let _ = print("could not set volume")
                                }
                            }
                        }
                        
                    } else {
                        selectedPage = .page1
                        viewModel.clearData()
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                if exercise.instructions.count > 0 {
                    // del
                    CustomSegmentedPicker(selection: customBinding, labels: ["About", "History", "Data"])
                        .padding()
                } else {
                    CustomSegmentedPicker(selection: customBinding, labels: ["History", "Data"])
                        .padding()
                }
               

                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                if exercise.instructions.count > 0 {
                    
                    switch selectedPage {
                    case .page1:
                        Page1View(exercise: exercise)
                    case .page2:
                        Page2View(exercise: exercise, viewModel: viewModel)
                    case .page3:
                        Page3View(exercise: exercise, viewModel: viewModel)
                    
                    case .page4:
                        Page4View(exercise: exercise, viewModel: viewModel, exerciseName: $exerciseName, showingExrcisePage: $showingExrcisePage)
                    }
                

                }
                else {
                    switch selectedPage {
                    case .page1:
                        Page2View(exercise: exercise, viewModel: viewModel)
                    case .page2:
                        Page3View(exercise: exercise, viewModel: viewModel)
                    case .page3:
                        Page4View(exercise: exercise, viewModel: viewModel, exerciseName: $exerciseName, showingExrcisePage: $showingExrcisePage)
                    case .page4:
                        Page4View(exercise: exercise, viewModel: viewModel, exerciseName: $exerciseName, showingExrcisePage: $showingExrcisePage)
                            // deleted
                    }
                    
                }
              
                Spacer()
              
            }

            .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * (0.7 + offset))
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .offset(y: getScreenBounds().height * (offset/5))
        }
    }
}
struct CustomSegmentedPickerChart: View {
    @Binding var selection: chartTab
    var labels: [String]
    private let slidingBarHeight: CGFloat = 2

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<labels.count) { index in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selection = chartTab(rawValue: index)!
                        }
                        HapticManager.instance.impact(style: .rigid)
                    }) {
                        TextHelvetica(content: labels[index], size: 13)
                            .padding(.horizontal, 1)
                            .padding(.vertical, 5)
                            
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selection == chartTab(rawValue: index) ? Color("LinkBlue") : Color("WhiteFontOne"))
                    }
                }
            }
            .background(Color("MainGray"))

            // Sliding bar
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: slidingBarHeight / 2)
                    .frame(width: geometry.size.width / CGFloat(labels.count), height: slidingBarHeight)
                    .foregroundColor(Color("LinkBlue"))
                    .offset(x: (geometry.size.width / CGFloat(labels.count)) * CGFloat(selection.rawValue))
                    .animation(.easeInOut, value: selection)
            }
            .frame(height: slidingBarHeight)
        }
        .frame(width: getScreenBounds().width * 0.45)
        .background(Color("MainGray"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
       
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selection: Page
    var labels: [String]
    private let slidingBarHeight: CGFloat = 2

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<labels.count) { index in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selection = Page(rawValue: index)!
                        }
                        HapticManager.instance.impact(style: .rigid)
                    }) {
                        TextHelvetica(content: labels[index], size: 15)
                       
                            .padding(.vertical, 5)
                            
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selection == Page(rawValue: index) ? Color("LinkBlue") : Color("WhiteFontOne"))
                    }
                }
            }
            .background(Color("MainGray"))

            // Sliding bar
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: slidingBarHeight / 2)
                    .frame(width: geometry.size.width / CGFloat(labels.count), height: slidingBarHeight)
                    .foregroundColor(Color("LinkBlue"))
                    .offset(x: (geometry.size.width / CGFloat(labels.count)) * CGFloat(selection.rawValue))
                    .animation(.easeInOut, value: selection)
            }
            .frame(height: slidingBarHeight)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}








struct Page1View: View {
    var exercise: HomePageModel.Exersise
    var body: some View {
        HStack {
            TextHelvetica(content: "Instructions", size: 25)
                .foregroundColor(Color("WhiteFontOne"))
            Spacer()
        }
        .padding(.horizontal)
        
        VStack(alignment: .leading) {
            ForEach(exercise.instructions.indices, id: \.self) { index in
                TextHelvetica( content: "\(index + 1). \(exercise.instructions[index])", size: 15)
                    .foregroundColor(Color("GrayFontOne"))
                    
            }
            .padding(.all, 10)
     
       
        }
       
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .frame(width: getScreenBounds().width * 0.89)
    }
}

struct Page2View: View {
    var exercise: HomePageModel.Exersise
    @ObservedObject var viewModel: HomePageViewModel
    var body: some View {
     
        ScrollView {

            
            LazyVStack {
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.06)
                    .foregroundColor(.clear)
                
            
                if exercise.exerciseHistory.count > 0 {
                    
                } else {
                    TextHelvetica(content: "Exercise history will apear here", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                }
                ForEach(exercise.exerciseHistory.reversed()) { workout in
                 
                        
                        
                        
                        
                        
                        VStack(spacing: 0) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    
                                    TextHelvetica(content: viewModel.formatDate(workout.DateCompleted!) , size: 27)
                                        .foregroundColor(Color("WhiteFontOne"))
                                    
                                }
                                Spacer()
                
                                
                            }
                          
                            .padding(.all, 12)
                            .background(Color("MainGray"))
                            
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.006)
                                .foregroundColor(Color("MainGray"))
                            

                            
                            Divider()
                                
                                .frame(height: borderWeight)
                                .overlay(Color("BorderGray"))
                            
                            VStack {
                                HStack {
                                    TextHelvetica(content: "Sets", size: 24)
                                        .foregroundColor(Color("WhiteFontOne"))
                                   
                                    Spacer()
                                    if exercise.moduleType == WorkoutLogModel.moduleType.reps {
                                        
                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.weightedReps) {
//                                        TextHelvetica(content: "1 RM", size: 20)
//                                            .foregroundColor(Color("WhiteFontOne"))
                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.assistedReps) {
//                                        TextHelvetica(content: "1 RM", size: 20)
//                                            .foregroundColor(Color("WhiteFontOne"))
                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.duration) {
                                        
                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.cardio) {
                                        
                                    } else {
                                        TextHelvetica(content: "1 RM", size: 20)
                                            .foregroundColor(Color("WhiteFontOne"))
                                    }

                                
                                }
                                .padding(.top, 15)
                                .padding(.bottom, -20)
                                .padding(.horizontal, 20)
                                
                                
                                    VStack(alignment: .leading) {
                                        
                                        Rectangle()
                                            .frame(height: 10)
                                            .foregroundColor(.clear)
                                        ForEach(workout.setRows) { row in
                                            VStack {
                                                
                                                HStack(spacing: 0){
                                                    
                                                    if row.setType == "N" {
                                                        TextHelvetica(content: String(row.setIndex) + " - ", size: 18)
                                                             
                                               
                                                                   .foregroundColor(Color("LinkBlue"))
                                                                   
                                                                   
                                                    } else {
                                                        TextHelvetica(content: row.setType + " - ", size: 18)
                                                                  
                                                                   
                                                                   .foregroundColor(getTextColor(string: row.setType))
                                                                 
                                                                   
                                                    }
                                                  
                                                    if exercise.moduleType == WorkoutLogModel.moduleType.reps {
                                                        TextHelvetica(content: "\(row.reps) reps", size: 18)
                                                            .foregroundColor(Color("GrayFontOne"))
                                                        
                                                        if row.repMetric != 0 {
                                                            TextHelvetica(content: " @ \(row.repMetric.clean)", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        Spacer()
                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.weightedReps) {
                                                        TextHelvetica(content: "\(row.reps) reps", size: 18)

                                                            .foregroundColor(Color("GrayFontOne"))
                                                        if row.weight != 0 {
                                                            TextHelvetica(content: " + \(row.weight.clean) lbs", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        if row.repMetric != 0 {
                                                            TextHelvetica(content: " @ \(row.repMetric.clean)", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        Spacer()
                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.assistedReps) {
                                                        TextHelvetica(content: "\(row.reps) reps", size: 18)

                                                            .foregroundColor(Color("GrayFontOne"))
                                                        if row.weight != 0 {
                                                            TextHelvetica(content: " - \(row.weight.clean) lbs", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        if row.repMetric != 0 {
                                                            TextHelvetica(content: " @ \(row.repMetric.clean)", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        Spacer()
                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.duration) {
                                                        TextHelvetica(content: "\(formatTime(minutesSeconds: row.reps))", size: 18)
                                                            .foregroundColor(Color("GrayFontOne"))

                                                        Spacer()
                                                        
                                                    } else if (exercise.moduleType == WorkoutLogModel.moduleType.cardio) {
                                                        TextHelvetica(content: "\(row.weight.clean) mi in \(formatTime(minutesSeconds: row.reps))", size: 18)
                                                            .foregroundColor(Color("GrayFontOne"))
                                                        Spacer()
                                                    } else {
                                                        TextHelvetica(content: "\(row.weight.clean) lbs x \(row.reps)", size: 18)

                                                            .foregroundColor(Color("GrayFontOne"))
                                                        if row.repMetric != 0 {
                                                            TextHelvetica(content: " @ \(row.repMetric.clean)", size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        
                                                        Spacer()
                                                        let RepMax = viewModel.calculateOneRepMax(weight: Double(row.weight), reps: row.reps)
                                                        Text(RepMax.stringFormat)
                                                            .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                            .foregroundColor(Color("GrayFontOne"))
                                                    }

                                                 
                                                    
                                                }.padding(.horizontal)
                                           
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
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.2)
                    .foregroundColor(.clear)
            }
        }
        
    }
}

struct Page3View: View {
    var exercise: HomePageModel.Exersise
    @ObservedObject var viewModel: HomePageViewModel


    var body: some View {
        ScrollView {
            let _ = print(exercise.moduleType)
            if exercise.moduleType == WorkoutLogModel.moduleType.weightReps {
                if viewModel.chartData.volume.count > 0 {
                VStack {
                    Graph(sampleAnalytics: viewModel.chartData.heaviestWeight, currentTab: "7 Days", isLine: true, currentChart: .heaviestSet)
                    // volume - bar x
                    Graph(sampleAnalytics: viewModel.chartData.volume, currentTab: "7 Days", isLine: false, currentChart: .volume)
                    
                    // predicted one rep max - line x
                    
                    
                    PolynomialRegressionGraph(sampleAnalytics: viewModel.chartData.Projected1RM, lineOfBestFitDataFormatted: viewModel.GetBestFitLine(data: viewModel.chartData.Projected1RM, exercise: exercise))
                    
                    // best set - line x
                    
                    Graph(sampleAnalytics: viewModel.chartData.bestSetVolume, currentTab: "7 Days", isLine: true, currentChart: .bestSetVolume)
                    
                    // total reps - bar x
                    
                    Graph(sampleAnalytics: viewModel.chartData.TotalReps, currentTab: "7 Days", isLine: true, currentChart: .totalReps)
                    
                    
                    // weight/rep - bar
                    
                    Graph(sampleAnalytics: viewModel.chartData.WeightPerRep, currentTab: "7 Days", isLine: true, currentChart: .wightperRep)
                    
                    // freq chart
                    VStack {
                        HStack {
                            TextHelvetica(content: "Workout Freqency", size: 22)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                            Spacer()
                        }
                        MonthlyWorkoutFrequencyView(monthlyWorkoutFrequencyData: viewModel.getWorkoutFrequency(exerciseHistory: exercise.exerciseHistory))
                    }
                    .padding()
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                    .padding()
                }
                
            } else {
                
                VStack {
                    Spacer()
                    TextHelvetica(content: "Data will apear heer when you have two days of this workout logged", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                        .offset(y: getScreenBounds().height * 0.04)
                        .padding()
                    
                    
                    
                }
            }
            
            } else {
                VStack {
                    TextHelvetica(content: "charts only support regular exercises", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                        .padding()
                        .multilineTextAlignment(.center)
                    VStack {
                        HStack {
                            TextHelvetica(content: "Workout Freqency", size: 22)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                            Spacer()
                        }
                        MonthlyWorkoutFrequencyView(monthlyWorkoutFrequencyData: viewModel.getWorkoutFrequency(exerciseHistory: exercise.exerciseHistory))
                    }
                    .padding()
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                    .padding()
                }
                
            }
           
        }
        
    }
}

struct Page4View: View {
    
    var exercise: HomePageModel.Exersise
    @ObservedObject var viewModel: HomePageViewModel
    @State var exercisePlaceholder = ""
    @FocusState private var isTextFieldFocused: Bool
    @Binding var exerciseName: String
    @Binding var showingExrcisePage: Bool
    var body: some View {
        VStack {
           
            TextField("", text: $exerciseName, prompt: Text(exercisePlaceholder).foregroundColor(Color("GrayFontOne")))
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
                .padding(.bottom, 100)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { newValue in
                    if newValue == false {
                        // TextField has lost focus
                        if !exerciseName.isEmpty {
                            viewModel.setExerciseName(exerciseID: exercise.id, newName: exerciseName)
                        }
                        
                        
                    }
                }
            
            
            Button {
           
                viewModel.deleteExercise(exerciseID: exercise.id)
                withAnimation(.spring()) {
                    showingExrcisePage = false
                }
   
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color("MainRed"))
                        .padding(.vertical)
                        .padding(.horizontal, 10)
        
                    


                 
                        
                 
                    
                    
                    TextHelvetica(content: "Delete Exercise", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame(width: getScreenBounds().width * 0.9, height: getScreenBounds().height * 0.1)
            }
            
        }

        
    }
}



