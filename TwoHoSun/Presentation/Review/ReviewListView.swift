//
//  ReviewListView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct ReviewListView: View {
    @EnvironmentObject var reviewRouter: NavigationRouter

    @StateObject var viewModel: ReviewListViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                WoteNavigationBar(
                    selectedTab: .constant(.review),
                    visibilityScope: $viewModel.visibilityScope,
                    router: reviewRouter
                )

                ScrollView {
                    sameSpendTypeReviewView()
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .padding(.leading, 24)

                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: .sectionHeaders) {
                            Section {
                                reviewListView(for: viewModel.reviewType)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 8)
                            } header: {
                                reviewFilterView
                            }
                            .id("reviewTypeSection")
                        }
                        .onChange(of: viewModel.reviewType) { _ in
                            proxy.scrollTo("reviewTypeSection", anchor: .top)
                        }
                    }
                }
            }
        }
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
        .refreshable {
            // TODO:
        }
        .onAppear {
            // TODO:
        }
    }
}

extension ReviewListView {

    @ViewBuilder
    private func sameSpendTypeReviewView() -> some View {
        VStack(spacing: 18) {
            HStack(spacing: 6) {
                ConsumerTypeLabel(consumerType: .adventurer,
                                  usage: .standard)
                Text("나와 같은 성향의 소비 후기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.recentReviews, id: \.id) { review in
                        Button {
                            // TODO: Detail View로 이동
                        } label: {
                            SimpleReviewCell(data: review)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var reviewFilterView: some View {
        HStack(spacing: 8) {
            ForEach(ReviewType.allCases, id: \.self) { reviewType in
                FilterButton(title: reviewType.title,
                             isSelected: viewModel.reviewType == reviewType,
                             selectedBackgroundColor: Color.white,
                             selectedForegroundColor: Color.black) {
                    viewModel.reviewType = reviewType
                }
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.leading, 24)
        .background(Color.background)
    }

    @ViewBuilder
    private func reviewListView(for filter: ReviewType) -> some View {
        let datas: [SummaryPostModel] = []

        if datas.isEmpty {
            NoReviewView()
                .padding(.top, 70)
        } else {
            ForEach(Array(zip(datas.indices, datas)), id: \.0) { index, data in
                Button {
                    // TODO: Review deail
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)
                        
                        ReviewCardCell(cellType: .otherReview,
                                       data: data)
                    }
                    .onAppear {
                        if index == datas.count - 2 {
                            viewModel.fetchMoreReviews(for: .global,
                                                       filter: filter)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewListView(
        viewModel: .init()
    )
    .environmentObject(NavigationRouter())
}
