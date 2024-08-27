//
//  MyInvitationsView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyInvitationsView: View {
    @ObservedObject var viewModel: MyInvitationsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            } else if viewModel.invitationActivities.isEmpty {
                VStack {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                    Text("소모임을 운영하는 호스트가 되어봐요 :)")
                        .foregroundColor(.gray3)
                        .font(.pretendardRegular18)
                        .multilineTextAlignment(.center)
                }
            } else {
                ForEach(viewModel.invitationActivities) { activity in
                    ActivityCardView(viewModel: activity, detail: "invitation")
                        .disabled(activity.isPast)
                }
            }
        }
        .padding()
    }
}
