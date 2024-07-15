//
//  DIContainer.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/15/24.
//

import Foundation

class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
