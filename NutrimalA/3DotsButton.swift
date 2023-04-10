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
    @State private var isToggled = false
    var body: some View {
        // Add a blur effect to the background
        
        VStack {
            HStack {

                

                TextHelvetica(content: "Exersise Options", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {
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
                
                    TextHelvetica(content: "Add notes", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{

                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                        .multilineTextAlignment(.leading)
                
                    TextHelvetica(content: "Replace exersise", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                    
                    Image(systemName: "clock")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Set exersise rest time", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                HStack{
                   
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Weight Unit", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()

                    
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                   
                    TextHelvetica(content: "RPE", size: 20)
                        .foregroundColor(Color("LinkBlue"))
                
                    TextHelvetica(content: "Enable/Disable RPE", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                

                
                
                
                
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                


            }
            
            HStack{
                
                Image(systemName: "xmark")
                    .foregroundColor(Color("LinkBlue"))
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
        .frame(maxWidth: 400)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding()


            
    }
}

