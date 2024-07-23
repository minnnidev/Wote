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
        case clearSearchText
    }

    @Published var searchHistory = [String]()
    @Published var searchedDatas: [ReviewModel] = []
    @Published var page = 0

    @Published var searchText: String = ""
    @Published var selectedFilterType = PostStatus.active

    @Published var visibilityScope: VisibilityScopeType = .global

    var isFetching = false

    private var cancellables: Set<AnyCancellable> = []
    private let searchUseCase: SearchUseCaseType

    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
    }

    func send(action: Action) {

        switch action {

        case let .searchWithQuery(query):
            switch selectedFilterType {

            case .active:
                searchUseCase.searchVoteResult(
                    voteStatus: .active,
                    scope: visibilityScope,
                    page: 0,
                    size: 10,
                    keyword: query
                )
                .sink { _ in
                } receiveValue: { activeVotes in
      
                }
                .store(in: &cancellables)

            case .closed:
                searchUseCase.searchVoteResult(
                    voteStatus: .closed,
                    scope: visibilityScope,
                    page: 0,
                    size: 10,
                    keyword: query
                )
                .sink { _ in
                } receiveValue: { closedVotes in

                }
                .store(in: &cancellables)

            case .review:
                searchUseCase.searchReviewResult(
                    scope: visibilityScope,
                    page: 0,
                    size: 10,
                    keyword: query
                )
                .sink { _ in
                } receiveValue: { reviews in

                }
                .store(in: &cancellables)
            }

        case .clearSearchText:
            searchText.removeAll()
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

    func fetchSearchedData(keyword: String, reset: Bool = false, save: Bool = false) {
        isFetching.toggle()
        if reset {
            page = 0
            self.searchedDatas = []
        }

        // TODO: 검색 API
    }
}
