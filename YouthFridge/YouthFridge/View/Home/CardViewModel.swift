//
//  CardViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/19/24.
//

import SwiftUI
import Combine

class CardViewModel: ObservableObject {
    @Published var card: Card
    @Published var image: Image
    
    init(card: Card) {
        self.card = card
        self.image = Image(card.imageName)
    }
}
