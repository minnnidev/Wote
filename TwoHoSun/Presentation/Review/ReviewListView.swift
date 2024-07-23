//
//  ReviewListView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct ReviewListView: View {
    @State private var didFinishSetup = false

    @Binding var visibilityScope: VisibilityScopeType

    @StateObject var viewModel = ReviewListViewModel()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

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
                    Button {

                    } label: {
                        // TODO: Simple Review Cells
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func simpleReviewCell(title: String,
                                  content: String?,
                                  isPurchased: Bool?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                PurchaseLabel(isPurchased: isPurchased ?? false)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 20)

            Text(content ?? "")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 20)
        }
        .frame(width: 268)
        .padding(.vertical, 20)
        .background(Color.disableGray)
        .clipShape(.rect(cornerRadius: 12))
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
                            viewModel.fetchMoreReviews(for: visibilityScope,
                                                       filter: filter)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewListView(visibilityScope: .constant(.global))
}
