//
//  ActivityDetailView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ActivityDetail: View {
    @ObservedObject var viewModel: ActivityCardViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.title)
                .padding()
            Text("Date: \(viewModel.date)")
                .font(.headline)
                .padding()
            Text("Location: \(viewModel.location)")
                .font(.headline)
                .padding()
            Text("Days Left: \(viewModel.daysLeft)")
                .font(.headline)
                .padding()
            Spacer()
        }
        .navigationTitle(viewModel.title)
    }
}
