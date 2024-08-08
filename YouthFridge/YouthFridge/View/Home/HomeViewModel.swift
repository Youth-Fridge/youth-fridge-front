//
//  HomeViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var cards = [
        Card(name:"장금이",title: "초계 국수 만들어요", date: "7월 30일 화요일 오후 7시", location: "안서초등학교", tags: ["메뉴 추천","건강식"], ing: "모집중", imageName: "bigBasket"),
        Card(name:"장금이",title: "김치 담그기", date: "8월 15일 토요일 오전 10시", location: "시청 앞 광장", tags: ["메뉴 추천","건강식"], ing: "모집중", imageName: "bigBasket"),
        Card(name:"장금이",title: "떡 만들기", date: "9월 5일 일요일 오후 2시", location: "문화센터", tags: ["메뉴 추천","건강식"], ing: "모집중", imageName: "bigBasket")
    ]
    
    @Published var tabContents = [
        TabContent(imageName: "banner1", title: "우리 같이 미니 김장할래?", content: "김: 김치 만들고\n치: 치~ 인구 할래? 끝나고 웃놀이 한 판!", date: "10월 5일", ing: "모집중"),
        TabContent(imageName: "banner2", title: "포트락 파티에 널 초대할게", content: "각자 먹고 싶은거 가져와 다 함께\n 나눠먹는 ,,,,그런거 있잖아요~", date: "9월 12일", ing: "모집중"),
        TabContent(imageName: "banner3", title: "특별한 뱅쇼와 함께 하는 연말 파티", content: "제철과일로 만드는\n 뱅쇼와 함께 도란도란 이야기 나눠요 ", date: "11월 2일", ing: "모집중")
    ]
    
    func performAction() {
        // Define the action to be performed when the button is pressed
        print("Button pressed in view model")
    }
}
