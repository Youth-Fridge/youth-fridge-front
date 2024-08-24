//
//  ShowInviteViewModel.swift
//  YouthFridge
//
//  Created by 김민솔 on 8/12/24.
//

import Foundation
import Combine

class ShowInviteViewModel: ObservableObject {
    @Published var showDetail: ShowDetailModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAvailable: Bool = true
    
    private var launchDate: String = ""
    private var startTime: String = ""

    private func combinedDateTime() -> Date? {
        let combinedString = "\(launchDate) \(startTime)"
        return DateFormatter.fullDateTimeFormatter.date(from: combinedString)
    }

    var formattedDateAndTime: String {
        guard let dateTime = combinedDateTime() else {
            return "Unknown Date"
        }
        return "\(DateFormatter.displayDateFormatter.string(from: dateTime)) \(DateFormatter.displayTimeFormatter.string(from: dateTime))"
    }
    func fetchInviteData(invitationId: Int) {
        InvitationService.shared.getInvitationDetail(invitationId: invitationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let invitationDetail):
                    if let launchDate = DateFormatter.launchDateFormatter.date(from: invitationDetail.launchDate) {
                        self?.launchDate = invitationDetail.launchDate
                        self?.startTime = invitationDetail.startTime

                        let today = Date()
                        let dDay = Calendar.current.dateComponents([.day], from: today, to: launchDate).day ?? 0

                        let formattedDetail = ShowDetailModel(
                            invitationId: invitationDetail.invitationId,
                            clubName: invitationDetail.clubName,
                            dday: "\(dDay)",
                            number: "\(invitationDetail.currentMember)/\(invitationDetail.totalMember)",
                            time: self?.formattedDateAndTime ?? "Unknown Time",
                            place: invitationDetail.launchPlace,
                            todo: invitationDetail.toDoList.joined(separator: "\n"),
                            ownerProfile: invitationDetail.ownerInfo.profileImageNumber,
                            invitationImage: invitationDetail.invitationImageNumber
                        )
                        print("Received invitationImageNumber: \(invitationDetail.invitationImageNumber)")
                        print("Received 초대장아이디: \(invitationDetail.invitationId)")
                        self?.showDetail = formattedDetail
                        
                        // 자기가 만든 초대장인지 검사
                        let userName = UserDefaults.standard.string(forKey: "nickname")
                        if (invitationDetail.ownerInfo.ownerName == userName) {
                            self?.isAvailable = false
                            print("자기가 만든 초대장은 내가 신청 못해요 ㅠ")
                        }
                        
                        // 정원 초과됐는지 검사
                        if invitationDetail.currentMember >= invitationDetail.totalMember {
                            self?.isAvailable = false
                            print("정원이 초과돼서 신청 못해요 ㅠ")
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}

