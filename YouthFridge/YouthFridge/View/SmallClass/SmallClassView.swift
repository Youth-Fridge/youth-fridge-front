//
//  SmallClassView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI
import Combine

struct SmallClassView: View {
    @StateObject private var viewModel = CellViewModel()
    let tags = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]
    @State private var selectedTags: [String] = []
    private let selectedTagsSubject = PassthroughSubject<[String], Never>()
    @State private var cancellables = Set<AnyCancellable>()
    var onProfileImageClick: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationLink(destination: CreateInviteView()) {
                    AddInviteView()
                }
                .buttonStyle(PlainButtonStyle())
                
                HStack {
                    Text("참여 내역")
                        .font(.pretendardSemiBold16)
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.leading, 20)
                
                TagsView(tags: tags, selectedTags: $selectedTags, viewModel: viewModel)
                    .padding(.leading, 10)
                    .padding(.top, 15)
                
                List(viewModel.cells) { cell in
                    ZStack {
                        NavigationLink(destination: ShowInviteView(
                            viewModel: ShowInviteViewModel(),
                            invitationId: cell.id,
                            recruiting: cell.ing
                        ).toolbar(.hidden, for: .tabBar)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        CellView(cell: cell)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                            .onAppear {
                                if cell == viewModel.cells.last {
                                    if selectedTags.isEmpty {
                                        viewModel.fetchInviteCellData()
                                    } else {
                                        viewModel.fetchKeyWordsList(selectedTags: selectedTags)
                                    }
                                }
                            }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("생활밥서", displayMode: .inline)
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onProfileImageClick()
                    }) {
                        let profileNumber = UserDefaults.standard.integer(forKey: "profileImageNumber")
                        if let profile = ProfileImage.from(rawValue: profileNumber) {
                            let profileImage = profile.imageName
                            
                            Image(profileImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.observeSelectedTags(selectedTagsSubject)
                        
            if selectedTags.isEmpty {
                viewModel.fetchInviteCellData()
            } else {
                viewModel.fetchKeyWordsList(selectedTags: selectedTags)
            }
        }
        .onChange(of: selectedTags) { newTags in
            selectedTagsSubject.send(newTags)
        }
        .onReceive(selectedTagsSubject) { newTags in
            viewModel.observeSelectedTags(selectedTagsSubject)
        }
    }
}

