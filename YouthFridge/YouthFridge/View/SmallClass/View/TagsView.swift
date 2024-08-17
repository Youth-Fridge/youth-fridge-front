//
//  TagsView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/15/24.
//

import Foundation
import SwiftUI

struct TagsView: View {
    let tags: [String]
    @Binding var selectedTags: [String]
    @ObservedObject var viewModel: CellViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12,weight: .semibold))
                        .padding(.leading,20)
                        .padding(.trailing,20)
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .background(selectedTags.contains(tag) ? Color.sub2Color : Color.gray1Color)
                        .cornerRadius(25)
                        .onTapGesture {
                            if let index = selectedTags.firstIndex(of: tag) {
                                selectedTags.remove(at: index)
                            } else {
                                selectedTags.append(tag)
                            }
                            if selectedTags.isEmpty {
                                viewModel.fetchInviteCellData()
                            } else {
                                viewModel.fetchKeyWordsList(selectedTags: selectedTags)
                            }
                        }
                        .padding(.leading,5)
                }
            }
        }
    }
}
