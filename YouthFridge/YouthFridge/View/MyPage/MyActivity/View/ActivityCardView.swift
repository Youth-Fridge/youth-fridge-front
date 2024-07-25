//
//  ActivityCardView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ActivityCardView: View {
    @ObservedObject var viewModel: ActivityCardViewModel
    var detail: String
    
    var body: some View {
        NavigationLink(destination: destinationView()) {
            HStack {
                Image(viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 60)
                
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.system(size: 16,weight: .semibold))
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    Text(viewModel.date)
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                        .padding(.bottom, 1)
                    Text(viewModel.location)
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                }
                
                Spacer()
                
                Image("division")
                    .padding(.trailing, 20)
                
                Text("D-\(viewModel.daysLeft)")
                    .font(.headline)
                    .foregroundColor(viewModel.isPast ? Color.gray3.opacity(0) : .black)
                    .fixedSize()
                    .padding(.trailing, 10)
            }
            .padding()
            .background(viewModel.isPast ? Color.gray3.opacity(0.6) : Color.white)
            .overlay(
                ZStack {
                    if viewModel.isPast {
                        Color.gray2.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .padding(.horizontal, -20)
                    }
                }
            )
            .cornerRadius(4)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if detail == "invitation" {
            ActivityDetailView(viewModel: viewModel)
        } else if detail == "application" {
            ApplicationDetailView(viewModel: viewModel)
        } else {
            Text("Unknown detail")
                .foregroundColor(.red)
        }
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        MyActivityView(viewModel: MyPageViewModel(container: container))
    }
}
