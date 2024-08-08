//
//  YouthFridgeApp.swift
//  YouthFridge
//
//  Created by 김민솔 on 7/14/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct YouthFridgeApp: App {
    init() {
        KakaoSDK.initSDK(appKey: "a3e8f2efdc9520ebdd35b764bc0e0597")
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
