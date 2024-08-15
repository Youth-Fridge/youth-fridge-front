//
//  SmallClassView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct SmallClassView: View {
    @StateObject private var viewModel = CellViewModel()
    let tags = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]
    @State private var selectedTags: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: CreateInviteView()) {
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
                        )) {
                            EmptyView() // This is needed so that the NavigationLink works correctly
                        }
                        .opacity(0) // Make the link invisible
                        
                        CellView(cell: cell)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                            .onAppear {
                                // Check if the current cell is the last one in the list
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
        .onAppear {
            // Fetch the initial data when the view appears
            viewModel.fetchInviteCellData()
        }
    }
}


struct AddInviteView: View {
    var body: some View {
        HStack {
            Image("plus-circle")
                .resizable()
                .frame(width: 28,height: 28)
                .padding(.leading,15)
            Text("초대장 만들기")
                .font(.system(size: 20,weight: .bold))
            Spacer()
            Image("plus_letter")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
                .padding(.top,19)
        }
        .background(Color.sub2Color)
        .frame(maxWidth: .infinity, maxHeight: 100)
        .cornerRadius(0)
    }
}

#Preview {
    SmallClassView()
}
