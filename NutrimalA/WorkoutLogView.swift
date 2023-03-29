//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI
var borderWeight: CGFloat = 1.7
struct WorkoutLogView: View {
    @State var progressValue: Float = 0.5


    var body: some View {
        
        ScrollView(.vertical){
            
            
            DropDownHeaderView()
            
            
            
            VStack(spacing: -20){
                
                LogModuleHeader()
                CoreLogModule()
                FullWidthButton()
                
                
                
                
            }
            
            
        }.background(Color("DBblack"))
        
    }
    
//    init() {
//        for famliyName in UIFont.familyNames {
//            print(famliyName)
//            for fontName in UIFont.fontNames(forFamilyName: famliyName){
//                print(fontName)
//            }
//
//        }
//    }
    
}

struct DropDownHeaderView: View {
    var body: some View {
        ZStack{
            
            
            
           
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color("MainGray"))
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
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
                        TextHelvetica(content: "1:23", size: 20)
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
            
            TextHelvetica(content: "0:12", size: 20)
                .padding(.bottom, 17.0)
                .foregroundColor(Color("GrayFontOne"))
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
            
            Button {print("Button pressed")}
            label: {
                TextHelvetica(content: "Back Squat", size: 28)
                    .foregroundColor(Color("LinkBlue"))
            }

            Spacer()
            
            
            Button {print("Button pressed")}
            
            label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color("LinkBlue"))

                    TextHelvetica(content: "add set", size: 20)
                        .foregroundColor(Color(.white))
                }
            }.frame(maxWidth: 100, maxHeight: 28)
            
            ZStack{
                Image("dataIcon")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .frame(width: 39.4, height: 28)
            }

            ZStack{
                
                Image("meatBalls")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                RoundedRectangle(cornerRadius: 3)
                
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .frame(width: 39.4, height: 28)
            }

                
            
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


struct WorkoutSetRowView: View{
    var setNumber: Int
    var previousSet: String
    var setWeight: Int
    var SetReps: Int
    @State private var givenName: String = ""
    @State private var familyName: String = ""

    var body: some View{

        HStack(spacing: 0){
            TextHelvetica(content: String(setNumber), size: 21)
                .padding()
                .frame(width: 55, height: 40)
                .foregroundColor(Color("LinkBlue"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
           
            TextHelvetica(content: previousSet, size: 21)
                .frame(width: 145, height: 40)
                .foregroundColor(Color("GrayFontOne"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
   


//            ZStack {
//
//                if familyName.isEmpty {
//                    Text("13")
//                        .foregroundColor(Color("GrayFontOne"))
//                        .font(.custom("HelveticaNeue-Medium", size: 21))
//
//                }
//
//                TextField("", text: $familyName)
//                    .font(.custom("HelveticaNeue-Medium", size: 21))
//                    .foregroundColor(Color("WhiteFontOne"))
//            }
//            .frame(width: 70, height: 40)
//            .background(Color("DDB"))
//
////
//

//                if givenName.isEmpty {
//                    Text("")
//                        .foregroundColor(Color("GrayFontOne"))
//                        .font(.custom("HelveticaNeue-Medium", size: 21))
//
//                }
            
//
            ZStack{
                
                TextField("123", text: $givenName)
                    .font(.custom("HelveticaNeue-Medium", size: 21))
                    
                    .foregroundColor(Color(red: 0.2713462753, green: 0.2713462753, blue: 0.2713462753))
                    .blendMode(.darken)
                    
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 40)
                    .background(.clear)
                    .colorInvert()
                    .accentColor(.orange)
                 
                    
            }.background(Color("DDB"))
                

//
//
//
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            HStack{
                

               
                ZStack{
                    
                    TextField("12", text: $givenName)
                        .font(.custom("HelveticaNeue-Medium", size: 21))
                        
                        .foregroundColor(Color(red: 0.2713462753, green: 0.2713462753, blue: 0.2713462753))
                        .blendMode(.darken)
                        
                        .multilineTextAlignment(.center)
                        .frame(width: 25, height: 40)
                        .background(.clear)
                        .colorInvert()
                        .accentColor(.orange)
                     
                        
                }.background(Color("DDB"))
                    
                    
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: 30)
                        
                        Capsule()
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            .padding(.vertical, 9.0)
                            
                            
                            .frame(width: 30)
                    }
                    
                    TextHelvetica(content: "10", size: 13)
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

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct ContentGrid: View {
    var body: some View{
        WorkoutSetRowView(setNumber: 1, previousSet: "135 lb x 62", setWeight: 23, SetReps: 10)
        Divider()
            
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            
        WorkoutSetRowView(setNumber: 2, previousSet: "135 lb x 6", setWeight: 123, SetReps: 6)
        Divider()
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))

        
        WorkoutSetRowView(setNumber: 3, previousSet: "135 lb x 62", setWeight: 123, SetReps: 12)
        Divider()
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
        
        WorkoutSetRowView(setNumber: 4, previousSet: "135 lb x 16", setWeight: 123, SetReps: 12)
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
                    TextHelvetica(content: "Set", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x: -2)
                    Spacer()
              
                    TextHelvetica(content: "Previous", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    TextHelvetica(content: "Lbs", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:5)
                    Spacer()

                    TextHelvetica(content: "Reps", size: 24)
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
        WorkoutLogView()
    }
}
