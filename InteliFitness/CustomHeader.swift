//
//  CustomHeader.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/7/23.
//

import SwiftUI


struct OffsetModifier: ViewModifier {
    let modifierID: String
    @Binding var offset: CGFloat

    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .named(modifierID)).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return Color.clear
                    
                }
            )
    }
}





struct TopBar: View {
    
    var topEdge: CGFloat
    var name: String
    @Binding var offset: CGFloat
    var maxHeight: CGFloat
    var body: some View {


        VStack(alignment: .leading, spacing: 15) {
            HStack {
                TextHelvetica(content: name, size: 40)
                    .foregroundColor(Color("WhiteFontOne"))
                    .bold()
    
                
                Spacer()
            }
            
        }
        .padding()
        .padding(.bottom)
        .opacity(getOpacity())
            

    }
    
    func getOpacity() -> CGFloat {
        let progress = -offset / 70
        
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }

}





struct CustomCorner : Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

struct CustomCornerBorder: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    var lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }

    func strokeBorderPath(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = UIBezierPath(roundedRect: insetRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
