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
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(selectedTags.contains(tag) ? Color.sub2Color : Color.gray1Color)
                        .cornerRadius(25)
                        .onTapGesture {
                            if let index = selectedTags.firstIndex(of: tag) {
                                selectedTags.remove(at: index)
                                print("Removed tag: \(tag)")
                            } else {
                                selectedTags.append(tag)
                                print("Added tag: \(tag)")
                            }
                            
                            print("Current selectedTags: \(selectedTags)")
                            
                            if selectedTags.isEmpty {
                                print("selectedTags is empty, calling fetchInviteCellData()")
                                viewModel.fetchInviteCellData()
                            } else {
                                print("Calling fetchKeyWordsList with tags: \(selectedTags)")
                                viewModel.fetchKeyWordsList(selectedTags: selectedTags)
                            }
                        }
                        .padding(.leading, 5)
                }
            }
        }
    }
}

