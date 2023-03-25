//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    let gridItems = [
        GridItem(.fixed(100.0), spacing: 10.0, alignment: .top),
        GridItem(.fixed(250.0), spacing: 30.0, alignment: .center),
        GridItem(.fixed(150.0), spacing: 10.0, alignment: .bottomTrailing),
    ]

    var body: some View {
        ScrollView{
            ZStack(){
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2.5)
                    .background(Color.clear)
                


                VStack(alignment: .leading, spacing: 0){
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2.5)
                        .aspectRatio(7/1, contentMode: .fit)
                    

                    HStack {
                        VStack{
                            Text("1")
                                .font(.system(size: 36))
                            Text("2")
                                .font(.system(size: 36))
                            Text("3")
                                .font(.system(size: 36))
                            Text("4")
                                .font(.system(size: 36))
                                
                        }.padding(.leading, 11.0)
                        
                        VStack{
                            Text("135 lb x 10")
                                .font(.system(size: 20))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))

                        }.padding(.leading)
                        
                        VStack{
                            Text("123")
                                .font(.system(size: 25))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))

                                
                        }.padding(.leading)
                        
                        VStack{
                            Text("12....")
                                .font(.system(size: 25))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
 
                        }.padding(.leading)
                        VStack{
                            Text("12.")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))
                            Text("12")
                                .font(.system(size: 36))

                        }.padding(.leading)
                        
                        
                    }
                   
                    
                    
                }
            }
            .padding(.all)
            
        }
    }
}

struct Container: Shape {
    func path(in rect: CGRect) -> Path {
        // Create a rectangular path that matches the size of your container
        Path(rect)
    }
}

struct exersiseContainer: View {

    var body: some View{
        let shape = RoundedRectangle(cornerRadius: 19)
        ZStack {
            shape.foregroundColor(Color(red: 0.052, green: 0.067, blue: 0.088))
            shape.strokeBorder(lineWidth: 2.5).foregroundColor(Color(red: 0.154, green: 0.169, blue: 0.194))
        }



        
    }
}

struct header: View {

   
    var body: some View{
        let shape = Rectangle()
        ZStack {
            shape.foregroundColor(Color(red: 1, green: 0.067, blue: 0.088))
            shape.strokeBorder(lineWidth: 2.5).foregroundColor(Color(red: 0.154, green: 0.169, blue: 0.194))
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
