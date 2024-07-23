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
        case loadMoereResults(String)
        case clearSearchText
    }

    @Published var searchHistory = [String]()
    @Published var searchedDatas: [ReviewModel] = []

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

        case let .loadMoereResults(query):
            page += 1

            loadResults(at: page, of: 10, query: query, isFirstLoad: false)

        case .clearSearchText:
            searchText.removeAll()
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

        default:
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

    // TODO: 최근 검색어 로직 UseCase로 이동

    func fetchRecentSearch() {
        guard let recentSearch = UserDefaults.standard.array(forKey: "RecentSearch") as? [String] else { return }
        searchHistory = recentSearch
    }

    func addRecentSearch(searchWord: String) {
        searchHistory.insert(searchWord, at: 0)
        if searchHistory.count > 12 {
            searchHistory.removeLast()
        }
        setRecentSearch()
    }

    func removeRecentSearch(at index: Int) {
        searchHistory.remove(at: index)
        setRecentSearch()
    }

    func removeAllRecentSearch() {
        searchHistory.removeAll()
        setRecentSearch()
    }

    func setRecentSearch() {
        UserDefaults.standard.set(searchHistory, forKey: "RecentSearch")
    }
}
