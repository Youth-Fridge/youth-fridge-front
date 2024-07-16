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
            ForEach(viewModel.activities) { activity in
                
                ActivityCardView(viewModel: activity)
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


