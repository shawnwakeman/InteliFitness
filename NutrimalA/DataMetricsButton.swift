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
                HStack{


                
                    TextHelvetica(content: "Total Volume", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: "1203", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{

                    TextHelvetica(content: "Total Reps", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: "123", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                    
                    TextHelvetica(content: "Weight/Set", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: "123.4", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                HStack{
                   
                    TextHelvetica(content: "Reps/Set", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: "12.4", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))

                    
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                   
                    TextHelvetica(content: "PR Sets", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: "3/8", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                

                
                
                
                
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                


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


