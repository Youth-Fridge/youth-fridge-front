//
//  InvitationAPI.swift
//  YouthFridge
//
//  Created by 임수진 on 7/31/24.
//

import SwiftUI
import Moya

enum InvitationAPI {
    case createInvitation(Data)                                           // 초대장 생성
    case getInvitation(invitationId: Int)                                 // 초대장 상세 조회
    case getInvitationsTop5                                               // 초대장 마감임박순 5개 조회
    case getInvitationsbyKeyword(kewords: String, page: Int, size: Int)   // 키워드로 소모임 구인 글 조회
    case getMyInvitations(page: Int, size: Int)                           // 내가 생성한 초대장 조회
    case getMyDetailInvitation(invitationId: Int)                         // 내가 생성한 초대장 상세 조회
    case getAppliedInvitations(page: Int, size: Int)                      // 내가 신청한 소모임 조회
    case getAppliedDetailInvitation(invitationId: Int)                    // 내가 신청한 소모임 상세 조회
    case getImminentInvitation                                            // 가장 마감 임박한 소모임 D-Day 조회
    case applyInvitation(invitationId: Int)                               // 소모임 참가 신청하기
    case cancelInvitation(invitationId: Int)                              // 소모임 참가 취소하기
    case reportInvitation(invitationId: Int, reasonList: [Int])
    case publicMeeting
    case smallClassList(page: Int, size: Int)
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
        case .getMyDetailInvitation(let invitationId):
            return "/api/invitations/mine/\(invitationId)"
        case .getAppliedInvitations:
            return "/api/invitations/applied"
        case .getAppliedDetailInvitation(let invitationId):
            return "/api/invitations/applied/\(invitationId)"
        case .getInvitationsbyKeyword:
            return "/api/invitations/search"
        case .getImminentInvitation:
            return "/api/invitations/imminent"
        case .applyInvitation(invitationId: let invitationId):
            return "/api/invitations/\(invitationId)/apply"
        case .cancelInvitation(invitationId: let invitationId):
            return "/api/invitations/\(invitationId)/apply"
        case .reportInvitation(invitationId: let invitationId, _):
            return "/api/report/invitation/\(invitationId)"
        case .publicMeeting:
            return "/api/invitations/official"
        case .smallClassList:
            return "/api/invitations"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createInvitation, .applyInvitation, .reportInvitation:
            return .post
        case .getInvitation, .getInvitationsTop5, .getMyInvitations, .getMyDetailInvitation, .getAppliedInvitations, .getAppliedDetailInvitation, .getInvitationsbyKeyword, .getImminentInvitation, .publicMeeting,.smallClassList:
            return .get
        case .cancelInvitation:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .getInvitation, .applyInvitation, .cancelInvitation, .getInvitationsTop5, .getMyDetailInvitation, .getAppliedDetailInvitation, .getImminentInvitation, .publicMeeting:
            return .requestPlain
        case .getInvitationsbyKeyword(let kewords, let page, let size):
            return .requestParameters(
                parameters: [
                    "keywords": kewords,
                    "page": page,
                    "size": size
                ],
                encoding: URLEncoding.queryString
            )
        case .getMyInvitations(let page, let size), .getAppliedInvitations(let page, let size), .smallClassList(let page, let size):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "size": size
                ],
                encoding: URLEncoding.queryString
            )
        case .createInvitation(let data):
            return .requestData(data)
        case .reportInvitation(_, let reasonList):
            let request = ReasonListRequest(reasonList: reasonList)
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String : String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
        
        if let accessToken = getAccessToken() {
            headers["Authorization"] = accessToken
        }
        
        return headers
    }
    
    private func getAccessToken() -> String? {
        return KeychainHandler.shared.accessToken
    }
}
