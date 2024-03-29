//
//  CancelPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/10/23.
//

import SwiftUI

struct CancelPopUp: View {
    @State private var time: Double = 0
    @State private var isToggled = false
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel: HomePageViewModel
    var body: some View {
        VStack {
         
            HStack {
                
                
                
                TextHelvetica(content: "Cancel Workout", size: 27)
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
         
            

            
            
            
            Button {
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    viewModel.setPopUpState(state: false, popUpId: "CancelPopUp")
                }

                viewModel.setWorkoutTime(time: 0)
                
                withAnimation(.spring()) {
                    homePageViewModel.setOngoingState(state: false)
                    homePageViewModel.setWorkoutLogModuleStatus(state: false)
           
                }
                

                cancelNotifications()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

   
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
                 
                        
                 
                    
                    
                    TextHelvetica(content: "Cancel Workout", size: 20)
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
