//
//  MyPageView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

enum MyPageListType {
    case myVote, myReview

    var title: String {
        switch self {
        case .myVote:
            return "나의 투표"
        case .myReview:
            return "나의 후기"
        }
    }
}

struct MyPageView: View {
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false

    @StateObject var viewModel: MyPageViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileHeaderView
                    .padding(.top, 24)
                    .padding(.bottom, haveConsumerType ? 24 : 0)

                if !haveConsumerType {
                    GoToTypeTestButton()
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }

                ScrollViewReader { proxy in
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        Section {
                            myPageListTypeView
                        } header: {
                            sectionHeaderView
                        }
                        .id("myPageList")
                    }
                }
            }
        }
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .onAppear {
            // TODO: API
        }
        .refreshable {
            viewModel.fetchPosts()
        }
    }
}

extension MyPageView {

    private var profileHeaderView: some View {
        Button {
            // TODO: 화면 전환
        } label: {
            HStack(spacing: 14) {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 103, height: 103)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text("")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.trailing, 12)

                        ConsumerTypeLabel(consumerType: .adventurer, usage: .standard)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.subGray1)
                    }
                    Text("")
                        .font(.system(size: 14))
                }
                .foregroundStyle(.white)
            }
            .padding(.leading, 24)
            .padding(.trailing, 16)
        }
    }

    private var sectionHeaderView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                HStack(spacing: 19) {
                    myPageListTypeButton(for: .myVote)
                    myPageListTypeButton(for: .myReview)
                    Spacer()
                }
                .padding(.bottom, 9)
                .padding(.horizontal, 24)

                HStack {
                    Text("\(viewModel.total)건")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)

                Divider()
                    .background(Color.dividerGray)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 23)
            .background(Color.background)
        }
    }

    private func myPageListTypeButton(for type: MyPageListType) -> some View {
        VStack(spacing: 10) {
            Text(type.title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(type == viewModel.selectedMyPageListType ? Color.lightBlue : Color.fontGray)
            
            Rectangle()
                .frame(width: 66, height: 2)
                .foregroundStyle(type == viewModel.selectedMyPageListType ? Color.lightBlue : Color.clear)
        }
        .onTapGesture {
            viewModel.selectedMyPageListType = type
        }
    }
    
    @ViewBuilder
    private var myPageListTypeView: some View {
        switch viewModel.selectedMyPageListType {
        case .myVote:
            let myPosts: [ReviewModel] = [.init(id: 1,
                                                     createDate: "",
                                                     modifiedDate: "",
                                                     postStatus: "CLOSED",
                                                     title: "투표 테스트")]
//            ForEach(Array(zip(myPosts.indices, myPosts)), id: \.0) { index, post in
//                Button {
//
//                } label: {
//                    VStack(spacing: 0) {
//                        VoteCardCell(cellType: .myVote,
//                                      progressType: PostStatus(rawValue: post.postStatus) ?? .closed,
//                                      data: post)
//                        Divider()
//                            .background(Color.dividerGray)
//                            .padding(.horizontal, 8)
//                    }
//                }
//                .onAppear {
//                    if index == myPosts.count - 4 {
//                        viewModel.fetchMorePosts()
//                    }
//                }
//            }
//            .padding(.horizontal, 8)

        case .myReview:
            let myReviews: [ReviewModel] = [.init(id: 2,
                                                       createDate: "",
                                                       modifiedDate: "",
                                                       postStatus: "CLOSED",
                                                       title: "후기 테스트")]

            ForEach(Array(zip(myReviews.indices, myReviews)), id: \.0) { index, data in
                Button {

                } label: {
                    VStack(spacing: 0) {
                        ReviewCardCell(cellType: .myReview,
                                       data: data)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                    .onAppear {
                        if index == myReviews.count - 4 {
                            viewModel.fetchMorePosts()
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

#Preview {
    MyPageView(viewModel: .init(myPageUseCase: StubMyPageUseCase()))
}
