//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {

    @Published var isMine = false
    @Published var error: NetworkError? 
    @Published var postDetail: PostDetailModel?
    @Published var agreeTopConsumerTypes = [ConsumerType]()
    @Published var disagreeTopConsumerTypes = [ConsumerType]()

    private var cancellables: Set<AnyCancellable> = []

    func searchPostIndex(with postId: Int) -> Int? {
        return nil
    }

    func searchMyPostIndex(with postId: Int) -> Int? {
        return nil
    }

    func fetchPostDetail(postId: Int) {
        // TODO: 디테일 투표 조회
    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int?) {
        // TODO: 투표하기
    }

    func updatePost(index: Int,
                    myChoice: Bool,
                    voteCount: VoteCountsModel) {

    }

    func updateMyPost(index: Int) {

    }

    func deletePost(postId: Int) {
        // TODO: 투표 삭제
     }

     func closePost(postId: Int, index: (Int?, Int?)) {
         // TODO: 투표 종료
     }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount

        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }

    private func setTopConsumerTypes() {
        guard let voteInfoList = postDetail?.post.voteInfoList else { return }
        let (agreeVoteInfos, disagreeVoteInfos) = filterSelectedResult(voteInfoList: voteInfoList)
        agreeTopConsumerTypes = getTopConsumerTypes(for: agreeVoteInfos)
        disagreeTopConsumerTypes = getTopConsumerTypes(for: disagreeVoteInfos)
    }

    private func filterSelectedResult(voteInfoList: [VoteInfoModel]) -> (agree: [VoteInfoModel],
                                                                disagree: [VoteInfoModel]) {
        return (voteInfoList.filter { $0.isAgree }, voteInfoList.filter { !$0.isAgree })
    }

    private func getTopConsumerTypes(for votes: [VoteInfoModel]) -> [ConsumerType] {
        return Dictionary(grouping: votes, by: { $0.consumerType })
            .sorted { $0.value.count > $1.value.count }
            .prefix(2)
            .map { ConsumerType(rawValue: $0.key) }
            .compactMap { $0 }
    }
}
