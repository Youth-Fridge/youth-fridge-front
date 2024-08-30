//
//  CarouselView.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/29/24.
//

import Foundation
import SwiftUI

struct CarouselView: View {
    let items: [StepCardViewModel]
    let sideItemScale: CGFloat = 0.4
    let sideItemAlpha: CGFloat = 1
    let spacing: CGFloat = -25
    
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedIndex: Int = 2
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(reorderedItems(), id: \.id) { item in
                            StepCardView(viewModel: item)
                                .frame(width: geometry.size.width * 0.35)
                                .scaleEffect(scale(for: item.id, in: geometry.size.width))
                                .offset(y: yOffset(for: item.id, in: geometry.size.width, itemIndex: items.firstIndex(where: { $0.id == item.id })))
                                .padding(.vertical, 80)
                                .id(item.id)
                                .zIndex(zIndex(for: item.id))
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - (geometry.size.width * 0.8)) / 5)
                    .offset(x: -scrollOffset) // 스크롤 오프셋 적용
                }
                
                .onChange(of: scrollOffset) { newValue in
                    updateSelectedIndex(in: geometry.size.width)
                }
                .onAppear {
                    withAnimation {
                        scrollViewProxy.scrollTo(items[selectedIndex].id, anchor: .center)
                    }
                }
            }
            .frame(height: 330) // CarouselView의 고정 높이 설정
        }
    }
    
    private func reorderedItems() -> [StepCardViewModel] {
        var reordered = items
        
        // 원하는 카드를 가운데로 위치시키기 위해 아이템 순서를 재배열
        if selectedIndex == 0 {
            reordered = [items[3], items[4], items[0], items[1], items[2]]
        } else if selectedIndex == 1 {
            reordered = [items[0], items[4], items[1], items[2], items[3]]
        } else if selectedIndex == 2 {
            reordered = [items[0], items[1], items[2], items[3], items[4]]
        } else if selectedIndex == 3 {
            reordered = [items[2], items[1], items[3], items[4], items[0]]
        } else if selectedIndex == 4 {
            reordered = [items[2], items[3], items[4], items[0], items[1]]
        }
        
        return reordered
    }
    
    private func scale(for id: UUID, in width: CGFloat) -> CGFloat {
        let itemWidth: CGFloat = width * 0.8
        let itemCenter = (width / 5) - scrollOffset
        let center = itemWidth / 5
        let distance = abs(center - itemCenter)
        let maxDistance = (itemWidth + spacing) / 5
        let ratio = (maxDistance - distance) / maxDistance
        return ratio * (1 - sideItemScale) + sideItemScale
    }
    
    private func opacity(for id: UUID, in width: CGFloat) -> Double {
        let itemWidth: CGFloat = width * 0.8
        let itemCenter = (width / 2) - scrollOffset
        let center = itemWidth / 2
        let distance = abs(center - itemCenter)
        let maxDistance = (itemWidth + spacing) / 5
        let ratio = (maxDistance - distance) / maxDistance
        return Double(ratio * (1 - sideItemAlpha) + sideItemAlpha)
    }
    private func zIndex(for id: UUID) -> Double {
        return (reorderedItems().firstIndex(where: { $0.id == id }) == 2) ? 1 : 0
    }

    private func yOffset(for id: UUID, in width: CGFloat, itemIndex: Int?) -> CGFloat {
        let itemWidth: CGFloat = width * 0.8
        let itemCenter = (width / 5) - scrollOffset
        let center = itemWidth / 5
        let distance = abs(center - itemCenter)
        let maxDistance = (itemWidth + spacing) / 5
        let ratio = (maxDistance - distance) / maxDistance
        let offsetRange: CGFloat = 30 // 수직 오프셋의 범위
        
        // 가운데 있는 항목만 Y 오프셋을 조정, 선택된 인덱스는 더 높이 올리기
        let isSelectedItem = (itemIndex == selectedIndex)
        return (ratio > 0.8 ? -ratio * offsetRange : 0) - (isSelectedItem ? 0 : 0)
    }
    private func snapToNearestItem(in width: CGFloat) {
        let itemWidth: CGFloat = width * 0.35
        let halfWidth = width / 2
        let centerOffset = scrollOffset + halfWidth
        
        let index = Int(round(centerOffset / (itemWidth + spacing)))
        selectedIndex = (index + items.count) % items.count
        
        withAnimation {
            scrollOffset = -CGFloat(selectedIndex) * (itemWidth + spacing) + halfWidth
        }
    }
    
    private func updateSelectedIndex(in width: CGFloat) {
        let itemWidth: CGFloat = width * 0.35
        let halfWidth = width * 0.8 / 2
        let centerOffset = scrollOffset + halfWidth
        
        let index = Int(round(centerOffset / (itemWidth + spacing)))
        selectedIndex = (index + items.count) % items.count
    }
}


struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(items: [
            StepCardViewModel(number: "1", title: "생활밥서", subtitle: "밥심 챙기자", subtitle2: "안서동 소모임", backgroundColor: .onboarding1),
            StepCardViewModel(number: "2", title: "초대장\n만들기", subtitle: "내가 만든 초대장으로", subtitle2: "밥친구 모아요",backgroundColor: .main1),
            StepCardViewModel(number: "3", title: "밥심레터", subtitle: "밥에 대한", subtitle2: "이모저모 소식지",backgroundColor: .onboarding3),
            StepCardViewModel(number: "4", title: "이 주의\n장금이", subtitle: "나만의 레시피로", subtitle2: "장금이 되기",backgroundColor: .onboarding4),
            StepCardViewModel(number: "5", title: "밥업\n스토어", subtitle: "찾아가는", subtitle2: "안서동 과일가게",backgroundColor: .onboarding5)
        ])
    }
}
