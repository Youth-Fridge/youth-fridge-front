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
    @StateObject private var smallViewModel = SmallClassViewModel()

    let tags = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]
    
    @State private var selectedTags: [String] = [] {
        didSet {
            selectedTagsSubject.send(selectedTags)
        }
    }
    
    private let selectedTagsSubject = PassthroughSubject<[String], Never>()
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationLink(destination: CreateInviteView().toolbar(.hidden, for: .tabBar)) {
                    AddInviteView()
                }
                .buttonStyle(PlainButtonStyle())
                
                HStack {
                    Text("참여 내역")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.leading, 30)
                
                TagsView(tags: tags, selectedTags: $selectedTags, viewModel: viewModel)
                    .padding(.leading, 20)
                    .padding(.top, 15)
                
                List(viewModel.cells) { cell in
                    ZStack {
                        NavigationLink(destination: ShowInviteView(
                            viewModel: ShowInviteViewModel(),
                            invitationId: cell.id
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
                                    viewModel.fetchInviteCellData()
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
                    if let profileImageUrl = smallViewModel.profileImageUrl {
                        if let profile = ProfileImage.from(rawValue: profileImageUrl) {
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
            viewModel.fetchInviteCellData()
            smallViewModel.fetchProfileImage()
            viewModel.observeSelectedTags(selectedTagsSubject)
        }
    }
    
    private func setupCombine() {
        selectedTagsSubject
            .sink { newTags in
                if newTags.isEmpty {
                    viewModel.fetchInviteCellData()
                } else {
                    viewModel.fetchKeyWordsList(selectedTags: newTags)
                }
            }
            .store(in: &cancellables)
    }
    
}

#Preview {
    SmallClassView()
}
