//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//
import Combine
import SwiftUI

final class CommentsViewModel: ObservableObject {

    enum Action {
        case presentSheet(Bool)
    }

    @Published var comments: String = ""
    @Published var commentsDatas = [CommentModel]()
    @Published var presentAlert = false

    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false

    private var postId: Int
    private var bag = Set<AnyCancellable>()

    init(postId: Int) {
        self.postId = postId
        self.getAllComments()

        commentsDatas = [.commentStub1]
    }

    func send(action: Action) {
        switch action {
        case let .presentSheet(isMine):
            if isMine {
                isMySheetShowed.toggle()
            } else {
                isOtherSheetShowed.toggle()
            }
        }
    }

    func refreshComments() {
        self.comments = ""
        self.getAllComments()
    }

    func getAllComments() {

    }
    
    func postComment() {

    }

    func deleteComments(commentId: Int) {

    }

    func postReply(commentId: Int) {

    }
}
