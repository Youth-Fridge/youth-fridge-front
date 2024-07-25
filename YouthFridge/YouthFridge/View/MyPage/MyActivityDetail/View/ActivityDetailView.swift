//
//  ActivityDetailView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/16/24.
//

import SwiftUI

struct ActivityDetailView: View {
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

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let services = Services()
        let container = DIContainer(services: services)
        ActivityDetailView(viewModel: ActivityCardViewModel(title: "q", date: "w", location: "dd", daysLeft: 8, imageName: "image1"))
    }
}
