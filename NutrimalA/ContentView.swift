//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI
var borderWeight: CGFloat = 1.7
struct ContentView: View {
    @State var progressValue: Float = 0.5

    var body: some View {
        
        ScrollView(.vertical){
            
            
            MainHeaderForLog()
            
            VStack(spacing: -20){
                
                LogModuleHeader()
                CoreLogModule()
                FullWidthButton()
                
                
                
                
            }
            
            
        }.background(Color("DBblack"))
        
    }
    
    init() {
        for famliyName in UIFont.familyNames {
            print(famliyName)
            for fontName in UIFont.fontNames(forFamilyName: famliyName){
                print(fontName)
            }
                   
        }
    }
    
}

struct MainHeaderForLog: View {
    var body: some View {
        ZStack{
            
            
            
           
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color("MainGray"))
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
            }

            
            Rectangle()
            
                .size(width:430, height: 1000)
                .offset(y:-950)
                .foregroundColor(Color("MainGray"))
            
//                )
                

            


            HStack(alignment: .top){
                Spacer()
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
                        TextHelvetica(content: "1:23", size: 23)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                    
                    
                }
                .padding(.bottom)
                .frame(maxWidth: 110, maxHeight: 55)
                
                Divider().frame(width: 120)
                    .opacity(0)
                
                
                
                
                
                
                
                VStack(alignment: .center) {
                    ProgressBar().frame(height: 20)
                    Spacer()
                }
                .padding([.top, .leading, .bottom])
                .padding(.trailing, 4)
                .offset(y:-5)
                .frame(maxWidth: 150)
                
            }
            .padding(.all, 21.0)
            
            TextHelvetica(content: "0:12", size: 25)
                .padding(.bottom, 17.0)
                .foregroundColor(Color("WhiteFontOne"))
        }.offset(x:0, y: -19)
    }
}

struct ProgressBar: View {

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                    
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color("DBblack"))
                    .cornerRadius(45.0)
                    

    
               
                
                Rectangle().frame(width: min(CGFloat(0.5)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .cornerRadius(45)
                
                Capsule()
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
            }
        }
    }
}

struct FullWidthButton: View{
    var body: some View{
        ZStack{
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("BlueOverlay"))
                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("BlueOverlayBorder"), lineWidth: borderWeight)

                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
            }


            TextHelvetica(content: "add exersise", size: 20)
                .foregroundColor(Color(.white))
        }.padding(.top,-2)
    }
    
}
struct LogModuleHeader: View{
    var body: some View{
        HStack{
            Button {
                print("Button pressed")
            }
            
            label: {
                TextHelvetica(content: "Back Squat", size: 32)
                    .foregroundColor(Color("LinkBlue"))
            }

            Spacer()
            
            
            Button {
                print("Button pressed")
            }
            
            label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color("LinkBlue"))

                    TextHelvetica(content: "add set", size: 20)
                        .foregroundColor(Color(.white))
                }
            }.frame(maxWidth: 100, maxHeight: 28)
            
            
            Image("dataIcon")
                .resizable()
                .frame(width: 39.4, height: 28)
            
            Image("meatBalls")
                .resizable()
                .frame(width: 39.4, height: 28)
            
        }
        .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
        .padding(.bottom, 9)
    }
}

struct CoreLogModule: View {
    var body: some View{
        ZStack(){
            
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                .background(Color.clear)
                .zIndex(1)
            
            
            
            
            VStack(alignment: .leading, spacing: 0){
                Header()
                ContentGrid()
                
            }
            
        }
        .padding(.all)
    }
}

struct TextHelvetica: View{
    var content: String
    var size: CGFloat
    var body: some View
    {
        Text(content).font(.custom("HelveticaNeue-Medium", size: size)).multilineTextAlignment(.center)
    }
}


struct Row: View{
    var setNumber: Int
    var prevouisSet: String
    var setWeight: Int
    var SetReps: Int
    var body: some View{

        HStack(spacing: 0){
            TextHelvetica(content: String(setNumber), size: 24)
                .padding()
                .frame(width: 55, height: 40)
                .foregroundColor(Color("LinkBlue"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
           
            TextHelvetica(content: prevouisSet, size: 24)
                .frame(width: 145, height: 40)
                .foregroundColor(Color("GrayFontOne"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            TextHelvetica(content: String(setWeight), size: 24)
                .frame(width: 70, height: 40.0)
                .foregroundColor(Color("WhiteFontOne"))
                .background(Color("DDB"))
                
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            HStack{
                

               
                TextHelvetica(content: String(SetReps), size: 24)
                   
                    .frame(maxWidth: 30)
                    .foregroundColor(Color("WhiteFontOne"))
                    
                    
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: 35)
                        
                        Capsule()
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            .padding(.vertical, 9.0)
                            
                            
                            .frame(width: 35)
                    }
                    
                    TextHelvetica(content: "10", size: 14)
                        .foregroundColor(Color.white)
                        
                }

                    
            }.frame(width: 80, height: 40)
            .background(Color("DDB"))


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            

            
            Image("checkMark")
                .resizable()
                .padding(9.0)
                .aspectRatio(40/37, contentMode: .fit)
                .background(.clear)
                
        }
        
    }
}


struct ContentGrid: View {
    var body: some View{
        Row(setNumber: 1, prevouisSet: "135 lb x 62", setWeight: 23, SetReps: 10)
        Divider()
            
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            
        Row(setNumber: 2, prevouisSet: "135 lb x 6", setWeight: 123, SetReps: 6)
        Divider()
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))

        
        Row(setNumber: 3, prevouisSet: "135 lb x 62", setWeight: 123, SetReps: 12)
        Divider()
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
        
        Row(setNumber: 4, prevouisSet: "135 lb x 16", setWeight: 123, SetReps: 12)
    }
}



struct Header: View {
    var body: some View{
        ZStack{
            Rectangle()
                .cornerRadius(4, corners: [.topLeft, .topRight])
                .foregroundColor(Color("MainGray"))
                .aspectRatio(7.3/1, contentMode: .fill)
            VStack{
                HStack{
                    Spacer()
                    TextHelvetica(content: "Set", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x: -2)
                    Spacer()
              
                    TextHelvetica(content: "Previous", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    TextHelvetica(content: "Lbs", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:5)
                    Spacer()

                    TextHelvetica(content: "Reps", size: 27)
                        .padding(.trailing)
                        .foregroundColor(Color("WhiteFontOne"))
                
                    Spacer()
                }.offset(x: -13,y: 0)
                
                
         
            }

        }
        Rectangle()
            .frame(height: borderWeight)
            .foregroundColor(Color("BorderGray"))
            
    }
}


























extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
