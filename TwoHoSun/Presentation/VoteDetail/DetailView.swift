//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var router: NavigationRouter

    @StateObject var viewModel: DetailViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            ScrollView {
                if let voteDetail = viewModel.voteDetail {
                    VStack(spacing: 0) {
                        DetailHeaderView(data: voteDetail)
                            .padding(.top, 18)

                        Divider()
                            .background(Color.disableGray)
                            .padding(.horizontal, 12)

                        DetailContentView(postDetailData: voteDetail)
                            .padding(.top, 27)

                        VStack {
                            if viewModel.isVoteResultShowed {
                                VoteResultView(
                                    myChoice: viewModel.voteDetail?.post.myChoice,
                                    agreeRatio: viewModel.agreeRatio ?? 0,
                                    disagreeRatio: viewModel.disagreeRatio ?? 0
                                )

                            } else {
                                IncompletedVoteButton(choice: .agree) {
                                    viewModel.send(action: .vote(true))

                                }
                                IncompletedVoteButton(choice: .disagree) {
                                    viewModel.send(action: .vote(false))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    commentPreview
                        .padding(.horizontal, 24)
                        .padding(.vertical, 48)
                } else {
                    ProgressView()
                        .padding(.top, 100)
                }

                if viewModel.isVoteConsumerTypeResultShowed {
                    if viewModel.isVoteResultShowed {
                        consumerTypeLabels(.agree, topConsumerTypes: viewModel.agreeTopConsumerTypes ?? [])

                        resultProgressView(.agree,
                                           ratio: viewModel.agreeRatio ?? 0,
                                           isHigher: viewModel.agreeRatio ?? 0 >= viewModel.disagreeRatio ?? 0)

                        consumerTypeLabels(.disagree, topConsumerTypes: viewModel.disagreeTopConsumerTypes ?? [])

                        resultProgressView(.agree,
                                           ratio: viewModel.disagreeRatio ?? 0,
                                           isHigher: viewModel.disagreeRatio ?? 0 >= viewModel.agreeRatio ?? 0)
                    } else {
                        hiddenResultView(for: .agree,
                                         topConsumerTypesCount: viewModel.agreeTopConsumerTypes?.count ?? 0)
                            .padding(.bottom, 34)

                        hiddenResultView(for: .disagree,
                                         topConsumerTypesCount: viewModel.disagreeTopConsumerTypes?.count ?? 0)
                    }
                }

                Spacer()
                    .frame(height: 20)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("고민 상세보기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.white)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.send(action: .presentSheet)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                }
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .onAppear {
            viewModel.send(action: .loadDetail)
        }
        .confirmationDialog("MySheet", isPresented: $viewModel.isMySheetShowed) {
            Button {
                viewModel.send(action: .closeVote)
            } label: {
                Text("투표 지금 종료하기")
            }

            Button {
                viewModel.send(action: .deleteVote)
            } label: {
                Text("투표 삭제하기")
            }
        }
        .confirmationDialog("OtherSheet", isPresented: $viewModel.isOtherSheetShowed) {
            Button {
                // TODO: - 신고 action
            } label: {
                Text("신고하기")
            }

            Button {
                // TODO: - 차단 action
            } label: {
                Text("차단하기")
            }
        }
        .sheet(isPresented: $viewModel.isCommentShowed) {
            CommentsView()
                .presentationDetents([.height(600)])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.isVoteManageSucceed) { _ in
            router.pop()
        }
    }
}

extension DetailView {

    var commentPreview: some View {
        CommentPreview()
            .onTapGesture {
                viewModel.send(action: .presentComment)
            }
    }

    private func hiddenResultView(for type: VoteType, topConsumerTypesCount: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("투표 후 구매 \(type.title) 의견을 선택한 유형을 확인해봐요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            HStack {
                ForEach(0..<topConsumerTypesCount, id: \.self) { _ in
                    hiddenTypeLabel
                }
            }
            ProgressView(value: type.isAgree ? 1.0 : 0.0, total: 1.0)
                .progressViewStyle(CustomProgressStyle(foregroundColor: type.isAgree ? Color.lightBlue : Color.gray200,
                                                       height: 8))
        }
        .padding(.horizontal, 24)
    }

    private var hiddenTypeLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "questionmark")
                .font(.system(size: 14))
                .foregroundStyle(.white)
            Text("??????????")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.priceGray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.gray200)
        .clipShape(Capsule())
    }

    private func consumerTypeLabels(_ type: VoteType, topConsumerTypes: [ConsumerType]) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("구매 \(type.title) 의견")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.priceGray)
                HStack {
                    ForEach(topConsumerTypes, id: \.self) { consumerType in
                        ConsumerTypeLabel(consumerType: consumerType, usage: .standard)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }

    private func resultProgressView(_ type: VoteType, ratio: Double, isHigher: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(format: ratio.getFirstDecimalNum == 0 ? "%.0f" : "%.1f", ratio)
                     + "%의 친구들이 \(type.subtitle) 것을 추천했어요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
                
                ProgressView(value: ratio, total: 100.0)
                    .progressViewStyle(CustomProgressStyle(foregroundColor: isHigher ? Color.lightBlue : Color.gray200,
                                                           height: 8))
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 36)
    }
}

struct DetailContentView: View {
    var postDetailData: VoteDetailModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 13) {
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: postDetailData.post.author.consumerType) ?? .adventurer,
                                  usage: .standard)
                HStack(spacing: 6) {
                    if postDetailData.post.postStatus == PostStatus.closed.rawValue {
                        EndLabel()
                    }

                    Text(postDetailData.post.title)
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18, weight: .bold))

                }

                if let contents = postDetailData.post.contents {
                    Text(contents)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.whiteGray)
                }

                HStack(spacing: 0) {
                    if let price = postDetailData.post.price {
                        Text("가격: \(price)원")
                        Text(" · ")
                    }
                    Text(postDetailData.post.modifiedDate.convertToStringDate() ?? "")
                }
                .foregroundStyle(Color.priceGray)
                .font(.system(size: 14))
                .padding(.top, 3)
            }
            .padding(.bottom, 16)

            HStack {
                Label("\(postDetailData.post.voteCount ?? 333)명 투표",
                      systemImage: "person.2.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color.white)
                .frame(width: 94, height: 29)
                .background(Color.darkGray2)
                .clipShape(RoundedRectangle(cornerRadius: 34))
                Spacer()
            }
            .padding(.bottom, 4)

            if let externalURL = postDetailData.post.externalURL {
                Link(destination: URL(string: externalURL)!, label: {
                    Text(externalURL)
                        .tint(Color.white)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(.vertical,10)
                        .padding(.horizontal,14)
                        .background(Color.lightGray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                })
                .padding(.bottom, 4)
            }

            Group {
                if let imageURL = postDetailData.post.image {
                    ImageView(imageURL: imageURL)
                } else {
                    Image("imgDummyVote\((postDetailData.post.id) % 3 + 1)")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.5, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

#Preview {
    NavigationStack {
        DetailView(viewModel: .init(postId: 1, voteUseCase: StubVoteUseCase()))
    }
}
