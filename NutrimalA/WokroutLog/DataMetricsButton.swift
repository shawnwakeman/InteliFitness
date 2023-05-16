//
//  3DotsButton.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI

struct DataMetricsPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    var body: some View {
        // Add a blur effect to the background
        
        VStack {
            
             
            HStack {


                TextHelvetica(content: "Exersise Metrics", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                
                Button {
                    HapticManager.instance.impact(style: .rigid)
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: false, popUpId: "popUpDataMetrics")
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
      
                   
                DisplayRow(metric: "Total Volume", value: "1203 lbs")
                DisplayRow(metric: "Total Reps", value: "120")
                DisplayRow(metric: "Weight/Set", value: "142.2 lbs")
                DisplayRow(metric: "Reps/Set", value: "12.2")
                DisplayRow(metric: "PR Sets", value: "3/8")
            
                

            }
            
          
           
            
        }
        .frame(maxWidth: getScreenBounds().width * 0.95)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))



            
    }
    
    struct DisplayRow: View {
        var metric: String
        var value: String
        var body: some View {
            HStack{
               
                TextHelvetica(content: metric, size: 18)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                
                TextHelvetica(content: value, size: 18)
                    .foregroundColor(Color("WhiteFontOne"))
            }
            .padding(.horizontal)
            .frame(maxHeight: 22)
            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
        }
    }
    


}


