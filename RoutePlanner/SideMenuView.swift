//
//  SideMenuView.swift
//  RoutePlanner
//
//  Created by Khanh Chung on 2/10/24.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedOption: SideMenuOptionModel?
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        SideMenuHeaderView()
                        VStack(alignment: .leading) {
                            ForEach(SideMenuOptionModel.allCases) { option in
                                if option == .settings {
                                    Spacer()
                                }
                                Button(action: {
                                    selectedOption = option
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }
                        LogoutSideMenuRowView()
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)

                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
