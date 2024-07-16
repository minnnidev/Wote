//
//  VoteListView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

struct VoteListView: View {
    @State private var isRefreshing = false

    @Binding var visibilityScope: VisibilityScopeType

    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false

    @StateObject var viewModel = VoteListViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                votePagingView
                Spacer()
            }

            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .errorAlert(error: $viewModel.error) {
            viewModel.fetchPosts(visibilityScope: visibilityScope)
        }
    }
}

extension VoteListView {

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView(selection: $viewModel.currentVote) {
                Group {
//                    VoteContentCell(data: viewModel.posts[0],
//                                    index: 0)
                    nextVoteButton
                        .padding(.top, 16)
                }
                .tag(0)
                .rotationEffect(.degrees(-90))
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.height, height: proxy.size.width)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if viewModel.currentVote == 0 && value.translation.height > 0 && !isRefreshing {
                            isRefreshing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.fetchPosts(visibilityScope: visibilityScope,
                                                     isRefresh: true)
                                isRefreshing = false
                            }
                        }
                    }
            )
        }
    }

    private var createVoteButton: some View {
        Button {
            // TODO: - 등록 뷰로 이동
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "plus")
                Text("투표만들기")
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .background(Color.lightBlue)
            .clipShape(Capsule())
        }
    }

    private var endLabel: some View {
        Text("종료")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.disableGray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private var nextVoteButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    if viewModel.currentVote != viewModel.posts.count - 1 {
                        viewModel.currentVote += 1
                    }
                }
            } label: {
                Image("icnCaretDown")
                    .opacity(viewModel.currentVote != viewModel.posts.count - 1 ? 1 : 0)
            }
            Spacer()
        }
    }
}

#Preview {
    VoteListView(
        visibilityScope:.constant(VisibilityScopeType.global)
    )
}
