//
//  FinishPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/10/23.
//

import SwiftUI

struct FinishPopUp: View {
    @State private var time: Double = 0
    @State private var isToggled = false
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {
        VStack {
            
            HStack {

                
                
                TextHelvetica(content: "Exersise Rest Time", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {

                
                    viewModel.setTimeInWorkout(time: Int(time), ModuleID: viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex)
                
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
            
            
         

                        
           
           
            Slider(value: $time, in: 0...360, step: 15).padding(.all).offset(y: -10)
            HStack(spacing: 0) {
                TextHelvetica(content: "Exersise Rest Timer", size: 18)
                    .foregroundColor(Color("GrayFontOne"))
                    .padding(.trailing, 9)

                Toggle("", isOn: $isToggled)
                    .frame(maxWidth: 52)
                    .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
             
                
            }.offset(y: -10)

        }
        .onAppear {
            time = Double(viewModel.restTime.timePreset)
        }
        .onChange(of: viewModel.restTime.timePreset) { newValue in
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

