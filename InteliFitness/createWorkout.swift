//
//  createWorkout.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/30/23.
//

import SwiftUI

struct createWorkout: View {

        @ObservedObject var homePageVeiwModel: HomePageViewModel
        @StateObject var workoutLogViewModel = WorkoutLogViewModel()
        @StateObject var timeViewModel = TimeViewModel()
        @State private var progressValue: Float = 0.5
        @State private var blocked = false
        @State private var exersiseNotes: String = ""
        @State private var newModuleOpacity = false
        @State private var workoutName: String = ""
        @State private var NamePopUp: Bool = false
        @Binding var isNavigationBarHidden: Bool
        var currentWorkout: ScheduleWorkout
        var editingMyWorkouts: UUID = UUID()
        @Environment(\.presentationMode) private var presentationMode
        @Environment(\.scenePhase) private var scenePhase
        


        var body: some View {
         
            
            ZStack {
                
                NavigationStack {
                    ScrollView(.vertical){
                        Text("")
              

                        
                            .navigationBarHidden(false)
                           
                        VStack(spacing: 0) {

                            ZStack {
                                HStack {
                                    
                                        TextField("", text: $workoutName, prompt: Text("").foregroundColor(Color("GrayFontOne")))
                                            .font(.custom("SpaceGrotesk-Medium", size: 40))
                                            .foregroundColor((workoutName == "Workout Name") ? Color("GrayFontOne") : Color("WhiteFontOne"))
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                            .scaledToFit()
                                            .onTapGesture {
                                                workoutName = ""
                                            }
                                            
                                        
                                        
                                        ZStack{
                                            
                                            HStack(spacing: 4) {
                                                Circle()
                                                Circle()
                                                Circle()
                                                
                                            }
                                            .scaleEffect(0.76)
                                            .foregroundColor(Color("BorderGray"))
                                            .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                                            
                                            
                                        
                                            Button(action: {
                                                HapticManager.instance.impact(style: .rigid)
                                                withAnimation(.spring()) {
                                                    workoutLogViewModel.setPopUpState(state: true, popUpId: "TitlePagePopUp")
                                                }}, label: {
                                                    RoundedRectangle(cornerRadius: 3)
                                                        .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                                    .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                                            
                                            
                                                                      

                                        }
                                        .offset(y: 3)
                                        Spacer()
                                }
                                .zIndex(0)
                                
                                
                     
                                    
                                
                            
                                
                                   
                            }
                               


                       


                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.1)

                                .foregroundColor(.clear)


                            }
                            .frame(width: getScreenBounds().width * 0.95)
                            .padding(.top, 150)
                            .padding(.bottom)

                            
                        
            
            
                        

                

                        Spacer()
                  
                        VStack(spacing: 85){
                         
                                
                            ForEach(workoutLogViewModel.exersiseModules){ workoutModule in

                                if workoutModule.isLast == false {
                                    let exerciseID = workoutLogViewModel.getUUIDindex(index: workoutModule.id)
                                    ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, homePageViewModel: homePageVeiwModel, timeViewModel: timeViewModel, blocked: $blocked, parentModuleID: exerciseID, moduleUUID: workoutModule.id, isLive: false)
                                    

                                }
                         
                               
                            }
                           
                            
                            FullWidthButton(viewModel: workoutLogViewModel).padding(.top, -90.0)
                            

                            .padding(.bottom, 400)

                 
                           
                            
                            
                            
                            
                        }
                        
                
                    }.padding(.top, 75)
                    
                    .onTapGesture {

                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        //
                    }
                    
                }
                
                
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.51)
                     
                        .foregroundColor(Color("MainGray"))
                    
                   
                 
                }.position(x: getScreenBounds().width/2, y: getScreenBounds().height * -0.12)
                    .shadow(radius: 10)
                 
              
                


         
                let popUps = workoutLogViewModel.workoutLogModel.popUps
                let displayStats  = popUps[0].RPEpopUpState || popUps[1].RPEpopUpState || popUps[2].RPEpopUpState || popUps[4].RPEpopUpState || popUps[5].RPEpopUpState || popUps[7].RPEpopUpState || popUps[8].RPEpopUpState || popUps[9].RPEpopUpState || popUps[10].RPEpopUpState || workoutLogViewModel.displayingExerciseViewForCreator
                

                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .opacity(displayStats ? 0.4 : 0)
                    .scaleEffect(1.7)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpRPE")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDataMetrics")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "DropDownMenu")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "TimerCompletedPopUP")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "ReorderSets")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "TitlePagePopUp")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "SetMenuPopUp")
                            workoutLogViewModel.setPopUpState(state: false, popUpId: "TimerPopUp")
            //                workoutLogViewModel.setPopUpState(state: false, popUpId: "SetTimeSubMenu")
            //                workoutLogViewModel.setPopUpState(state: false, popUpId: "SetUnitSubMenu")
                            
                        }
                    }
 
                let offset = homePageVeiwModel.ongoingWorkout ? 0 : -0.1
                Group {

                    TimerCompletedPopUp(viewModel: workoutLogViewModel)
                        .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "TimerCompletedPopUP").RPEpopUpState ? 1 : 0)
                        .allowsHitTesting(workoutLogViewModel.getPopUp(popUpId: "TimerCompletedPopUP").RPEpopUpState)
                 
                    PopupView(viewModel: workoutLogViewModel, timeViewModel: timeViewModel, isLive: false)
                        .shadow(radius: 10)
                        .position(x: UIScreen.main.bounds.width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpRPE").RPEpopUpState ? UIScreen.main.bounds.height * (0.69 - offset) : UIScreen.main.bounds.height * 1.5)
                    
                    
                   
                   
                    DotsMenuView(viewModel: workoutLogViewModel, timerViewModel: timeViewModel)
                        .shadow(radius: 10)

                        .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpDotsMenu").RPEpopUpState ? getScreenBounds().height * (0.52 - offset) : getScreenBounds().height * 1.5)



                    
                    ReorderSets(viewModel: workoutLogViewModel)
                        .position(x: getScreenBounds().width/2, y: getScreenBounds().height * (0.35 - offset))
                        .opacity(workoutLogViewModel.getPopUp(popUpId: "ReorderSets").RPEpopUpState ? 1 : 0)
                        
                        .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "ReorderSets").RPEpopUpState ? 1 : 0.5, anchor: .top)

    //
    //                    .opacity(workoutLogViewModel.getPopUp(popUpId: "TitlePagePopUp").RPEpopUpState ? 1 : 0)
    //
    //                    .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "TitlePagePopUp").RPEpopUpState ? 1 : 0.5, anchor: .top)

                }
                
              

                NamePopUP( viewModel: workoutLogViewModel, timeViewModel: timeViewModel, isForCreator: true)

    //                .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.1)
    //                .position(x: getScreenBounds().width / 2, y: getScreenBounds().height * 0.2)

                    .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.1)
                    .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "TitlePagePopUp").RPEpopUpState ? getScreenBounds().height * (0.75 - offset) : getScreenBounds().height * 1.3)
                
                
                SetMenu( viewModel: workoutLogViewModel)
                    .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.1)
                    .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "SetMenuPopUp").RPEpopUpState ? getScreenBounds().height * (0.65 - offset) : getScreenBounds().height * 1.3)
                
                restTimeSet(viewModel: workoutLogViewModel, timerViewModel: timeViewModel)
                    .opacity(workoutLogViewModel.getPopUp(popUpId: "SetTimeSubMenu").RPEpopUpState ? 1 : 0)

                    .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "SetTimeSubMenu").RPEpopUpState ? 1 : 0.5, anchor: .top)
                
                    .position(x: getScreenBounds().width/2, y: getScreenBounds().height * (0.35 - offset))
                

                
             
                
                
                weightUnitSet(viewModel: workoutLogViewModel)
                    .opacity(workoutLogViewModel.getPopUp(popUpId: "SetUnitSubMenu").RPEpopUpState ? 1 : 0)

                    .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "SetUnitSubMenu").RPEpopUpState ? 1 : 0.5, anchor: .top)
                    .position(x: getScreenBounds().width/2, y: getScreenBounds().height * (0.35 - offset))
                
                
          
                
                
                Group {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(workoutLogViewModel.workoutLogModel.popUps[3].RPEpopUpState ? 1 : 0)
                    
                    
                  
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
                            if currentWorkout.id != 0 {
                                TextHelvetica(content: "Edit", size: 20)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .bold()
                            } else {
                                TextHelvetica(content: "Create", size: 20)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .bold()
                            }
                            
                          
                            Spacer()
                                if currentWorkout.id == 0 {
                                    
                                    Button {
                   
                                        homePageVeiwModel.addToMyWorkouts(workoutName: workoutName, exersiseModules: workoutLogViewModel.exersiseModules)
                                        presentationMode.wrappedValue.dismiss()
                                     
                                       
                                    }
                                    label: {
                                        ZStack{
                                                                               
                                        
                                           RoundedRectangle(cornerRadius: 6)
                                                   .foregroundColor(Color("LinkBlue"))

                                               
                                            TextHelvetica(content: "Create", size: 19)
                                                 .foregroundColor(Color("WhiteFontOne"))
                                           
                                         
                                           
                                           
                              
                                     
                                           
                                       
                                           
                                           
                                       }
                                       .frame(width: 100 ,height: getScreenBounds().height * 0.048)
                                        
                            
                                       .aspectRatio(2.5, contentMode: .fit)
                                    }
                                    
                                } else if currentWorkout.id == 69 {
                                    Button {
                                        
                                        homePageVeiwModel.editMyWorkouts(workoutName: workoutName, exersiseModules: workoutLogViewModel.exersiseModules, id: editingMyWorkouts)
                                        presentationMode.wrappedValue.dismiss()
                                     
                                       
                                    }
                                    label: {
                                        ZStack{
                                                                               
                                        
                                           RoundedRectangle(cornerRadius: 6)
                                                   .foregroundColor(Color("LinkBlue"))

                                               
                                            TextHelvetica(content: "Save", size: 19)
                                                 .foregroundColor(Color("WhiteFontOne"))
                                           
                                         
                                           
                                           
                              
                                     
                                           
                                       
                                           
                                           
                                       }
                                       .frame(width: 100 ,height: getScreenBounds().height * 0.048)
                                        
                            
                                       .aspectRatio(2.5, contentMode: .fit)
                                    }
                                } else  {
                                    Button {
                             
                                        let newWorkout = ScheduleWorkout(id: currentWorkout.id, name: workoutName, exercises: workoutLogViewModel.exersiseModules, time: currentWorkout.time, HasBeenDone: currentWorkout.HasBeenDone)
                                        homePageVeiwModel.replaceWorkout(workout: newWorkout)
                                        presentationMode.wrappedValue.dismiss()
                                     
                                       
                                    }
                                    label: {
                                        ZStack{
                                                                               
                                        
                                           RoundedRectangle(cornerRadius: 6)
                                                   .foregroundColor(Color("LinkBlue"))

                                               
                                            TextHelvetica(content: "Save", size: 19)
                                                 .foregroundColor(Color("WhiteFontOne"))
                                           
                                         
                                           
                                           
                              
                                     
                                           
                                       
                                           
                                           
                                       }
                                       .frame(width: 100 ,height: getScreenBounds().height * 0.048)
                                        
                            
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
                
                
                Group {
                    
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(workoutLogViewModel.workoutLogModel.popUps[11].RPEpopUpState ? 1 : 0)
                        .scaleEffect(1.2)
                        
                    TimerPopUp(viewModel: workoutLogViewModel, timeViewModel: timeViewModel)
             
                        .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "TimerPopUp").RPEpopUpState ? getScreenBounds().height * (0.42 - offset) : getScreenBounds().height * 2) // shout be two

               
                
              
             
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(workoutLogViewModel.workoutLogModel.popUps[6].RPEpopUpState ? 1 : 0)
                        .offset(y: getScreenBounds().height * -0.07)
                        AddExersisesPopUp(viewModel: workoutLogViewModel, homePageViewModel: homePageVeiwModel, heightModifier: 0.82)
                        .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "ExersisesPopUp").RPEpopUpState ? getScreenBounds().height * 0.5 : getScreenBounds().height * 2) // shout be two
                        
                
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(workoutLogViewModel.displayingExerciseView ? 1 : 0)
                      
                    ExercisePage(viewModel: homePageVeiwModel, showingExrcisePage: $workoutLogViewModel.displayingExerciseViewForCreator)
                        .position(x: getScreenBounds().width/2, y: workoutLogViewModel.displayingExerciseViewForCreator ? getScreenBounds().height * 0.5 : getScreenBounds().height * 1.5)
                }
             
              
            }
            .offset(y: homePageVeiwModel.showingExercises ? -1 * getScreenBounds().height * 0.05: 0)
            .navigationBarTitle(" ")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = true
           
            }
            .ignoresSafeArea(.all, edges: .top)
            .ignoresSafeArea(.keyboard)
           
            .onTapGesture {
              
     

                withAnimation(.spring(response: 0))
                {
                    for key in workoutLogViewModel.popUpStates.keys {
                        workoutLogViewModel.popUpStates[key] = false
                    }
                   
                }

               
            }
            .background(
                LinearGradient(
                gradient: Gradient(colors: [
                    Color("DBblack"),
                    
                    Color("MainGrayLight")
                ]),
                startPoint: .top,
                endPoint: .bottomTrailing
                
                
            ))
            


            .onAppear {
                workoutName = "Workout Name"

                requestNotificationPermission()
                
            }
        }
        func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permission: \(error)")
                    return
                }

                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
        

    }

struct createWorkoutDropDown: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel: HomePageViewModel
    @State private var isToggled = false
    @State private var exersiseNotes: String = ""
    var body: some View {
        // Add a blur effect to the background
   
        VStack(spacing: borderWeight) {

               
            ZStack {
           
                Rectangle()
                    .foregroundColor(Color("MainGray"))
                .aspectRatio(3.3, contentMode: .fit)
                
                HStack {
                   
         
                    
                Rectangle()
                    .frame(width: getScreenBounds().width * 0.25,height: getScreenBounds().height * 0.05)
                    .offset(y: getScreenBounds().height * 0.03)
                    .aspectRatio(2.5, contentMode: .fit)
                    .padding(.leading, 25)
                    .foregroundColor(.clear)
                        
                        
                   
                    
              
                   
                   
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.clear)
                        .foregroundColor(.clear)
                        .padding(.horizontal, 50)
                    

                    

                 
                }
       
                
                
                    TextHelvetica(content: "New Workout", size: 20)
   
                    .foregroundColor(Color("GrayFontOne"))
                    .padding(.horizontal, 50)
                    .offset(y: getScreenBounds().height * 0.03)
       
              
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
}

 
