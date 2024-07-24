//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss

    @FocusState private var isFocused: Bool

    @StateObject var viewModel: SearchViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        backButton
                        searchField
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 8)

                    VStack(alignment: .leading) {
                        if isFocused {
                            HStack {
                                recentSearchLabel
                                Spacer()
                                deleteAllButton
                            }

                            recentSearchView
                        } else {
                            HStack {
                                searchFilterView
                                    .padding(.bottom, 24)
                                Spacer()
                            }

                            switch viewModel.selectedFilterType {
                            case .review:
                                reviewSearchedResult
                            default:
                                voteSearchedResult
                            }
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onChange(of: isFocused) { _ in
            if isFocused {
                viewModel.send(action: .loadRecentSearch)
            }
        }
    }
}

extension SearchView {

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.accentBlue)
        }
    }

    private var searchField: some View {
        HStack {
            TextField("search",
                      text: $viewModel.searchText,
                      prompt: Text("원하는 소비항목을 검색해보세요.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.placeholderGray))
            .focused($isFocused)
            .font(.system(size: 14, weight: .medium))
            .tint(Color.placeholderGray)
            .frame(height: 32)
            .padding(.leading, 16)
            .onSubmit {
                viewModel.send(action: .searchWithQuery(viewModel.searchText))
            }

            Spacer()

            Button {
                viewModel.send(action: .clearSearchText)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.subGray2)
                    .padding(.trailing, 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(height: 32)
    }

    private var recentSearchLabel: some View {
        Text("최근 검색")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
    }

    private var deleteAllButton: some View {
        Button {
            viewModel.send(action: .removeAllRecentSearch)
        } label: {
            Text("전체 삭제")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.darkGray)
        }
    }

    private func recentSearchCell(word: String, index: Int) -> some View {
        HStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.purpleStroke, lineWidth: 1)
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.clear)

                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(Color.darkGray)
                }
                Text(word)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
                    .padding(.leading, 16)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .background(Color.background.opacity(0.01))

            Button {
                viewModel.send(action: .removeRecentSearch(index))
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.darkGray)
                    .padding(15)
            }
        }
    }

    private var recentSearchView: some View {
        List {
            ForEach(viewModel.recentSearches.indices, id: \.self) { index in
                recentSearchCell(word: viewModel.recentSearches[index], index: index)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }

    private var searchFilterView: some View {
        HStack(spacing: 8) {
            ForEach(PostStatus.allCases, id: \.self) { filter in
                FilterButton(title: filter.filterTitle,
                             isSelected: viewModel.selectedFilterType == filter) {
                    viewModel.selectedFilterType = filter
                    viewModel.send(action: .searchWithQuery(viewModel.searchText))
                }
            }
        }
    }

    private var reviewSearchedResult: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(Array(viewModel.reviewResults.enumerated()), id: \.offset) { index, data in
                        Button {
                            // TODO: Review Detail로 이동
                        } label: {
                            ReviewSearchResultCell(review: data)
                        }
                        .onAppear {
                            if index == viewModel.reviewResults.count - 4 {
                                viewModel.send(action: .loadMoreResults(viewModel.searchText))
                            }
                        }
                    }
                    .id("searchResult")
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var voteSearchedResult: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(Array(viewModel.voteResults.enumerated()), id: \.offset) { index, data in
                        Button {
                            // TODO: Vote Detail로 이동
                        } label: {
                            VoteSearchResultCell(vote: data)
                        }
                        .onAppear {
                            if index == viewModel.voteResults.count - 4 {
                                viewModel.send(action: .loadMoreResults(viewModel.searchText))
                            }
                        }
                    }
                    .id("searchResult")
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image("imgNoResult")
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.subGray1)
        }
    }
}

#Preview {
    SearchView(viewModel: .init(searchUseCase: StubSearchUseCase()))
}
