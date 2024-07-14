//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//
import Combine
import SwiftUI

final class CommentsViewModel: ObservableObject {
    
    @Published var comments: String = ""
    @Published var commentsDatas = [CommentsModel]()
    @Published var presentAlert = false

    private var postId: Int
    private var bag = Set<AnyCancellable>()

    init(postId: Int) {
        self.postId = postId
        self.getAllComments()
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
