//
//  ReviewDetailView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct ReviewDetailView: View {
    @EnvironmentObject var appDependency: AppDependency
    @EnvironmentObject var router: NavigationRouter

    @StateObject var viewModel: ReviewDetailViewModel

    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            if let data = viewModel.reviewDetailData {
                ScrollView {
                    VStack(spacing: 0) {
                        detailHeaderView(data.originalPost)
                            .padding(.top, 24)
                            .padding(.horizontal, 24)

                        Divider()
                            .background(Color.disableGray)
                            .padding(.horizontal, 12)
                            .padding(.top, 12)

                        detailReviewCell(data.reviewPost)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 30)
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("후기 상세보기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }

            ToolbarItem(placement: .topBarTrailing) {
                menuButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .refreshable {
            viewModel.send(action: .loadDetail)
        }
        .onAppear {
            viewModel.send(action: .loadDetail)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .sheet(isPresented: $viewModel.isCommentShowed) {
            CommentsView(
                viewModel: appDependency.container.resolve(CommentsViewModel.self, argument: viewModel.id)!
            )
            .presentationDetents([.height(600)])
            .presentationDragIndicator(.visible)
        }
        .confirmationDialog("MySheet", isPresented: $viewModel.isMySheetShowed) {
            Button {
                viewModel.send(action: .deleteReview)
            } label: {
                Text("후기 삭제하기")
            }
        }
        .confirmationDialog("OtherSheet", isPresented: $viewModel.isOtherSheetShowed) {
            Button {
                // TODO: - 신고 action
            } label: {
                Text("신고하기")
            }

            Button {
                viewModel.send(action: .blockUser(
                    memberId: viewModel.reviewDetailData?.reviewPost.author?.id ?? 0
                ))
            } label: {
                Text("차단하기")
            }
        }
        .onChange(of: viewModel.isReviewManageSucceed) { _ in
            router.pop()
        }
    }
}

extension ReviewDetailView {

    private var menuButton: some View {
        Button {
            viewModel.send(action: .presentSheet)
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.subGray1)
        }
    }
    
    private func detailHeaderView(_ data: VoteModel) -> some View {
        VStack(spacing: 11) {
            HStack(spacing: 3) {
                ProfileImageView(imageURL: data.author.profileImage)
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 7)
                Text(data.author.nickname)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.woteWhite)
                Text("님의 소비 고민")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.woteWhite)

                Spacer()

                Button {
                    router.push(to: WoteDestination.voteDetail(postId: data.id))
                } label: {
                    HStack(spacing: 2) {
                        Text("바로가기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.accentBlue)
                }
            }

            Button {
                router.push(to: WoteDestination.voteDetail(postId: data.id))
            } label: {
                VoteCardCell(cellType: .standard, data: data)
            }
        }
    }

    private func detailReviewCell(_ data: ReviewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ConsumerTypeLabel(consumerType: ConsumerType(rawValue: data.author!.consumerType) ?? .adventurer,
                              usage: .cell)
                .padding(.bottom, 12)

            HStack(spacing: 4) {
                if let isPurchased = data.isPurchased {
                    PurchaseLabel(isPurchased: isPurchased)
                }
                Text(data.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .padding(.bottom, 5)

            Text(data.contents ?? "")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
                .padding(.bottom, 8)

            HStack(spacing: 0) {
                if let price = data.price {
                    Text("가격: \(price)원")
                    Text(" · ")
                }
                Text(data.createDate.convertToStringDate() ?? "")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 20)

            if let image = data.image {
                ImageView(imageURL: image)
                    .padding(.bottom, 28)
            }

            CommentPreview(
                previewComment: viewModel.reviewDetailData?.commentPreview,
                commentCount: viewModel.reviewDetailData?.commentCount,
                commentPreviewImage: viewModel.reviewDetailData?.commentPreviewImage
            )
            .onTapGesture {
                viewModel.send(action: .presentComment)
            }
        }
    }

    private var shareButton: some View {
        HStack {
            Spacer()
            Button {
                // TODO: 공유
            } label: {
                Label("공유", systemImage: "square.and.arrow.up")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.lightBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView(
            viewModel: .init(
                id: 1,
                reviewUseCase: StubReviewUseCase(),
                userUseCase: StubUserUseCase()
            )
        )
        .environmentObject(AppDependency())
        .environmentObject(NavigationRouter())
    }
}
