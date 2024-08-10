//
//  InvitationAPI.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import SwiftUI
import Moya

enum InvitationAPI {
    case createInvitation(Data)               // 초대장 생성
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

extension InvitationAPI: TargetType {

    var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }

    var path: String {
        switch self {
        case .createInvitation:
            return "/api/invitations"
        case .getInvitation(let invitationId):
            return "/api/invitations/\(invitationId)"
        case .getInvitationsTop5:
            return "/api/invitations/top5"
        case .getMyInvitations:
            return "/api/invitations/mine"
        case .getAppliedInvitations:
            return "/api/invitations/applied"
        case .getInvitationsbyKeyword(let kewords, let page, let size):
            return "/api/invitations/search"
        case .getImminentInvitations:
            return "/api/invitations/imminent"
        case .applyInvitation(invitationId: let invitationId):
            return "/api/invitations/\(invitationId)/apply"
        case .cancelInvitation(invitationId: let invitationId):
            return "/api/invitations/\(invitationId)/apply"
        case .reportInvitation(invitationId: let invitationId):
            return "/api/report/invitation/\(invitationId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createInvitation, .applyInvitation, .reportInvitation:
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
        case .createInvitation(let data):
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
        return KeychainHandler.shared.accessToken
    }
}
