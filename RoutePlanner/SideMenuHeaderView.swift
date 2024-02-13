//
//  SideMenuHeaderView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/10/24.
//

import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("John Wick")
                    .font(.headline)
                
                Text("john.wick@gmail.com")
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
