//
//  WorkoutSelectionsSheetView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/10/23.
//

import SwiftUI

struct DropDownMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var timerViewModel: TimeViewModel
    @ObservedObject var homePageViewModel: HomePageViewModel
    @State private var isToggled = false
    @State private var exersiseNotes: String = ""
    @State private var showingIncompleteWorkoutAlert = false
    var body: some View {
        // Add a blur effect to the background
   
        VStack(spacing: borderWeight) {

               
            ZStack {
           
                Rectangle()
                    .foregroundColor(Color("MainGray"))
                .aspectRatio(3.3, contentMode: .fit)
                
                HStack {
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if homePageViewModel.workoutLogModuleStatus == true {
                            withAnimation(.spring()) {
                                viewModel.setPopUpState(state: true, popUpId: "TimerPopUp")
                            }
                        } else {
                            withAnimation(.spring()) {
                                homePageViewModel.setWorkoutLogModuleStatus(state: true)
                                viewModel.setPopUpState(state: true, popUpId: "TimerPopUp")
                            }
                        }
                        HapticManager.instance.impact(style: .rigid)
                        
                    }
                label: {
                    
                    ZStack{
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("DBblack"))
                            
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            
                        }

                        
                        
                       
                        HStack{
                            Image(systemName: "clock")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                            WorkoutTimer(viewModel: viewModel, timeViewModel: timerViewModel, step: -1, fontSize: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
                        
                        
                        
                    }
                 
                    
                }.frame(width: getScreenBounds().width * 0.25, height: getScreenBounds().height * 0.05)
                        .offset(y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.03 : getScreenBounds().height * -0.01)
                        .aspectRatio(2.5, contentMode: .fit)
                        .padding(.leading, 25)
                        .background(Color.clear.frame(width: getScreenBounds().width * 0.25 * 1.5, height: getScreenBounds().height * 0.05 * 1.5)) // Increase the hitbox size
                   
                    ZStack {
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(.clear)
                            .padding(.horizontal, 50)

                        ElapsedTime(viewModel: viewModel, timeViewModel: timerViewModel, step: timerViewModel.workoutTime.timeStep, fontSize: 20)

                            .foregroundColor(Color("GrayFontOne"))

                            .offset(y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.03 : getScreenBounds().height * -0.01)
                    }

                    ZStack{
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("LinkBlue"))

                            
                        }
                      
                        
                        Button {
                            
                            HapticManager.instance.impact(style: .rigid)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            let hasIncomplete = homePageViewModel.hasIncompleteWorkout(exerciseModules: viewModel.exersiseModules)
                            if hasIncomplete {
                                showingIncompleteWorkoutAlert = true
                            } else {
                                homePageViewModel.addToHistory(workoutName: viewModel.workoutName, exersiseModules: viewModel.exersiseModules, workoutTime: timerViewModel.workoutTime.timeElapsed, workoutNotes: viewModel.workoutNotes)
                                homePageViewModel.addToMyWorkoutsRecent(workoutName: viewModel.workoutName, exersiseModules: viewModel.exersiseModules)
                                if homePageViewModel.workoutLogModuleStatus == true {
                                    withAnimation(.spring()) {
                                        viewModel.setPopUpState(state: true, popUpId: "FinishPopUp")
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        homePageViewModel.setWorkoutLogModuleStatus(state: true)
                                        viewModel.setPopUpState(state: true, popUpId: "FinishPopUp")
                                    }
                                }
                                timerViewModel.setRestTime(time: 0)
                            }
                            
                         
                       
                         
                            
                         
                           
                        }
                    label: {
                       
                        TextHelvetica(content: "Finish", size: 19)
                             .foregroundColor(Color("WhiteFontOne"))
                    }
                    .alert(isPresented: $showingIncompleteWorkoutAlert) {
                        Alert(title: Text("Incomplete Workout"),
                              message: Text("You have incomplete sets in your workout. Are you sure you want to finish?"),
                              primaryButton: .default(Text("Yes"), action: {
                                    homePageViewModel.addToHistory(workoutName: viewModel.workoutName, exersiseModules: viewModel.exersiseModules, workoutTime: timerViewModel.workoutTime.timeElapsed, workoutNotes: viewModel.workoutNotes)
                                    homePageViewModel.addToMyWorkoutsRecent(workoutName: viewModel.workoutName, exersiseModules: viewModel.exersiseModules)
                                    if homePageViewModel.workoutLogModuleStatus == true {
                                        withAnimation(.spring()) {
                                            viewModel.setPopUpState(state: true, popUpId: "FinishPopUp")
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            homePageViewModel.setWorkoutLogModuleStatus(state: true)
                                            viewModel.setPopUpState(state: true, popUpId: "FinishPopUp")
                                        }
                                    }
                                    timerViewModel.setRestTime(time: 0)
                              }),
                              secondaryButton: .cancel())
                    }
           
                        
                    
                        
                        
                    }
                   
                    .frame(width: getScreenBounds().width * 0.25,height: getScreenBounds().height * 0.048)
                    .offset(x: getScreenBounds().width * -0.055, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.03 : getScreenBounds().height * -0.01)
                    .aspectRatio(2.5, contentMode: .fit)
                    .padding(.leading, 25)
                 

                 
                }
       
                
              
                    
              
            }
            
            
        }
            


 

        .background(Color("BorderGray"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

        .position(x: UIScreen.main.bounds.width/2, y:200)
//        .position(x: UIScreen.main.bounds.width/2, y:-80)
        
            
        


            
    }
    
    struct DisplayRow: View {
        var metric: String
        var value: String
        var body: some View {
            HStack{
               
                TextHelvetica(content: metric, size: 15)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                
                TextHelvetica(content: value, size: 14)
                    .foregroundColor(Color("WhiteFontOne"))
            }
            .padding(.horizontal, 5)

            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
        }
    }
}

 
struct TimerFullSize : View {
    @ObservedObject var viewModel: TimeViewModel
    @State var start = true
    @State var to : CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        
        ZStack{
            
            Color.black.opacity(0.0)
            
            VStack{
                
                ZStack{
               
                    Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                  
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.restTime.timeElapsed) / 120)
                        .stroke(Color("LinkBlue"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
         
                    .rotationEffect(.init(degrees: -90))
                    
                    
                    VStack{
                       

                        let hours = viewModel.restTime.timeElapsed / 3600
                        let minutes = (viewModel.restTime.timeElapsed / 60) - (hours * 60)
                        let seconds = viewModel.restTime.timeElapsed % 60

                        if viewModel.restTime.timeElapsed > 0 {
                            if hours < 1 {
                                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                                    
                        } else {
                            TextHelvetica(content: "0:00", size: 25)
                                .foregroundColor(Color("WhiteFontOne"))
                                .fontWeight(.bold)
                        }
                        

                        let hours1 = viewModel.restTime.timePreset / 3600
                        let minutes2 = (viewModel.restTime.timePreset / 60) - (hours * 60)
                        let seconds3 = viewModel.restTime.timePreset % 60
                        if viewModel.restTime.timePreset > 0 {
                            if hours < 1 {
                                TextHelvetica(content: "\(minutes2):\(String(format: "%02d", seconds3))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours1)):\(String(format: "%02d", minutes2)):\(String(format: "%02d", seconds3))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                                    
                        } else {
                            TextHelvetica(content: "0:00", size: 25)
                                .foregroundColor(Color("WhiteFontOne"))
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                


                
  
                Button {
            
                }
                label: {
                    ZStack{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("BlueOverlay"))

                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

              
                             
                            
                        }


                        TextHelvetica(content: "Set Rest Time", size: 16)
                            .padding(.all, 7)
                            .foregroundColor(Color(.white))
                    }
                    .aspectRatio(8/1, contentMode: .fit)
                  
                }

     
            }.padding(.all)
            
        }
        .frame(height: getScreenBounds().height * 0.225)
        .background(Color("MainGray"))
    }
    
}
