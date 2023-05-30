//
//  TextStyle.swift
//  FlowerID
//
//  Created by Audrey on 22/05/23.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 5)
    }
}

struct BodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(TitleModifier())
    }
}
    
extension View {
    func bodyStyle() -> some View {
        modifier(BodyModifier())
    }
}


struct TextStyle: View {
    var body: some View {
        VStack{
            Text("Hello, World!")
                .titleStyle()
            Text("Hello, World!")
                .bodyStyle()
        }
    }
}

struct TextStyle_Previews: PreviewProvider {
    static var previews: some View {
        TextStyle()
    }
}
