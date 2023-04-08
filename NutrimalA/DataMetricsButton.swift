//
//  3DotsButton.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI

struct DataMetricsPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {

            VStack {
                Button(action: {

                    withAnimation(.spring())
                    {
                        for key in viewModel.popUpStates.keys {
                            if key != "DataMetricsPopUp" {
                                viewModel.popUpStates[key] = false
                            }

                        }
                        viewModel.popUpStates["DataMetricsPopUp"]?.toggle()

                    }
                    
                    }) {
                        
                          RoundedRectangle(cornerRadius: 3)
                          
                              .stroke(Color("BorderGray"), lineWidth: borderWeight)
                              .frame(width: 39.4, height: 28)
                          
                
                }
                
            }
            .overlay(
                GeometryReader { geometry in
    //                    let frame = geometry.frame(in: .global)
                    VStack {
                        Spacer()
                        VStack {
                            Text("3")
                                .font(.headline)
                                .padding()
                            Divider()
                            Button("Dismiss") {
                                viewModel.popUpStates["DataMetricsPopUp"]? = false
                            }
                            .padding(.bottom)
                        }
                        .frame(width: (UIScreen.main.bounds.width - 30))
                        
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .position(CGPoint(x: -159, y: viewModel.popUpStates["DataMetricsPopUp"]! ? UIScreen.main.bounds.height - 500 : UIScreen.main.bounds.height))
                        // not safe

                        
                    }
           
                }
            )
    }
}
