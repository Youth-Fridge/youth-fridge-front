//
//  CellView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/20/24.
//

import SwiftUI

struct CellView: View {
    let cell: CellModel
    
    private var backgroundColor: Color {
        cell.ing == "모집 완료" ? Color.gray7 : Color.main1
    }
    
    var body: some View {
        HStack {
            Image(cell.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 110)
                .clipped()
                .padding(.leading,-10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(cell.title)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                    Spacer()
                    Text(cell.ing)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(backgroundColor)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack {
                    ForEach(cell.tag, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.top, 2)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 4)
                            .background(Color.sub2Color)
                            .cornerRadius(12)
                    }
                    Spacer()
                    Text(cell.numberOfPeople)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.trailing,-10)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(height: 110)
        .background(Color.gray1Color)
        .padding(.horizontal)
    }
}
