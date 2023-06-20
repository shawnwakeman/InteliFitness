//
//  TimerCompletedPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/16/23.
//

import SwiftUI


struct TimerCompletedPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    var body: some View {
        // Add a blur effect to the background
        
        VStack {
            
             
            HStack {


                TextHelvetica(content: "Rest Time Is Up", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                
               
                
            }
            .padding(.all)
            

            

          
           
            
        }
        .frame(maxWidth: getScreenBounds().width * 0.95)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))



            
    }
}


