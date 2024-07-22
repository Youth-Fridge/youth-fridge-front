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
                            .scaledToFill()
                            .frame(width: 100,height: 110)
                            .clipped()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(cell.title)
                        .font(.system(size: 16,weight: .bold))
                        .padding()
                    Spacer()
                    Text(cell.ing)
                        .font(.system(size: 12,weight: .bold))
                        .padding(.horizontal,10)
                        .padding(.vertical, 4)
                        .background(Color.main1Color)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
                
                Spacer()
                HStack {
                    Text(cell.tag)
                        .font(.system(size: 12,weight: .semibold))
                        .padding(.top, 2)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 4)
                        .background(Color.sub2Color)
                        .cornerRadius(12)
                    Spacer()
                    Text(cell.numberOfPeople)
                        .font(.system(size: 14,weight: .medium))
                }
                .padding()
            }
            
            Spacer()
        }
        .background(Color.gray1Color)
        .padding(.horizontal)
        .frame(height: 100)
    }
}


