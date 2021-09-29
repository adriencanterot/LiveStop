//
//  LineBadge.swift
//  LineBadge
//
//  Created by Adrien Cantérot on 08/09/2021.
//

import SwiftUI

struct LineBadge: View {
    
    var number: String
    var tint: Color
    
    var body: some View {
        
        Text(number)
            .bold()
            .frame(width: 25, height: 20)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .foregroundColor(tint))
    }
}

struct LineBadge_Previews: PreviewProvider {
    static var previews: some View {
        LineBadge(number: "11", tint: .blue)

            
    }
}
