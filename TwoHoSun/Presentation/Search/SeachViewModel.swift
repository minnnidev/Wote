
//
//  SeachViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/23/23.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {

    enum Action {
        case searchWithQuery(String)
        case loadMoreResults(String)
        case clearSearchText
        case loadRecentSearch
        case removeRecentSearch(Int)
        case removeAllRecentSearch
        case addRecentSearch(String)
    }

    @Published var recentSearches: [String] = []
    @Published var searchText: String = ""
    @Published var selectedFilterType = PostStatus.active
    @Published var visibilityScope: VisibilityScopeType = .global
    @Published var voteResults: [VoteModel] = []
    @Published var reviewResults: [ReviewModel] = []
    @Published var isLoading: Bool = false

    private var page = 0
    private var cancellables: Set<AnyCancellable> = []

    private let searchUseCase: SearchUseCaseType

    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
    }

    func send(action: Action) {

        switch action {

        case let .searchWithQuery(query):
            page = 0
            loadResults(at: page, of: 10, query: query, isFirstLoad: true)
            send(action: .addRecentSearch(query))

        case let .loadMoreResults(query):
            page += 1
            loadResults(at: page, of: 10, query: query, isFirstLoad: false)

        case .clearSearchText:
            searchText.removeAll()

        case .loadRecentSearch:
            recentSearches = searchUseCase.loadRecentSearches()

        case let .removeRecentSearch(index):
            searchUseCase.removeRecentSearch(recentSearches, at: index)
            send(action: .loadRecentSearch)

        case .removeAllRecentSearch:
            searchUseCase.removeAllRecentSearches()
            send(action: .loadRecentSearch)

        case let .addRecentSearch(word):
            searchUseCase.addRecentSearches(recentSearches: recentSearches, word: word)
        }
    }

    private func loadResults(at page: Int, of size: Int, query: String, isFirstLoad: Bool) {
        if isFirstLoad { isLoading = true }

        switch selectedFilterType {

        case .review:
            searchUseCase.searchReviewResult(
                scope: visibilityScope,
                page: page,
                size: size,
                keyword: query
            )
            .sink { _ in
            } receiveValue: { [weak self] reviews in
                guard let self = self else { return }

                if isFirstLoad {
                    isLoading = false
                    reviewResults = reviews
                } else {
                    reviewResults.append(contentsOf: reviews)
                }
            }
            .store(in: &cancellables)

        case .active, .closed:
            searchUseCase.searchVoteResult(
                voteStatus: selectedFilterType,
                scope: visibilityScope,
                page: page,
                size: size,
                keyword: query
            )
            .sink { _ in
            } receiveValue: { [weak self] votes in
                guard let self = self else { return }

                if isFirstLoad {
                    isLoading = false
                    voteResults = votes
                } else {
                    voteResults.append(contentsOf: votes)
                }
            }
            .store(in: &cancellables)
        }
    }
}
