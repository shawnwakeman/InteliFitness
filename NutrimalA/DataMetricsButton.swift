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
                    
                        
                }.frame(maxWidth: 50)
                Spacer()
                TextHelvetica(content: "RPE", size: 25)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {print("Button pressed")}
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        TextHelvetica(content: "?", size: 23)
                    
                    }
                }.frame(maxWidth: 50)

                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            HStack(spacing: 20) {
                

                let popUp = viewModel.getPopUp(popUpId: "popUpRPE")
                
                
                Button(action: {
                    print(popUp)
                    viewModel.setRepMetric(exersiseModuleID: popUp.popUpExersiseModuleIndex, RowID: popUp.popUpRowIndex, RPE: 5); viewModel.setPopUpState(state: false, popUpId: "popUpRPE")}) {
                    TextHelvetica(content: "5", size: 18)
                
                }
                
           

                

            
            
            }
            
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color("DDB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding()
            
            
            HStack {
                HStack() {
                
                    TextHelvetica(content: "Target", size: 19)
                        .foregroundColor(Color("GrayFontOne"))
                    Divider()
                        .frame(width: borderWeight)
                        .overlay(Color("BorderGray"))
                    TextHelvetica(content: "10.5", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color("DDB"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                
                .padding()
                
                HStack {
                    TextHelvetica(content: "Show RPE", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                    
                    Toggle("", isOn: $isToggled)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.trailing,5)
                        
                    
                    
                    
                }
                
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(Color("DDB"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                .padding()
                

            }
            
        }
        .frame(maxWidth: 400, maxHeight: 220)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding()


            
    }
}

