
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
    @Published var isSubmitted: Bool = false

    private var page = 0
    private var cancellables: Set<AnyCancellable> = []

    private let searchUseCase: SearchUseCaseType

    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase

        bind()
    }

    private func bind() {
        $searchText
            .removeDuplicates()
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                if text.isEmpty {
                    self?.isSubmitted = false
                    self?.send(action: .loadRecentSearch)
                } 
            }
            .store(in: &cancellables)
    }

    func send(action: Action) {

        switch action {

        case let .searchWithQuery(query):
            page = 0
            loadResults(at: page, of: 10, query: query, isFirstLoad: true)

        case let .loadMoreResults(query):
            page += 1
            loadResults(at: page, of: 10, query: query, isFirstLoad: false)

        case .clearSearchText:
            searchText.removeAll()

        case .loadRecentSearch:
            loadRecentSearches()

        case let .removeRecentSearch(index):
            searchUseCase.removeRecentSearch(recentSearches, at: index)
            loadRecentSearches()

        case .removeAllRecentSearch:
            searchUseCase.removeAllRecentSearches()
            loadRecentSearches()

        case let .addRecentSearch(word):
            searchUseCase.addRecentSearches(recentSearches: recentSearches, word: word)
        }
    }

    private func loadRecentSearches() {
        recentSearches = searchUseCase.loadRecentSearches()
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
            .sink { [weak self] _ in
                self?.isLoading = false
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
