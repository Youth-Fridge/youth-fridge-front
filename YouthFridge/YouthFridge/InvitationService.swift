//
//  InvitationService.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import Foundation
import SwiftUI
import Moya

enum InvitationService {
    case postInvitation(Data)                 // 초대장 생성
    case getInvitation(invitationId: Int)     // 초대장 상세 조회
    case getInvitationsTop5                   // 초대장 마감임박순 5개 조회
    case getInvitationsbyKeyword(kewords: [String], page: Int, size: Int) // 키워드로 소모임 구인 글 조회
    case getMyInvitations                     // 내가 생성한 초대장 조회
    case getAppliedInvitations                // 내가 신청한 소모임 조회
    case getImminentInvitations               // 가장 마감 임박한 소모임 D-Day 조회
    case applyInvitation(invitationId: Int)   // 소모임 참가 신청하기
    case cancelInvitation(invitationId: Int)  // 소모임 참가 취소하기
    case reportInvitation(invitationId: Int)  // 소모임 신고하기
}

extension InvitationService: TargetType {

    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }

    var path: String {
        switch self {
        case .postInvitation:
            return "/invitations"
        case .getInvitation(let invitationId):
            return "/invitations/\(invitationId)"
        case .getInvitationsTop5:
            return "/invitations/top5"
        case .getMyInvitations:
            return "/invitations/mine"
        case .getAppliedInvitations:
            return "/invitations/applied"
        case .getInvitationsbyKeyword(let kewords, let page, let size):
            return "/invitations/search"
        case .getImminentInvitations:
            return "/invitations/imminent"
        case .applyInvitation(invitationId: let invitationId):
            return "/invitations/\(invitationId)/apply"
        case .cancelInvitation(invitationId: let invitationId):
            return "/invitations/\(invitationId)/apply"
        case .reportInvitation(invitationId: let invitationId):
            return "/report/invitation/\(invitationId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postInvitation, .applyInvitation, .reportInvitation:
            return .post
        case .getInvitation, .getInvitationsTop5, .getMyInvitations, .getAppliedInvitations, .getInvitationsbyKeyword, .getImminentInvitations:
            return .get
        case .cancelInvitation:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .getInvitation, .applyInvitation, .cancelInvitation, .reportInvitation, .getInvitationsTop5, .getMyInvitations, .getAppliedInvitations, .getImminentInvitations:
            return .requestPlain
        case .getInvitationsbyKeyword(let kewords, let page, let size):
            let param: [String: Any] = [
                "keywords": kewords,
                "page": page,
                "size": size
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .postInvitation(let data):
            return .requestData(data)
        }
    }

    var headers: [String : String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
        
        if let accessToken = getAccessToken() {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        return headers
    }
    
    private func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
}
