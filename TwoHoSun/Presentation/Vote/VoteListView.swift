//
//  VoteListView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

struct VoteListView: View {
    @EnvironmentObject var appDependency: AppDependency
    @EnvironmentObject var voteRouter: NavigationRouter

    @State private var isRefreshing = false

    @StateObject var viewModel: VoteListViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                WoteNavigationBar(
                    selectedTab: .constant(.consider),
                    visibilityScope: $viewModel.visibilityScope,
                    router: voteRouter
                )

                Spacer()

                votePagingView

                Spacer()
            }

            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .onAppear {
            viewModel.send(action: .loadVotes)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationDestination(for: VoteTabDestination.self) { dest in
            switch dest {
            case let .voteDetail(postId):
                DetailView(viewModel: appDependency.container.resolve(DetailViewModel.self, argument: postId)!)
            case .voteWrite:
                VoteWriteView()
            }
        }
    }
}

extension VoteListView {

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView(selection: $viewModel.currentVote) {
                ForEach(Array(zip(viewModel.votes.indices,
                                  viewModel.votes)), id: \.0) { index, item in
                    VStack(spacing: 0) {
                        VoteContentCell(
                            vote: item,
                            voteTapped: {
                                viewModel.send(action: .vote(selection: $0))
                            }, detailTapped: {
                                voteRouter.push(to: VoteTabDestination.voteDetail(postId: item.id))
                            }
                        )

                        nextVoteButton
                            .padding(.top, 16)
                    }
                    .tag(index)
                    .onAppear {
                        if (index == viewModel.votes.count - 2) {
                            viewModel.send(action: .loadMoreVotes)
                        }
                    }
                }
                .rotationEffect(.degrees(-90)) 
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.height, height: proxy.size.width)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private var createVoteButton: some View {
        Button {
            voteRouter.push(to: VoteTabDestination.voteWrite)
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
                    if viewModel.currentVote != viewModel.votes.count - 1 {
                        viewModel.currentVote += 1
                    }
                }
            } label: {
                Image("icnCaretDown")
                    .opacity(viewModel.currentVote != viewModel.votes.count - 1 ? 1 : 0)
            }
            Spacer()
        }
    }
}

#Preview {
    VoteListView(
        viewModel: .init(voteUseCase: StubVoteUseCase())
    )
    .environmentObject(AppDependency())
    .environmentObject(NavigationRouter())
}
