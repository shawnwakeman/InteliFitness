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

                
                let index = viewModel.getPopUp(popUpId: "popUpDotsMenu").popUpExersiseModuleIndex
                let name = viewModel.exersiseModules[index].exersiseName
                TextHelvetica(content: "Exersise Options", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: false, popUpId: "popUpRPE")
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
                    
                        
                }.frame(maxWidth: 50, maxHeight: 35)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
            
            VStack {
                HStack{
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    Image(systemName: "note.text")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Add notes", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                }.padding(.horizontal)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Replace exersise", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                }.padding(.horizontal)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    Image(systemName: "clock")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Set exersise rest time", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                }.padding(.horizontal)
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                HStack{
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    TextHelvetica(content: "RPE", size: 20)
                        .foregroundColor(Color("LinkBlue"))
                
                    TextHelvetica(content: "Enable/Disable RPE", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                }.padding(.horizontal)
                
                
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                
                
                HStack{
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.large)
                        .bold()
                
                    TextHelvetica(content: "Weight Unit", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    TextHelvetica(content: "Weight Unit", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                }.padding(.horizontal)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                


            }
            
            HStack{
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                Image(systemName: "xmark")
                    .foregroundColor(Color("LinkBlue"))
                    .imageScale(.large)
                    .bold()
            
                TextHelvetica(content: "Remove Exersise", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                TextHelvetica(content: "Weight Unit", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                
            }.padding(.all)
            
           
            
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

