//
//  ApplicationHistoryView.swift
//  YouthFridge
//
//  Created by 임수진 on 7/23/24.
//

import SwiftUI

struct ApplicationHistoryView: View {
    @ObservedObject var viewModel = MyApplicationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.activities.isEmpty {
                ForEach(viewModel.activities) { activity in
                    ActivityCardView(viewModel: activity)
                }
            } else {
                VStack {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                    Text("참여 중인 소모임이 없어요")
                        .foregroundColor(.gray3)
                        .font(.system(size: 18, weight: .regular))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ApplicationHistoryView()
}
