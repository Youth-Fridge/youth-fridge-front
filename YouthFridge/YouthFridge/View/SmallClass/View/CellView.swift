//
//  CellView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI

struct CellView: View {
    let cell: CellModel
    
    var body: some View {
        HStack {
            Image(cell.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(cell.title)
                    .font(.headline)
                Text(cell.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(cell.tag)
                    .font(.caption)
                    .padding(.top, 2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.gray1Color)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}


