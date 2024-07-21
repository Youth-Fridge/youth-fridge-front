//
//  SmallClassView.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import SwiftUI

struct SmallClassView: View {
    @StateObject private var viewModel = SmallClassViewModel()
    let tags = ["건강식", "취미", "요리", "장보기", "메뉴 추천", "식단", "운동", "독서", "레시피", "배달", "과제", "기타"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                InvitationView()
                HStack {
                    Text("참여 내역")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                }
                    .padding(.top,30)
                    .padding(.leading,30)
                TagsView(tags: tags)
                        .padding(.leading,20)
                        .padding(.top, 15)
                List(viewModel.cells) { cell in
                    CellView(cell: cell)
                        .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle())
                Spacer()
                
            }
            
            .navigationBarTitle("생활밥서", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("Ellipse")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
            }
        }
    }
}
struct InvitationView: View {
    var body: some View {
        HStack {
            Image("plus-circle")
                .resizable()
                .frame(width: 28,height: 28)
                .padding(.leading,15)
            Text("초대장 만들기")
                .font(.headline)
            Spacer()
            Image("plus_letter")
                .resizable()
                .frame(width: 150, height: 80)
        }
        .background(Color.sub2Color)
        .frame(maxWidth: .infinity, maxHeight: 100)
        .cornerRadius(10)
    }
}

struct TagsView: View {
    let tags: [String]
    
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
                        .background(Color.gray1Color)
                        .cornerRadius(25)
                        .padding(.leading,5)
                }
            }
        }
    }
}
#Preview {
    SmallClassView()
}
