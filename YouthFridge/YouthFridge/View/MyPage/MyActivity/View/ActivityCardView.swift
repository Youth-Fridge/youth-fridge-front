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
                if let emoji = Emoji.from(rawValue: viewModel.emojiNumber) {
                    let emojiName = emoji.imageName
                    Image(emojiName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 60)
                }
                
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.system(size: 16,weight: .semibold))
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    
                    Text("\(viewModel.date) \(viewModel.startTime)")
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                        .padding(.bottom, 1)
                    Text(viewModel.location)
                        .font(.system(size: 12))
                        .padding(.leading, 10)
                }
                
                Spacer()
                
                Image("division")
                    .padding(.trailing, 11)
                
                Text("D-\(viewModel.daysLeft)")
                    .font(.headline)
                    .foregroundColor(viewModel.isPast ? Color.gray3.opacity(0) : .black)
                    .frame(width: 45)
                    .fixedSize()
                    .padding(.trailing, 5)
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
            if viewModel.isPast {
                AnyView(EmptyView())
            } else {
                AnyView(ActivityDetailView(invitationId: viewModel.invitationId, viewModel: viewModel))
            }
        } else if detail == "application" {
            if viewModel.isPast {
                AnyView(EmptyView())
            } else {
                AnyView(ApplicationDetailView(invitationId: viewModel.invitationId, viewModel: viewModel))
            }
        } else {
            Text("Unknown detail")
                .foregroundColor(.red)
        }
    }
}

//struct ActivityCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let services = Services()
//        let container = DIContainer(services: services)
//        MyActivityView(viewModel: MyPageViewModel(container: container))
//    }
//}
