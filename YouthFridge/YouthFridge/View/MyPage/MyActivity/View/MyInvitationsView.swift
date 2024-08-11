//
//  MyInvitationsView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct MyInvitationsView: View {
    @ObservedObject var viewModel = MyInvitationsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.invitationActivities.isEmpty {
                ForEach(viewModel.invitationActivities) { activity in
                    ActivityCardView(viewModel: activity, detail: "invitation")
                        .disabled(activity.isPast)
                }
            } else {
                VStack {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                    Text("소모임을 운영하는 호스트가 되어봐요 :)")
                        .foregroundColor(.gray3)
                        .font(.system(size: 18, weight: .regular))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}

struct MyInvitationsView_Previews: PreviewProvider {
    static var previews: some View {
        MyInvitationsView()
    }
}


