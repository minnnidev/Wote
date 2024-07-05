//
//  WriteViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Combine
import Foundation

final class VoteWriteViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var externalURL: String = ""
    @Published var content: String = ""
    @Published var image: Data?

    @Published var postCreateModel: PostCreateModel?
    var isPostCreated = false

    private var cancellable = Set<AnyCancellable>()
    
    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }

    
    func setPost() {

    }
    
    func createPost() {

    }
}
