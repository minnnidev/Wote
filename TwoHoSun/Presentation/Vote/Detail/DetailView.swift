//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss

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
                                // TODO: 살말 비율 VoteResultView

//                                VoteResultView(myChoice: viewModel.pos,
//                                               agreeRatio: agreeRatio,
//                                               disagreeRatio: disagreeRatio)

                            } else {
                                IncompletedVoteButton(choice: .agree) {
                                    // TODO: 투표하기 API 연동

                                }
                                IncompletedVoteButton(choice: .disagree) {
                                    // TODO: 투표하기 API 연동
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

                // TODO: - Vote Consumer Result

                if viewModel.isVoteConsumerTypeResultShowed {
                    if viewModel.isVoteResultShowed {
//                        let (agreeRatio, disagreeRatio) = viewModel.calculatVoteRatio(voteCounts: data.post.voteCounts)
//                        consumerTypeLabels(.agree, topConsumerTypes: viewModel.agreeTopConsumerTypes)
//                        resultProgressView(.agree,
//                                           ratio: agreeRatio,
//                                           isHigher: agreeRatio >= disagreeRatio)
//                        consumerTypeLabels(.disagree,
//                                           topConsumerTypes: viewModel.disagreeTopConsumerTypes)
//                        resultProgressView(.agree,
//                                           ratio: disagreeRatio,
//                                           isHigher: disagreeRatio >= agreeRatio)
                    } else {
                        hiddenResultView(for: .agree,
                                         topConsumerTypesCount: viewModel.agreeTopConsumerTypes.count)
                            .padding(.bottom, 34)
                        hiddenResultView(for: .disagree,
                                         topConsumerTypesCount: viewModel.disagreeTopConsumerTypes.count)
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
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .onAppear {
            viewModel.send(action: .loadDetail)
        }
    }
}

extension DetailView {

    var commentPreview: some View {
        CommentPreview(previewComment: viewModel.voteDetail?.commentPreview,
                       commentCount: viewModel.voteDetail?.commentCount,
                       commentPreviewImage: viewModel.voteDetail?.commentPreviewImage)
//        .onTapGesture {
            // TODO: 소비 성향 테스트 안 했을 시, 소비 성향 테스트로 이동
            // TODO: 완료했을 시 댓글 보기
//        }
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
    DetailView(viewModel: .init(postId: 1, voteUseCase: StubVoteUseCase()))
}
