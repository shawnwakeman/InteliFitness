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
    
   


    
    init(viewModel: HomePageViewModel, workoutLogViewModel: WorkoutLogViewModel) {
        
        
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().barTintColor = UIColor(Color("MainGray"))
           
        // Set font color for NavigationBarTitle with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "SpaceGrotesk-Bold", size: 20)!,
            .foregroundColor: UIColor(Color("WhiteFontOne"))
        ]

        // Set font color for NavigationBarTitle with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "SpaceGrotesk-Bold", size: 40)!,
            .foregroundColor: UIColor(Color("WhiteFontOne")) // Replace UIColor.red with your desired color
        ]
       
        
        self.viewModel = viewModel
        self.workoutLogViewModel = workoutLogViewModel
  

 
       
    }
    

    
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
               
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("")
                        
                        
                            .navigationBarTitle(Text("Exercises").font(.subheadline), displayMode: .inline)
                            .navigationBarHidden(false)
                            
                        Spacer()
                        VStack(spacing: 0) {
                            HStack {
                                TextHelvetica(content: "Quick Start", size: 23).bold().foregroundColor(Color("WhiteFontOne"))
                                Spacer()
                            }
         
                            .padding(.vertical, -20)
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
                        }
                      
                        
                        Section(header:
                                    
                                    HStack {
                            
                                        TextHelvetica(content: "My Workouts", size: 28).bold().foregroundColor(Color("LinkBlue"))
                            Spacer()
                            NavigationLink(destination: createWorkout(homePageVeiwModel: viewModel)) {
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
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.myWorkouts.reversed()) { workout in
                                       
                                            
                                           
                                            NavigationLink(destination:  workoutLauncher(viewModel: viewModel, workoutLogViewModel: workoutLogViewModel, workout: workout)) {
                                                WorkoutModule(title: workout.WorkoutName, description: "Module Description")
                                                
                                            }
                                       
                                       
                                            
                                        }
                                    }
                                }
                            } else {
                                TextHelvetica(content: "Created workouts will apear here", size: 22)
                                    .foregroundColor(Color("GrayFontOne"))
                            }
                            
                        }
                        HStack {
                            TextHelvetica(content: "Templates", size: 28).bold().foregroundColor(Color("LinkBlue"))
                                Spacer()
                        }
                        workoutSection(title: "Back Workout")
                        workoutSection(title: "Chest Workout")
                        workoutSection(title: "Leg Workout")
                        
                        
                        Spacer()
                    }
                  
                    .padding(.horizontal)
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.3)
                        .foregroundColor(Color("DBblack"))
                }
                .background(Color("DBblack"))
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.2)
                        .position(x: getScreenBounds().width/2, y: getScreenBounds().height * -0.1)
                        .foregroundColor(Color("MainGray"))
              
                
            }
           
 
        }
       
    }
    
    
    func workoutSection(title: String) -> some View {
        Section(header: TextHelvetica(content: title, size: 23).bold().foregroundColor(Color("WhiteFontOne"))) {
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
}

struct WorkoutModule: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                TextHelvetica(content: title, size: 18)
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
        .frame(width: getScreenBounds().width * 0.5, height: getScreenBounds().height * 0.15)
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
    var workout: HomePageModel.Workout
    
    var body: some View {
        VStack {
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


                            TextHelvetica(content: "Start Workout", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
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
        
          
            Spacer()
            
        }.navigationBarTitle("Start Workout", displayMode: .inline)
        
      
    }
    
}



