//
//  PausePopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/10/23.
//

import SwiftUI

struct PausePopUp: View {
    @State private var time: Double = 0
    @State private var isToggled = false
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var timeViewModel: TimeViewModel
    
    var body: some View {
        VStack {
         
            HStack {
                
                
                
                TextHelvetica(content: "Workout Paused", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                
                
            }
            .padding(.top, 5)
            .padding(.horizontal)
            .padding(.vertical, 10)
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
            Spacer()
         
            
            
            let hours = timeViewModel.workoutTime.timeElapsed / 3600
            let minutes = (timeViewModel.workoutTime.timeElapsed / 60) - (hours * 60)
            let seconds = timeViewModel.workoutTime.timeElapsed % 60
            if timeViewModel.workoutTime.timeElapsed > 0 {
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
      
            
            
            
            Button {
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    viewModel.setPopUpState(state: false, popUpId: "PausePopUp")
                }
                timeViewModel.setTimeStep(step: 1)

   
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color("BlueOverlay"))
                        .padding(.vertical)
                        .padding(.horizontal, 10)
        
                    

                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                    
                        .padding(.vertical)
                        .padding(.horizontal, 10)
                 
                        
                 
                    
                    
                    TextHelvetica(content: "Resume Workout", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame(width: getScreenBounds().width * 0.85, height: getScreenBounds().height * 0.1)
            }
            

            
            
        }

       


        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.3)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding(.all)
    }
}
