//
//  AddInviteView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/17/24.
//

import Foundation
import SwiftUI

struct AddInviteView: View {
    var body: some View {
        HStack {
            Image("plus-circle")
                .resizable()
                .frame(width: 28,height: 28)
                .padding(.leading,15)
            Text("초대장 만들기")
                .font(.system(size: 20,weight: .bold))
            Spacer()
            Image("plus_letter")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
                .padding(.top,19)
        }
        .background(Color.sub2Color)
        .frame(maxWidth: .infinity, maxHeight: 100)
        .cornerRadius(0)
    }
}
