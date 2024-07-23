//
//  SeachViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/23/23.
//
import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var searchHistory = [String]()
    @Published var searchedDatas: [ReviewModel] = []
    @Published var page = 0
    @Published var showEmptyView = false

    @Published var searchText: String = ""
    @Published var selectedFilterType = PostStatus.active

    var isFetching = false

    private var bag = Set<AnyCancellable>()

    init() {
        fetchRecentSearch()
    }

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
