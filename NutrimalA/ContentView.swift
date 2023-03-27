//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI

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
            
            Rectangle().frame(height: 100.0).offset(x:0,y:-60)
                .foregroundColor(Color("MainGray"))
            
            
           
            RoundedRectangle(cornerRadius: 26)
                .padding(-4.0)
                .frame(height: 40)
                
                .foregroundColor(Color("MainGray"))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(.blue, lineWidth: 1)
//                )
                

            
            Rectangle().frame(height: 100.0).offset(x:0,y:-45)
                .foregroundColor(Color("MainGray"))

            HStack(alignment: .top){
                Spacer()
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color("DBblack"))
                        
                   
                    HStack{
                        Image(systemName: "clock")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                            .bold()
                        TextHelvetica(content: "1:23", size: 23)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                        
                    
                }
                .padding(.bottom)
                .frame(maxWidth: 110, maxHeight: 55)
                
                Divider().frame(width: 120)
                Spacer()
                
                
               
                
                VStack(alignment: .center) {
                    ProgressBar().frame(height: 20)
                    Spacer()
                }
                .padding([.top, .leading, .bottom])
                .padding(.trailing, 4)
                .offset(y:-5)
                .frame(maxWidth: 150)
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all, 21.0/*@END_MENU_TOKEN@*/)
            
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
            }
        }
    }
}

struct FullWidthButton: View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(lineWidth: 2.5)
                .foregroundColor(.black)
                .padding(.all, 14.0)
                .aspectRatio(7/1, contentMode: .fill)
            TextHelvetica(content: "add exersise", size: 20)
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
                TextHelvetica(content: "Back Squat", size: 28)
            }

            Spacer()
            
            
            Button {
                print("Button pressed")
            }
            
            label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                    TextHelvetica(content: "add set", size: 20)
                        .colorInvert()
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
                .stroke(Color.black, lineWidth: 2.5)
                .background(Color.clear)
            
            
            
            
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
                .background(.clear)
            Divider()
                .frame(width: 2.5)
                .overlay(.black)
            TextHelvetica(content: prevouisSet, size: 24)
                .frame(width: 145, height: 40)
                .background(.clear)
            Divider()
                .frame(width: 2.5)
                .overlay(.black)
            TextHelvetica(content: String(setWeight), size: 24)
            
                .frame(width: 70, height: 40)
                .background(.clear)
            Divider()
                .frame(width: 2.5)
                .overlay(.black)
            HStack{
                

               
                TextHelvetica(content: String(SetReps), size: 24)
                    .background(.clear)
                    .frame(maxWidth: 30)
                    
                ZStack{
                    
                    Capsule()
                        .padding(.vertical, 11.0)
                        .foregroundColor(.blue)
                        .frame(width: 25)
                    TextHelvetica(content: "10", size: 16)
                        
                }

                    
            }.frame(width: 75, height: 40)


            Divider()
                .frame(width: 2.5)
                .overlay(.black)
            
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
            .frame(height: 2.5)
            .overlay(.black)
        Row(setNumber: 2, prevouisSet: "135 lb x 6", setWeight: 123, SetReps: 6)
        Divider()
            .frame(height: 2.5)
            .overlay(.black)
        
        Row(setNumber: 3, prevouisSet: "135 lb x 62", setWeight: 123, SetReps: 12)
        Divider()
            .frame(height: 2.5)
            .overlay(.black)
        
        Row(setNumber: 4, prevouisSet: "135 lb x 16", setWeight: 123, SetReps: 12)
    }
}



struct Header: View {
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.black, lineWidth: 2.5)
                .aspectRatio(7.3/1, contentMode: .fill)
            
            HStack{
                Spacer()
                TextHelvetica(content: "Set", size: 27)
                Spacer()
          
                TextHelvetica(content: "Previous", size: 27)
                Spacer()
                
                TextHelvetica(content: "Lbs", size: 27)
                Spacer()

                TextHelvetica(content: "Reps", size: 27)
                    
                Spacer()
            }.offset(x: -17,y: 0)
        }
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
