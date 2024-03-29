//
//  3DotsButton.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI

struct DotsMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
   @ObservedObject var timerViewModel: TimeViewModel
    @State private var vibrateOnRing = true
    @State var notesdisplay = false
    @State private var showingRestTime = false
    @State private var showingUnitSet = false
    @State private var showingNotes = false
    @State private var showingRPE = false
    @State private var showingExercise = ""
    @State private var yourMom = 120
    
    @State private var timeForSliderStart = 0
    var body: some View {
        // Add a blur effect to the background
        VStack{




            Spacer()
            VStack {
                

                HStack {

                    
                    
                    TextHelvetica(content: "Exersise Options", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                        }

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
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                   

                        
                    Group {

                                        
  
                    Button {
                        let moduleID = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                        viewModel.toggleReplacingExercise(state: true, index: moduleID)
                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: true, popUpId: "ExersisesPopUp")

                            viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                        }
                        
                      
                       
                    }
                    label: {
                        HStack{
                            
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            TextHelvetica(content: "Replace exersise", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                            TextHelvetica(content: showingExercise.isEmpty ? "" : showingExercise, size: 17)
                                .foregroundColor(Color("GrayFontOne"))
                                
                      
                          
                                  
                           
                           
                            Image("sidwaysArrow")
                                .resizable()
                                .foregroundColor(Color("LinkBlue"))
                                .aspectRatio(24/48, contentMode: .fit)
                                .frame(maxHeight: 22)
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: 22)
                    }
                    
                    Divider()
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    
                    
//                    Button {
//                        withAnimation(.spring()) {
//                            viewModel.setPopUpState(state: true, popUpId: "SetUnitSubMenu")
//                        }
//
//                        withAnimation(.linear(duration: 0.9)){
//
//                            viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
//                        }
//
//                    }
//                    label: {
//                        HStack{
//
//                            Image(systemName: "scalemass")
//                                .foregroundColor(Color("LinkBlue"))
//                                .imageScale(.large)
//                                .bold()
//                                .multilineTextAlignment(.leading)
//
//                            TextHelvetica(content: "Add Warm Up Sets", size: 18)
//                                .foregroundColor(Color("WhiteFontOne"))
//
//                            Spacer()
//                            TextHelvetica(content: "", size: 17)
//                                .foregroundColor(Color("GrayFontOne"))
//                            Image("sidwaysArrow")
//                                .resizable()
//
//                                .aspectRatio(24/48, contentMode: .fit)
//                                .frame(maxHeight: 22)
//                        }
//                        .padding(.horizontal)
//                        .frame(maxHeight: 22)
//                    }
            
                        Button {
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                                viewModel.setPopUpState(state: true, popUpId: "SetTimeSubMenu")
                            }
       
                            withAnimation(.spring()){
                           
                                viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                            }
                            
                

                        }
                        label: {
                            HStack{
                                
                                Image(systemName: "clock")
                                    .foregroundColor(Color("LinkBlue"))
                                    .imageScale(.large)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                
                                TextHelvetica(content: "Set auto rest time", size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                
                                Spacer()

                                
                                let minutes = yourMom/60
                                let seconds = yourMom % 60

                                TextHelvetica(content: "\(String(Int(minutes))):\(String(format: "%02d", Int(seconds)))", size: 17)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .fontWeight(.bold)
                                Image("sidwaysArrow")
                                    .resizable()
                                    .foregroundColor(Color("LinkBlue"))
                                    .aspectRatio(24/48, contentMode: .fit)
                                    .frame(maxHeight: 22)
                            }
                            .padding(.horizontal)
                            .frame(maxHeight: 22)
                        }
                     
                        
                        Divider()
                            .frame(height: borderWeight)
                            .overlay(Color("BorderGray"))
                    }
                 
                  
               
                    HStack{
                       
                        TextHelvetica(content: "RPE", size: 20)
                            .foregroundColor(Color("LinkBlue"))
                    
                        TextHelvetica(content: "Enable/Disable RPE", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                      
                        Spacer()
                        
                            TextHelvetica(content: showingRPE ? "Disable" : "Enable ", size: 17)
                          .foregroundColor(Color("LinkBlue"))
                                
                   
                        
                
                        Image("sidwaysArrow")
                            .resizable()
                            .foregroundColor(Color("LinkBlue"))
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                        
                    
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                    }
                   
                    .padding(.horizontal)
                    .frame(maxHeight: 22)
                    .onTapGesture {
                           // Call your function here
                        HapticManager.instance.impact(style: .rigid)
                           let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                           viewModel.setExersiseModuleRPEDisplayStatus(exersiseID: index, state: false)
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                               withAnimation(.spring()) {
                                   viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                               }
                           }
                       }
                    
                    Divider()
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    
                    HStack{
                        
                        Image(systemName: "note.text")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(.large)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        TextHelvetica(content: "Display Exersise Notes", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                        
                            TextHelvetica(content: showingNotes ? "Disable" : "Enable ", size: 17)
              
                                .foregroundColor(Color("LinkBlue"))
                    
                      
                        Image("sidwaysArrow")
                            .resizable()
                            .foregroundColor(Color("LinkBlue"))
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                        
                        
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                        
                        
                    }
                   
                    .padding(.horizontal)
                    .frame(maxHeight: 22)

                    .onTapGesture {
                        // Call your function here
                        HapticManager.instance.impact(style: .rigid)
                        let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                        viewModel.toggleExersiseModuleNotesDisplayStatus(exersiseID: index)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring()) {
                                viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                            }
                        }
                    }
                    
                    
                    
                    
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    


                }
                Button {
  
                    HapticManager.instance.impact(style: .rigid)
                    let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUPUUID
//                    print("removing")
                    viewModel.removeExersiseModule(exersiseID: index)
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                    }
              
                }
                label: {
                    HStack{
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("MainRed"))
                            .imageScale(.large)
                            .bold()
                    
                        TextHelvetica(content: "Remove Exersise", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()

                        
                    }
                    .offset(y: -5)
                    .padding(.horizontal)
                    .frame(maxHeight: 30)
                    
                }
             
               
                
            }
            .frame(width: getScreenBounds().width * 0.95)
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding()

            
        }
        .onChange(of: timerViewModel.restTime.timePreset) { newValue in
           
            yourMom = newValue
        }
        .onChange(of: timerViewModel.restTime.timePreset) { newValue in

            yourMom = newValue
        }
        .onChange(of: viewModel.getPopUp(popUpId: "popUpDotsMenu")) { newValue in
            let index = newValue.popUpExersiseModuleIndex
            if viewModel.exersiseModules[safe: index] != nil {
               
                showingRPE = viewModel.exersiseModules[index].displayingRPE
                showingNotes = viewModel.exersiseModules[index].displayingNotes
                showingExercise = viewModel.exersiseModules[index].exersiseName
            }
            
            
        }

        .frame(height: getScreenBounds().height * 0.63)
        


            
    }
    
    
    
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct restTimeSet: View {
    @State private var time: Double = 0
    @State private var isToggled = true
    @ObservedObject var viewModel: WorkoutLogViewModel
   @ObservedObject var timerViewModel: TimeViewModel

    var body: some View {
        VStack {
            
            HStack {

                
                TextHelvetica(content: "Exercise Rest Time", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {

                   if !isToggled {
                      viewModel.setTimeInWorkout(time: Int(0), ModuleID: viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex)
                   } else {
                      viewModel.setTimeInWorkout(time: Int(time), ModuleID: viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex)
                   }
                    
                
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.70, blendDuration: 0)) {
                        viewModel.setPopUpState(state: false, popUpId: "SetTimeSubMenu")
                    }
                  
                   
                    HapticManager.instance.impact(style: .rigid)


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
                            .foregroundColor(Color("LinkBlue"))
                            .frame(width: 17, height: 17)
                        
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
            }
            .padding(.top, -2)
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            let minutes = floor(time/60)
            let seconds = time.truncatingRemainder(dividingBy: 60).rounded()

            TextHelvetica(content: "\(String(Int(minutes))):\(String(format: "%02d", Int(seconds)))", size: 23)
                .foregroundColor(Color("WhiteFontOne"))
                .fontWeight(.bold)
            
            
         

                        
           
           Slider(value: $time, in: 0...360, step: 15)
               .padding(.all)
               .offset(y: -10)
               .disabled(!isToggled)
               .accentColor(Color("LinkBlue"))
           
                       
           HStack(spacing: 0) {
               TextHelvetica(content: "Exercise Rest Timer", size: 18)
                   .foregroundColor(Color("GrayFontOne"))
                   .padding(.trailing, 9)

               Toggle("", isOn: $isToggled)
                   .frame(maxWidth: 52)
                   .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                   
           }.offset(y: -10)

        }
        .onAppear {
            time = Double(timerViewModel.restTime.timePreset)
        }
        .onChange(of: timerViewModel.restTime.timePreset) { newValue in
            time = Double(newValue)
        }

        .frame(height: getScreenBounds().height * 0.25)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding(.all)
    }
}

struct weightUnitSet: View {
    @State private var time: Double = 0
    @State private var isToggled = false
    @State private var selectedRPE = 2
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {
        VStack {
            
            HStack {

                
                
                TextHelvetica(content: "Select Weight Unit", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.70, blendDuration: 0)) {
                        viewModel.setPopUpState(state: false, popUpId: "SetUnitSubMenu")
                    }
                    HapticManager.instance.impact(style: .rigid)


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
                            .foregroundColor(Color("LinkBlue"))
                            .frame(width: 17, height: 17)
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
            }
            .padding(.top, -40)
            .padding(.horizontal)
            .padding(.vertical, 15)
            



            HStack(spacing: -1) {
                Button(action: {
             
                    HapticManager.instance.impact(style: .rigid)
                    selectedRPE = 2
                    }) {
                        
                        if Float(selectedRPE) == 2 {
                            TextHelvetica(content: "Lbs", size: 18)
                            
                                .frame(width: getScreenBounds().width * 0.2, height: getScreenBounds().height * 0.07)
                                .background(Color("WhiteFontOne"))
                     
                            
                        } else {
                            TextHelvetica(content: "Lbs", size: 18)
                            
                                .frame(width: getScreenBounds().width * 0.2, height: getScreenBounds().height * 0.07)
                                .background(Color("MainGray"))
               
                            
                        }
                    }
                
                Divider()
                
                    .frame(width: borderWeight, height: getScreenBounds().height * 0.07)
                    .overlay(Color("BorderGray"))
                
                
                Button(action: {
             
                    HapticManager.instance.impact(style: .rigid)
                    selectedRPE = 1
             
                    }) {
                        
                        if Float(selectedRPE) == 1 {
                            TextHelvetica(content: "Kg", size: 18)
                            
                                .frame(width: getScreenBounds().width * 0.2, height: getScreenBounds().height * 0.07)
                                .background(Color("WhiteFontOne"))
                 
                            
                        } else {
                            TextHelvetica(content: "Kg", size: 18)
                            
                                .frame(width: getScreenBounds().width * 0.2, height: getScreenBounds().height * 0.07)
                                .background(Color("MainGray"))
         
                            
                        }
                    }

                
                
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight - 0.5))

            
         

                        
           
         
          

        }
        
        .frame(height: getScreenBounds().height * 0.2)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding(.all)
    }
}
