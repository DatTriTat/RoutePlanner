//
//  SideMenuRowView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/10/24.
//

import SwiftUI

struct SideMenuRowView: View {
    let option: SideMenuOptionModel
    @Binding var selectedOption: SideMenuOptionModel?
    
    private var isSelected: Bool {
        selectedOption == option
    }
    
    var body: some View {
        HStack {
            Image(systemName: option.systemImageName)
            Text(option.title)
                .font(.headline)
            Spacer()
        }
        .padding(.leading)
        .foregroundColor(isSelected ? .blue : .primary)
        .frame(width: 215, height: 45)
        .background(isSelected ? .blue.opacity(0.15) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SideMenuRowView(option: .home, selectedOption: .constant(.home))
}
