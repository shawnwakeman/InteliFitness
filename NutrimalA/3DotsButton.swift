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

    @State private var vibrateOnRing = true
    @State var notesdisplay = false
    var body: some View {
        // Add a blur effect to the background
        
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
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
            
            VStack {
               
                HStack{
                    
                    Image(systemName: "note.text")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    TextHelvetica(content: "Display Exersise Notes", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    Toggle(isOn: $notesdisplay) {
                        Text("Vibrate on Ring")
                        
                    }.onChange(of: notesdisplay) { newValue in
                        // Call your function here
                        let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                        viewModel.toggleExersiseModuleNotesDisplayStatus(exersiseID: index)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring()) {
                                viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                            }
                        }
                    }
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                    
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                    

                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                                
                Button {
                    print("das")
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
                        TextHelvetica(content: "Back Squat", size: 17)
                            .foregroundColor(Color("GrayFontOne"))
                        Image("sidwaysArrow")
                            .resizable()
                        
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: 22)
                }
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                Button {
                    print("das")
                }
                label: {
                    HStack{
                        
                        Image(systemName: "clock")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(.large)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        TextHelvetica(content: "Set exersise rest time", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        Spacer()
                        TextHelvetica(content: "2:00", size: 17)
                            .foregroundColor(Color("GrayFontOne"))
                        Image("sidwaysArrow")
                            .resizable()
                        
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: 22)
                }
             
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                Button {
                    print("das")
                }
                label: {
                    HStack{
                        
                        Image(systemName: "scalemass")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(.large)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        TextHelvetica(content: "Weight Unit", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        Spacer()
                        TextHelvetica(content: "Lbs", size: 17)
                            .foregroundColor(Color("GrayFontOne"))
                        Image("sidwaysArrow")
                            .resizable()
                        
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: 22)
                }
               
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                   
                    TextHelvetica(content: "RPE", size: 20)
                        .foregroundColor(Color("LinkBlue"))
                
                    TextHelvetica(content: "Enable/Disable RPE", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    Toggle(isOn: $vibrateOnRing) {
                        Text("Vibrate on Ring")

                    }.onChange(of: vibrateOnRing) { newValue in
                        // Call your function here
                        let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                        viewModel.setExersiseModuleRPEDisplayStatus(exersiseID: index, state: newValue)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring()) {
                                viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                            }
                        }
                    }
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                

                
                
                
                
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                


            }
            Button {
//                popUpDotsMenu
                HapticManager.instance.impact(style: .rigid)
                let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
  
                viewModel.setRemoved(exersiseID: index)
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
        .frame(maxWidth: 400)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding()


            
    }
    

}

