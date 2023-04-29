//
//  exercisePage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/28/23.
//

import SwiftUI

enum Page {
    case page1, page2, page3, page4
}

struct ExercisePage: View {
    @State private var selectedPage: Page = .page1



    var body: some View {
        VStack {
            HStack {
                Button {
                  
                   
                    
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
                
                
                Spacer()
                TextHelvetica(content: "Exersise Metrics", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                Button {
                   
                }
                label: {
                    TextHelvetica(content: "Save", size: 21)
                        .foregroundColor(Color("LinkBlue"))
                }
               
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            
            
            Picker("Pages", selection: $selectedPage) {
                Text("About").tag(Page.page1)
                Text("History").tag(Page.page2)
                Text("Data").tag(Page.page3)
                Text("Records").tag(Page.page4)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
            switch selectedPage {
            case .page1:
                Page1View()
            case .page2:
                Page2View()
            case .page3:
                Page3View()
            case .page4:
                Page4View()
            }

            Spacer()
        }
        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.8)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .navigationBarItems(
            trailing: Button(action: {
                print("Save button tapped")
            }) {
                Text("Save")
            }
        )
    }
}



struct Page1View: View {
    var body: some View {
        Text("Page 1 Content")
    }
}

struct Page2View: View {
    var body: some View {
        Text("Page 2 Content")
    }
}

struct Page3View: View {
    var body: some View {
        Text("Page 3 Content")
    }
}

struct Page4View: View {
    var body: some View {
        Text("Page 4 Content")
    }
}
