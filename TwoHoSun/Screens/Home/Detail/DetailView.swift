//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppLoginState.self) private var loginStateManager
    @State private var showconfirm = false
    @State private var backgroundColor: Color = .background
    @State private var showCustomAlert = false
    @State private var applyComplaint = false
    @State private var showAlert = false
    @State private var currentAlert = AlertType.closeVote
    @StateObject var viewModel: DetailViewModel
    var isShowingHeader = true
    @State var showDetailComments = false
    var postId: Int
    var index: Int?

    var directComments = false
    let commentNotification = NotificationCenter.default.publisher(for: Notification.Name("showComment"))
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            if let data = viewModel.postDetail {
                ScrollView {
                    VStack(spacing: 0) {
                        if isShowingHeader {
                            DetailHeaderView(data: data)
                                .padding(.top, 18)
                            Divider()
                                .background(Color.disableGray)
                                .padding(.horizontal, 12)
                        }
                        DetailContentView(postDetailData: data)
                            .padding(.top, 27)
                        VStack {
                            if data.post.postStatus == "CLOSED" || data.post.myChoice != nil {
                                let (agreeRatio, disagreeRatio) = viewModel.calculatVoteRatio(voteCounts: data.post.voteCounts)
                                VoteResultView(myChoice: data.post.myChoice,
                                               agreeRatio: agreeRatio,
                                               disagreeRatio: disagreeRatio)

                            } else {
                                IncompletedVoteButton(choice: .agree) {
                                    viewModel.votePost(postId: data.post.id,
                                                       choice: true,
                                                       index: index ?? 0)
                                }
                                IncompletedVoteButton(choice: .disagree) {
                                    viewModel.votePost(postId: data.post.id,
                                                       choice: false,
                                                       index: index ?? 0)
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        commentPreview
                            .padding(.horizontal, 24)
                            .padding(.vertical, 48)

                        if data.post.voteCount != 0 {
                            if data.post.postStatus == "CLOSED" || data.post.myChoice != nil {
                                let (agreeRatio, disagreeRatio) = viewModel.calculatVoteRatio(voteCounts: data.post.voteCounts)
                                consumerTypeLabels(.agree, topConsumerTypes: viewModel.agreeTopConsumerTypes)
                                resultProgressView(.agree,
                                                   ratio: agreeRatio,
                                                   isHigher: agreeRatio >= disagreeRatio)
                                consumerTypeLabels(.disagree,
                                                   topConsumerTypes: viewModel.disagreeTopConsumerTypes)
                                resultProgressView(.agree,
                                                   ratio: disagreeRatio,
                                                   isHigher: disagreeRatio >= agreeRatio)
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
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
            }

            if showDetailComments {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
            }

            if showCustomAlert {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    CustomAlertModalView(alertType: currentAlert,
                                         isPresented: $showCustomAlert) {
                        switch currentAlert {
                        case .closeVote:
                            viewModel.closePost(postId: postId,
                                                index: index ?? 0)
                            showCustomAlert.toggle()
                        case .deleteVote:
                            viewModel.deletePost(postId: postId,
                                                 index: index ?? 0)
                            showCustomAlert.toggle()
                            dismiss()
                        default:
                            break
                        }
                    }
                }
            }

            if applyComplaint {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightBlue)
                        .frame(width: 283, height: 36)

                    Text("신고해주셔서 감사합니다.")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .onTapGesture {
                    applyComplaint.toggle()
                }
            }
            
            if showAlert {
                CustomAlertModalView(alertType: .ban(nickname: viewModel.postDetail?.post.author.nickname ?? ""), isPresented: $showAlert) {
                    loginStateManager.serviceRoot.memberManager.blockUser(memberId: viewModel.postDetail?.post.author.id ?? 0)
                    showAlert.toggle()
                    dismiss()
                }
            }
        }
        .onReceive(commentNotification) {_ in
            self.showDetailComments.toggle()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showconfirm.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                }
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showDetailComments) {
            CommentsView(showComplaint: $showCustomAlert,
                         applyComplaint: $applyComplaint,
                         viewModel: CommentsViewModel(apiManager: loginStateManager.serviceRoot.apimanager, postId: postId))
            .presentationDetents([.large,.fraction(0.9)])
            .presentationContentInteraction(.scrolls)
        }
        .customConfirmDialog(isPresented: $showconfirm, isMine: $viewModel.isMine) { _ in
            if viewModel.isMine {
                VStack(spacing: 15) {
                    if viewModel.postDetail?.post.postStatus != PostStatus.closed.rawValue {
                        Button {
                            currentAlert = .closeVote
                            showCustomAlert.toggle()
                            showconfirm.toggle()
                        } label: {
                            Text("투표 지금 종료하기")
                                .frame(maxWidth: .infinity)
                        }
                        Divider()
                            .background(Color.gray300)
                    }
                    Button {
                        currentAlert = .deleteVote
                        showCustomAlert.toggle()
                        showconfirm.toggle()
                    } label: {
                        Text("삭제하기")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 15)
            } else {
                VStack(spacing: 15) {
                    Button {
                        showconfirm.toggle()
                    } label: {
                        Text("신고하기")
                            .frame(maxWidth: .infinity)
                    }
                    Divider()
                        .background(Color.gray300)
                    Button {
                        showAlert.toggle()
                        showconfirm.toggle()
                    } label: {
                        Text("차단하기")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 15)
            }
        }
        .onAppear {
            if directComments {
                showDetailComments.toggle()
            }
            viewModel.postDetail = nil
            viewModel.fetchPostDetail(postId: postId)
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(commentNotification)
        }
    }
}

extension DetailView {

    var commentPreview: some View {
        CommentPreview()
            .onTapGesture {
                showDetailComments.toggle()
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
    var postDetailData: PostDetailModel

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
                Button {
                    print("이야 공유하자")
                } label: {
                    Label("공유", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .frame(width: 63, height: 29)
                        .background(Color.lightBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                }
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
