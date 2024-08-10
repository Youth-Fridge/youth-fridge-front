//
//  InvitationViewModel.swift
//  YouthFridge
//
//  Created by 임수진 on 8/9/24.
//

import Foundation

class InvitationViewModel: ObservableObject {
    @Published var invitations: [Invitation] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?  // successMessage 추가
    
    private let invitationService: InvitationService
    
    init(invitationService: InvitationService = InvitationService.shared) {
        self.invitationService = invitationService
    }

    func createInvitation(invitation: Invitation) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let data = try encoder.encode(invitation)
            
            invitationService.createInvitation(data: data) { [weak self] (result: Result<BaseResponse<String>, Error>) in
                DispatchQueue.main.async {
                    self?.handleResult(result)
                }
            }
        } catch {
            self.errorMessage = "Failed to encode invitation: \(error.localizedDescription)"
        }
    }
    
    private func handleResult(_ result: Result<BaseResponse<String>, Error>) {
        switch result {
        case .success(let response):
            if response.isSuccess {
                self.successMessage = "Invitation created successfully."
            } else {
                self.errorMessage = "Failed with message: \(response.message)"
            }
        case .failure(let error):
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
    }
}
