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
            ZStack(){
                
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.black, lineWidth: 2.5)
                    .background(Color.clear)
                
                
               
                
                VStack(alignment: .leading, spacing: 0){
                    ZStack{
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2.5)
                            .aspectRatio(7/1, contentMode: .fill)
                        
                        HStack{
                            Text("Set").offset(CGSize(width: 5, height: 0))
                                //.font(.custom(<#T##name: String##String#>, size: <#T##CGFloat#>))
                            Spacer()
                            Text("Previous").offset(CGSize(width: 10, height: 0))
                            Spacer()
                            Text("Lbs").offset(CGSize(width: 15, height: 0))
                            Spacer()
                            Text("Reps").offset(CGSize(width: 7, height: 0))
                            Spacer()
                        }.padding(.all)
                    }

                    
                  
                    
                    row(setNumber: 1, prevouisSet: "135 lb x 61", setWeight: 23, SetReps: 121)
                    Divider()
                        .frame(height: 2.5)
                        .overlay(.black)
                    row(setNumber: 1, prevouisSet: "135 lb x 6", setWeight: 123, SetReps: 12)
                    Divider()
                        .frame(height: 2.5)
                        .overlay(.black)

                    row(setNumber: 1, prevouisSet: "135 lb x 6", setWeight: 123, SetReps: 12)
                    Divider()
                        .frame(height: 2.5)
                        .overlay(.black)
                    
                    row(setNumber: 1, prevouisSet: "135 lb x 16", setWeight: 123, SetReps: 12)
                    
                }
            } .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}



struct row: View{
    var setNumber: Int
    var prevouisSet: String
    var setWeight: Int
    var SetReps: Int
    var body: some View{
        let verticalBorderRect = Rectangle().frame(maxWidth: 2.5, maxHeight: .infinity)
        HStack(spacing: 0){
            Text(String(setNumber))
                .padding()
                .frame(width: 60, height: 40)
                .background(.clear)
            verticalBorderRect
            Text(prevouisSet)
                .padding()
                .frame(width: 140, height: 40)
                .background(.clear)
            verticalBorderRect
            Text(String(setWeight))
                .padding()
                .frame(width: 75, height: 40)
                .background(.clear)
            verticalBorderRect

            Text(String(SetReps))
                .padding()
                .frame(width: 75, height: 40)
                .background(.clear)

            verticalBorderRect
            Image(systemName: "checkmark")
                .padding()
                .frame(maxWidth: 40, maxHeight: 40)
                .background(.clear)
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



//
//
//    HStack {
//        Text("This is a short string.")
//            .padding()
//            .frame(maxHeight: .infinity)
//            .background(.red)
//
//        Text("This is a very long string with lots and lots of text that will definitely run across multiple lines because it's just so long.")
//            .padding()
//            .frame(maxHeight: .infinity)
//            .background(.green)
//    }
//    .fixedSize(horizontal: false, vertical: true)
//    .frame(maxHeight: 200)
//
//}
//
//
//












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
