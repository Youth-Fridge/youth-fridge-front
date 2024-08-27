//
//  ApplicationHistoryView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import SwiftUI

struct ApplicationHistoryView: View {
    @ObservedObject var viewModel: MyApplicationViewModel

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
            } else if viewModel.applicatedActivities.isEmpty {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                Text("참여 중인 소모임이 없어요")
                    .foregroundColor(.gray3)
                    .font(.pretendardRegular18)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(viewModel.applicatedActivities) { activity in
                    ActivityCardView(viewModel: activity, detail: "application")
                        .disabled(activity.isPast)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3))
                }
            }
        }
        .padding()
    }
}
