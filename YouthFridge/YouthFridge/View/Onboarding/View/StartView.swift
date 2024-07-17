//
//  StartView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width:96,height: 96)
            Image("typelogo")
                .resizable()
                .frame(width: 140,height: 26)
            Text("만나서 반가워요")
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top)
            Text("든든히 한 끼 함께 해요!")
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
            
           
                
        }
    }
}

#Preview {
    StartView()
}
