//
//  LogoutSideMenuRowView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/10/24.
//

import SwiftUI

struct LogoutSideMenuRowView: View {
    var body: some View {
        HStack {
            Image(systemName: "rectangle.portrait.and.arrow.forward")
            Text("Logout").font(.headline)
            Spacer()
        }
        .padding(.leading)
        .frame(width: 215, height: 45)
        .background(.red.opacity(0.8))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LogoutSideMenuRowView()
}
