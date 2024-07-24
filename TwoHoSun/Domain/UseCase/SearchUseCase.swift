//
//  SearchUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol SearchUseCaseType {
    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError>
    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError>
    func loadRecentSearches() -> [String]
    func removeRecentSearch(_ recentSearches: [String], at index: Int)
    func removeAllRecentSearches()
    func addRecentSearches(recentSearches: [String], word: String)
}

final class SearchUseCase: SearchUseCaseType {

    private let recentSearchKey: String = UserDefaultsKey.recentSearch

    private let searchRepository: SearchRepositoryType

    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
    }

    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError> {
        searchRepository.getVoteResults(scope: scope, postStatus: voteStatus, page: page, size: size, keyword: keyword)
    }

    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError> {
        searchRepository.getReviewResults(scope: scope, page: page, size: size, keyword: keyword)
    }

    func loadRecentSearches() -> [String] {
        UserDefaults.standard.array(forKey: recentSearchKey) as? [String] ?? []
    }

    func removeRecentSearch(_ recentSearches: [String], at index: Int) {
        var newRecentSearches = recentSearches
        newRecentSearches.remove(at: index)

        setRecentSearchUserDefaults(newRecentSearches)
    }

    func removeAllRecentSearches() {
        setRecentSearchUserDefaults(.init())
    }

    func addRecentSearches(recentSearches: [String], word: String) {
        var newRecentSearches = recentSearches
        newRecentSearches.insert(word, at: 0)

        if newRecentSearches.count > 12 {
            newRecentSearches.removeLast()
        }

        setRecentSearchUserDefaults(newRecentSearches)
    }
}

extension SearchUseCase {

    private func setRecentSearchUserDefaults(_ recentSearches: [String]) {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchKey)
    }
}

final class StubSearchUseCase: SearchUseCaseType {

    private var recentSearches = ["최근 검색어1", "최근 검색어2", "최근 검색어3"]

    func searchVoteResult(voteStatus: PostStatus, scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError> {
        Just([.voteStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func searchReviewResult(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError> {
        Just([.reviewStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func loadRecentSearches() -> [String] {
        recentSearches
    }

    func removeRecentSearch(_ recentSearches: [String], at index: Int) {
        self.recentSearches.remove(at: index)
    }

    func removeAllRecentSearches() {
        self.recentSearches = .init()
    }

    func addRecentSearches(recentSearches: [String], word: String) {
        self.recentSearches.insert(word, at: 0)
    }
}

