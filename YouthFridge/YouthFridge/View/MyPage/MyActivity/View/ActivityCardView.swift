//
//  ActivityCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ActivityCardView: View {
    @ObservedObject var viewModel: ActivityCardViewModel
    
    var body: some View {
        NavigationLink(destination: ActivityDetail(viewModel: viewModel)) {
                    HStack {
                Image(viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 60)
                
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.system(size: 16,weight: .semibold))
                        .padding(.leading,20)
                        .padding(.bottom,5)
                    Text(viewModel.date)
                        .font(.system(size: 12))
                        .padding(.leading,20)
                    Text(viewModel.location)
                        .font(.system(size: 12))
                        .padding(.leading,20)
                }
                
                Spacer()
                Divider().frame(width: 1, height: 60).background(Color.gray.opacity(0.5))
                    .padding(.trailing, 10)
                
                Text("D-\(viewModel.daysLeft)")
                    .font(.headline)
                    .foregroundColor(viewModel.isPast ? .gray2 : .black)
            }
            .padding()
            .background(viewModel.isPast ? Color.gray.opacity(0.2) : Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

