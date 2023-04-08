//
//  3DotsButton.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI

struct DotsMenuView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {
        if viewModel.hidingPopUps == false {
            VStack {
                

                
                Button(action: {
                    

                    withAnimation(.spring())
                    {
                        self.isPresented.toggle()
                    }}) {
                        
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
                                    self.isPresented = false
                                }
                                .padding(.bottom)
                            }
                            .frame(width: (UIScreen.main.bounds.width - 30))
                            
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .position(CGPoint(x: -159, y: self.isPresented ? UIScreen.main.bounds.height : UIScreen.main.bounds.height - 500))

                            
                        }
               
                    }
            )
            .onChange(of: viewModel.hidingPopUps) { blockingPopUps in
                if blockingPopUps == true {
                    withAnimation(.spring()) {
                        self.isPresented = false
                    }
                    viewModel.setPopUpState(state: false)

                }
                
            }
        }
        
    }
}
