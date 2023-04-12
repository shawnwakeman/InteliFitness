//
//  WorkoutSelectionsSheetView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/10/23.
//

import SwiftUI

struct DropDownMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    @State private var exersiseNotes: String = ""
    var body: some View {
        // Add a blur effect to the background
   
        VStack(spacing: borderWeight) {
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(Color("DBblack"))
                
                VStack {
                    Button {
                
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            TextHelvetica(content: "Settings", size: 17)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
                        .aspectRatio(8/1, contentMode: .fit)
                        .padding([.top, .leading, .trailing])
                    }

                    HStack {
                        
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                            
                                    .foregroundColor(Color("MainRed"))
                                TextHelvetica(content: "Cancel", size: 16)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                            
                            
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                    .foregroundColor(Color("MainGray"))
                                
                                TextHelvetica(content: "Pause", size: 16)
                                
                            }
                        }
                            
                            
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Color("LinkBlue"))
                                TextHelvetica(content: "Finish", size: 16)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                    }
                    .aspectRatio(8/1, contentMode: .fit)
                    .padding([.leading, .trailing])
                    
                    HStack {



              

                            
                            
                     
                        TextField("", text: $exersiseNotes, prompt: Text("Enter notes about your workout here. Your notes will be be displayed every time you do this exercise.").foregroundColor(Color("GrayFontTwo")), axis: .vertical)
                            .lineLimit(3...5)
                            .padding(.all, 5)
                            .font(.custom("SpaceGrotesk-Medium", size: 16))
                            .foregroundColor(Color("WhiteFontOne"))

                            


                        
                    }
                    .background(Color("DDB"))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    )
                        .aspectRatio(7/1, contentMode: .fit)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 5)
                    HStack {
                        TimerFullSize()
                            .background(Color("DDB"))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                            )
                        
                        VStack {
                          
                            HStack {
                                
                                TextHelvetica(content: "Exersise Metrics", size: 20)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .padding([.leading,.top], 10)
                                
                                Spacer()
                            }
                            Divider()
                            
                                .frame(height: borderWeight)
                                .overlay(Color("BorderGray"))
                            DisplayRow(metric: "Total Volume", value: "1203 lbs")
                            DisplayRow(metric: "Total Reps", value: "120")
                            DisplayRow(metric: "Weight/Set", value: "142.2 lbs")
                            DisplayRow(metric: "Reps/Set", value: "12.2")
                            DisplayRow(metric: "PR Sets", value: "3/8")
                        }
                        .background(Color("DBblack"))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                        )
                            
                          
                           
                            
                
                    }
                    
                    .padding([.leading, .trailing, .bottom])
                }
                
            }

               
            ZStack {
                Rectangle()
                    .foregroundColor(Color("MainGray"))
                .aspectRatio(3.3, contentMode: .fit)
                
                HStack {
                    ZStack{
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("DBblack"))
                            
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            
                        }
                        
                        
                        
                        HStack{
                            Image(systemName: "clock")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                        
                            TextHelvetica(content: "1:23", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                
                        }
                        
                        
                    }
                    .aspectRatio(2.5, contentMode: .fit)
                    .padding(.leading, 25)
                   
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.clear)
                        .padding(.horizontal, 50)
                    
                    ProgressBar()
                        .aspectRatio(5, contentMode: .fit)
                        .padding(.trailing,25)
         
                 
                }
                WorkoutTimer(viewModel: viewModel, fontSize: 20)
   
                    .foregroundColor(Color("GrayFontOne"))
                    .padding(.horizontal, 50)
            }
            
            
        }
            


        .frame(maxHeight: 570)

        .background(Color("BorderGray"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
        .position(x: UIScreen.main.bounds.width/2, y:200)
//        .position(x: UIScreen.main.bounds.width/2, y:-80)
        
            
        


            
    }
    
    struct DisplayRow: View {
        var metric: String
        var value: String
        var body: some View {
            HStack{
               
                TextHelvetica(content: metric, size: 15)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                
                TextHelvetica(content: value, size: 14)
                    .foregroundColor(Color("WhiteFontOne"))
            }
            .padding(.horizontal)
            .frame(maxHeight: 11)
            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
        }
    }
}

 
struct TimerFullSize : View {
    
    @State var start = true
    @State var to : CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        
        ZStack{
            
            Color.black.opacity(0.0)
            
            VStack{
                
                ZStack{
                    
                    Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                  
                    
                    Circle()
                        .trim(from: 0, to: self.to)
                        .stroke(Color("LinkBlue"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
         
                    .rotationEffect(.init(degrees: -90))
                    
                    
                    VStack{
                        
                        Text("\(self.count)")
                            .font(.system(size: 25))
                            .foregroundColor(Color("WhiteFontOne"))
                            .fontWeight(.bold)
                        
                        Text("15")
                            .font(.system(size: 25))
                            .foregroundColor(Color("GrayFontOne"))
                            .fontWeight(.bold)
                        
                    }
                }
                


                
  
                Button {
            
                }
                label: {
                    ZStack{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("BlueOverlay"))

                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

              
                             
                            
                        }


                        TextHelvetica(content: "Set Rest Time", size: 16)
                            .padding(.all, 7)
                            .foregroundColor(Color(.white))
                    }
                    .aspectRatio(8/1, contentMode: .fit)
                  
                }

     
            }.padding(.all)
            
        }
        .onReceive(self.time) { (_) in
            
            if self.start{
                
                if self.count != 15{
                    
                    self.count += 1
                    print("hello")
                    
                    withAnimation(.default){
                        
                        self.to = CGFloat(self.count) / 15
                    }
                }
                else{
                
                    self.start.toggle()
                
                }

            }
            
        }.background(Color("MainGray"))
    }
    
}
