//
//  MyWorkoutsPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/29/23.
//

import SwiftUI




struct MyWorkoutsPage: View {
    @ObservedObject var viewModel: HomePageViewModel
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel


    @Binding var isNavigationBarHidden: Bool
    var isForAddingToSchedule: Bool
    var body: some View {
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
            MyWorkoutsPageMain(viewModel: viewModel, workoutLogViewModel: workoutLogViewModel, topEdge: topEdge, isForAddingToSchedule: isForAddingToSchedule, isNavigationBarHidden: $isNavigationBarHidden)
                .navigationBarTitle("back")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct MyWorkoutsPageMain: View {
    
    @ObservedObject var viewModel: HomePageViewModel

    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    
    var topEdge: CGFloat
    
    var isForAddingToSchedule : Bool
    @Binding var isNavigationBarHidden: Bool
    let maxHeight = UIScreen.main.bounds.height / 3
    @Environment(\.presentationMode) var presentationMode
    @State var offset: CGFloat = 0
    
    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 37),
            GridItem(.flexible(), spacing: 30)
        ]
    }
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {
                        GeometryReader { proxy in
                            TopBar(topEdge: topEdge, name: isForAddingToSchedule ? "Add Workout" : "My Workouts", offset: $offset, maxHeight: maxHeight)
                                
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
                        
                        
                        Spacer()
                        if !isForAddingToSchedule {
                            
                            VStack(spacing: 0) {
                                HStack {
                                    TextHelvetica(content: "Quick Start", size: 23).foregroundColor(Color("WhiteFontOne"))
                                    Spacer()
                                }
                                
                                .padding(.vertical, 3)
                                
                                ZStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(Color("BlueOverlay"))
                                            .padding(.vertical)
                                        
                                            .aspectRatio(5.5/1, contentMode: .fill)
                                    }
                                    
                                    Button {
                                        viewModel.setOngoingState(state: false)
                                        workoutLogViewModel.resetWorkoutModel()
                                        
                                        withAnimation(.spring()) {
                                            viewModel.setOngoingState(state: true)
                                            viewModel.setWorkoutLogModuleStatus(state: true)
                                            
                                        }
                                        
                                        
                                    }
                                label: {
                                    ZStack{
                                        ZStack{
                                            
                                            
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                                            
                                                .padding(.vertical)
                                            
                                                .aspectRatio(5.5/1, contentMode: .fill)
                                            
                                        }
                                        
                                        
                                        TextHelvetica(content: "Start Blank Workout", size: 20)
                                            .foregroundColor(Color("WhiteFontOne"))
                                    }
                                }
                                    
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        VStack(alignment: .leading, spacing: 20) {

                            

                            
                            
                            Section(header:
                                        
                                        HStack {
                                
                                TextHelvetica(content: "My Workouts", size: 28).bold().foregroundColor(Color("WhiteFontOne"))
                                Spacer()
                                NavigationLink(destination: createWorkout(homePageVeiwModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden)) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                            .foregroundColor(Color("MainGray"))
                                        
                                        Image(systemName: "plus")
                                            .resizable()
                                            .bold()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 17, height: 17)
                                            .foregroundColor(Color("LinkBlue"))
                                        
                                        
                                    }.frame(width: 35, height: 35)
                                        
                                    
                                }
                            }) {
                                if viewModel.myWorkouts.count > 0 {
                                    ScrollView {
                                        LazyVGrid(columns: columns, spacing: -20) {
                                            ForEach(viewModel.myWorkouts.reversed()) { workout in
                                                NavigationLink(destination: workoutLauncher(viewModel: viewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, workout: workout, isForAddingToSchedule: isForAddingToSchedule)) {
                                                    WorkoutModule(title: workout.WorkoutName, description: "Module Description")
                                                    
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                } else {
                                    TextHelvetica(content: "Created workouts will apear here", size: 22)
                                        .foregroundColor(Color("GrayFontOne"))
                                }
                                
                            }
                            HStack {
                                TextHelvetica(content: "Templates", size: 28).bold().foregroundColor(Color("WhiteFontOne"))
                                Spacer()
                            }
                            workoutSection(title: "Back Workout")
                            workoutSection(title: "Chest Workout")
                            workoutSection(title: "Leg Workout")
                            
                            
                            Spacer()
                        }
                        
                        .padding(.horizontal)
                        
                    }
                    .modifier(OffsetModifier(modifierID: "SSSCROLL", offset: $offset))
                
                    
                    
                    
                    
                }
                .background(Color("DBblack")).ignoresSafeArea()
                .coordinateSpace(name: "SSSCROLL")
                
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
                            }.frame(width: getScreenBounds().width * 0.18)
                            
                        }
                        Spacer()
                        TextHelvetica(content: isForAddingToSchedule ? "Add Workout" : "My Workouts", size: 20)
                            .foregroundColor(Color("WhiteFontOne"))
                            .bold()
                            .opacity(topBarTitleOpacity())
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack {
                                Spacer()
                                TextHelvetica(content: "calander", size: 17)
                                    .foregroundColor(.clear)
                                    
                            }.frame(width: getScreenBounds().width * 0.18)
                        }
                        
                    }
                        .padding(.horizontal)
                        .frame(height: 60)
                        .padding(.top, topEdge)
                    
                    Spacer()
                }
                
            }
        }
    
        
        
        
    }
    
    
    func workoutSection(title: String) -> some View {
        Section(header: TextHelvetica(content: title, size: 20).foregroundColor(Color("WhiteFontOne"))) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { _ in
                        
                        
                        
                        //                        NavigationLink(destination: workoutLauncher()) {
                        WorkoutModule(title: "Module Title", description: "Module Description")
                        
                        //                        }
                        
                        
                        
                    }
                }
            }
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

struct WorkoutModule: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                TextHelvetica(content: title, size: 17)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                ZStack{
                    
                    Image("meatBalls")
                        .resizable()
                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)

                }
            }.padding(.all, 10)
                
                .background(Color("MainGray"))
       
            
            
            Divider()
                                
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.000)
                TextHelvetica(content: "back squat(barbell), bench press(barbell), etc.", size: 12)
                    .foregroundColor(Color("GrayFontOne"))
                    .multilineTextAlignment(.leading)
              
                Spacer()
                
                HStack{
                    TextHelvetica(content: "12 sets", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.medium)
                        .bold()
                    TextHelvetica(content: "1:30", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                     
                }
            }.padding(.horizontal, 10)
               
            
            Spacer()

        }
        .frame(width: getScreenBounds().width * 0.443, height: getScreenBounds().height * 0.15)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding(.vertical)
        .padding(.horizontal, 2)
        
    }
}

struct workoutLauncher: View {
    @ObservedObject var viewModel: HomePageViewModel
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @Binding var isNavigationBarHidden: Bool
    var workout: HomePageModel.Workout
    var isForAddingToSchedule: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var isLinkActive = false
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 150)
                    .foregroundColor(.clear)
                VStack {
                    
                  
                    HStack {
                        TextHelvetica(content: workout.WorkoutName, size: 30)
                            .bold()
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                        Button {
                            
                        }
                        label: {
                            TextHelvetica(content: "edit", size: 18)
                        }
                    }
                    
                    HStack {
                        TextHelvetica(content: "lower Body", size: 24)
                 
                            .foregroundColor(Color("GrayFontOne"))
                        
                        Spacer()
                    }
                    
                    Spacer ()
                    
                
           
                    ZStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("BlueOverlay"))
                                .padding(.vertical)
                               
                                .aspectRatio(5.5/1, contentMode: .fill)
                        }
                        
                        if isForAddingToSchedule {
                            Button(action: {
                                viewModel.addToWorkoutQueue(workout: workout)
                                viewModel.showingExercises = false
                            }) {
                                ZStack {
//                                    NavigationLink("", destination: WeeklyScheduleView(schedule: viewModel, viewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingWorkout: true), isActive: $isLinkActive)
//                                        .opacity(0) // Hide the NavigationLink

                                    ZStack{
                                        ZStack{
                                            

                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

                                                .padding(.vertical)
                                                
                                                .aspectRatio(5.5/1, contentMode: .fill)
                                            
                                        }

                                       
                                        TextHelvetica(content: isForAddingToSchedule ? "Add Workout to Schedule" : "Start Workout", size: 20)
                                            .foregroundColor(Color("WhiteFontOne"))
                                    }
                                }
                            }
                          
                     
                              
                          
                        } else {
                            Button {
                                
                                    
                                   
                                    
                        
                                viewModel.setOngoingState(state: false)
                                workoutLogViewModel.loadWorkout(workout: workout)
                                
                                withAnimation(.spring()) {
                                    viewModel.setOngoingState(state: true)
                                    viewModel.setWorkoutLogModuleStatus(state: true)
                           
                                }
                                
                                
                                
                            }
                            label: {
                                ZStack{
                                    ZStack{
                                        

                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

                                            .padding(.vertical)
                                            
                                            .aspectRatio(5.5/1, contentMode: .fill)
                                        
                                    }

                                   
                                    TextHelvetica(content: isForAddingToSchedule ? "Add Workout to Schedule" : "Start Workout", size: 20)
                                        .foregroundColor(Color("WhiteFontOne"))
                                }
                            }
                        }
                       
                        
                    }
                   
                    
                }
               
                .padding(.all)
                .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.18)
                .background(Color("DBblack"))
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                .padding(.vertical)
                .padding(.horizontal, 2)
               
                if workout.exercises.count > 0 {
                    VStack(spacing: 0) {
                        HStack {
                            TextHelvetica(content: "Workout Summary", size: 25)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                            
                        }
                        
                        .padding(.all)
                        .background(Color("MainGray"))
                        Divider()
                        
                            .frame(height: borderWeight)
                            .overlay(Color("BorderGray"))
                        
                        Spacer()
                        ScrollView {
                            
                            ForEach(workout.exercises) { exercise in
                                HStack {
                                    
                                    TextHelvetica(content: exercise.exersiseName, size: 20)
                                        .foregroundColor(Color("GrayFontOne"))
                                    
                                    Spacer()
                                    
                                    
                                    
                                    
                                    
                                    TextHelvetica(content: "\(exercise.setRows.count) sets", size: 20)
                                        .foregroundColor(Color("GrayFontOne"))
                                    
                                    
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                
                            }
                            
                        }
                        
                        
                        
                        Spacer()
                        
                    }
                    .scaledToFit()
                    .frame(width: getScreenBounds().width * 0.95)
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                    .padding(.vertical)
                    .padding(.horizontal, 2)
                    
                }
                Spacer()
                
            }

            .background(Color("DBblack"))
            
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.51)
                 
                    .foregroundColor(Color("MainGray"))
                    .shadow(radius: 10)
               
             
            }.position(x: getScreenBounds().width/2, y: getScreenBounds().height * -0.12)
                .shadow(radius: 10)
            
            VStack {
                HStack(spacing: 15) {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            TextHelvetica(content: "back", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                            Spacer()
                        }
                        .frame(width: getScreenBounds().width * 0.17)
                    }
                    Spacer()
               
                    TextHelvetica(content: isForAddingToSchedule ? "Add Workout" : "Start Workout", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                  
                    Spacer()
                    Button {
                        
                    } label: {
                        Button {
                                              
                                
                               
                                 
                              }
                          label: {
                              
                              ZStack{
                               

                                     
                                
                               
                                 
                                 Button {
             
                                    
                                  
                                    
                                 }
                             label: {
                                 TextHelvetica(content: "Create", size: 19)
                                     .foregroundColor(.clear)
                             }
                                 
                             
                                 
                                 
                             }
                             .frame(width: getScreenBounds().width * 0.17 ,height: getScreenBounds().height * 0.048)
                              
                  
                             .aspectRatio(2.5, contentMode: .fit)
                          }
                       
                    }
                    
                }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .padding(.top, getScreenBounds().height * 0.06)
                
                Spacer()
            }
            
        }
        .offset(y: viewModel.showingExercises ? -1 * getScreenBounds().height * 0.05: 0)

       
        .navigationBarTitle("back")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
        .ignoresSafeArea(.all, edges: .top)
        
        
      
    }
    
}



