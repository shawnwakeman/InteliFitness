//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: -20){
                CoreLogModule()
                RoundedRectangle(cornerRadius: 7)
                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fit)
                    .foregroundColor(.clear)
                    .strokeBorder(, antialiased: <#T##Bool#>)
            }
            
            
        }
        
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

            TextHelvetica(content: String(SetReps), size: 24)
                .padding()
                .frame(width: 75, height: 40)
                .background(.clear)

            Divider()
                .frame(width: 2.5)
                .overlay(.black)
            Image(systemName: "checkmark")
                .padding()
                .frame(maxWidth: 40, maxHeight: 40)
                .background(.clear)
                
        }
        
    }
}


struct ContentGrid: View {
    var body: some View{
        Row(setNumber: 1, prevouisSet: "135 lb x 62", setWeight: 23, SetReps: 121)
        Divider()
            .frame(height: 2.5)
            .overlay(.black)
        Row(setNumber: 2, prevouisSet: "135 lb x 6", setWeight: 123, SetReps: 12)
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
                .aspectRatio(7/1, contentMode: .fill)
            
            HStack{
                Spacer()
                TextHelvetica(content: "Set", size: 27)
                    .padding(.trailing)
          
                TextHelvetica(content: "Previous", size: 27)
                    .padding(.trailing, 25)
                
                TextHelvetica(content: "Lbs", size: 27)
                    .padding(.trailing)

                TextHelvetica(content: "Reps", size: 27)
                    .padding(.trailing, 25.0)
                Spacer()
            }
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
