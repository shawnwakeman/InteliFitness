//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI



struct AddExersisesPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var search: String = ""
    var body: some View {
        VStack {
            HStack {
                
                Button {}
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight))
                        .foregroundColor(Color("MainGray"))
                    TextHelvetica(content: "New", size: 17)
                    
                        .foregroundColor(Color("LinkBlue"))
                    
                }
            }.frame(width: 60, height: 40)
                
                
                
                Spacer()
                HStack {
                    TextHelvetica(content: "Add Exersises", size: 23)
                        .foregroundColor(Color("WhiteFontOne"))
                    TextHelvetica(content: "(10)", size: 23)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                }
                .offset(x: -3)
                
                Spacer()
                
                
                
                Button {
                    viewModel.setPopUpState(state: false, popUpId: "ExersisesPopUp")
                    
                }
                
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight))
                        .foregroundColor(Color("MainGray"))
                    
                    Image("checkMark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 17)
                    
                }
                
                
            }
            .offset(x: -10)
            .frame(width: 60, height: 40)
                
                
                
                
                
                
            }
            .padding(.top, 8)
            .padding(.leading, 8)
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
            
            ZStack {
                TextField("", text: $search, prompt: Text("Search").foregroundColor(Color("GrayFontTwo")))
                // not right font also probably wrong on other things.
                    .keyboardType(.decimalPad)
                    .padding(.leading)
                    .multilineTextAlignment(.leading)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 20))
                    .foregroundColor(Color("WhiteFontOne"))
                    .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
                    .background(.clear)
                    .background(Color("DDB"))
            }
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
               
           
            HStack {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("MainGray"))
                        .frame( height: getScreenBounds().height * 0.045)
                        .background(.clear)
                        .background(Color("DDB"))
                    
                    TextHelvetica(content: "Any Body Part", size: 16)
                }
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("MainGray"))
                        .frame( height: getScreenBounds().height * 0.045)
                        .background(.clear)
                        .background(Color("DDB"))
                    
                    TextHelvetica(content: "Any Category", size: 16)
                }
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
            }
            .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
        }
     
        .frame(width: getScreenBounds().width, height: getScreenBounds().height * 0.89)
        .background(Color("DBblack"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
        .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5)
        .position(x: UIScreen.main.bounds.width/2, y:200)
    }
}


