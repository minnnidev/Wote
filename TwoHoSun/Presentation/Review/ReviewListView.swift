//
//  ReviewListView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct ReviewListView: View {
    @EnvironmentObject var appDependency: AppDependency
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
                    tapSearchButton: {
                        reviewRouter.push(to: WoteDestination.search)
                    }
                )

                ScrollView {
                    sameSpendTypeReviewView()
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .padding(.leading, 24)

                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: .sectionHeaders) {
                            Section {
                                reviewListView
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
            viewModel.send(action: .loadReviews)
        }
        .onAppear {
            viewModel.send(action: .loadReviews)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
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
                            reviewRouter.push(to: WoteDestination.reviewDetail(postId: review.id))
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
    private var reviewListView: some View {
        if viewModel.showingReviews.isEmpty {
            NoReviewView()
                .padding(.top, 100)
        } else {
            ForEach(Array(viewModel.showingReviews.enumerated()), id: \.element.id) { index, data in
                Button {
                    reviewRouter.push(to: WoteDestination.reviewDetail(postId: data.id))
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)

                        ReviewCardCell(cellType: .otherReview, data: data)
                    }
                }
                .onAppear {
                    if index == viewModel.showingReviews.count - 2 {
                        viewModel.send(action: .loadMoreReviews)
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewListView(
        viewModel: .init(reviewUseCase: StubReviewUseCase())
    )
    .environmentObject(NavigationRouter())
}
