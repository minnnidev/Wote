//
//  HomeView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/16/23.
//

import SwiftUI

struct MainView: View {
    enum FilterType : CaseIterable {
        case all, popular, currentvote, finishvote
        var title: String {
            switch self {
            case .all:
                return "전체"
            case .popular:
                return "인기"
            case .currentvote:
                return "투표진행중"
            case .finishvote:
                return "종료된투표"
            }
        }
    }

    @State private var filterState: FilterType = .all
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack {
                        filterBar
                        HStack {
                            Text("ii")
                        }
                    }
                }
                floatingButton
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("splash")
                        .resizable()
                        .frame(width: 120,height: 36)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        noticeButton
                        searchButton
                    }
                }
            }

        }
    }
}

extension MainView {
    private var noticeButton: some View {
        Button(action: {
            // TODO: 알림페이지로 넘어가도록
        }, label: {
            Image(systemName: "bell.fill")
        })
    }
    private var searchButton: some View {
        Button(action: {
            // TODO: 통합검색으로 이동하도록
        }, label: {
            Image(systemName: "magnifyingglass")
        })
    }
    private var filterBar: some View {
        HStack(spacing: 8) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                filterButton(filter.title)
            }
            Spacer()
        }
        .padding(.top, 30)
        .padding(.leading, 26)
    }

    private var floatingButton: some View {
        Button {

        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20))
                .padding(16)
                .background(Color.white)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .shadow(radius: 7, x: 2, y: 2)
        }
        .padding(.trailing, 26)
        .padding(.bottom, 12)
    }

    func filterButton(_ title: String) -> some View {
        let isSelected = filterState.title == title
        return Button {
            filterState = FilterType.allCases.first { $0.title == title } ?? .all
        } label: {
            Text(title)
                .font(.system(size: 14))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(isSelected ? Color.white : Color.primary)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill( isSelected ? Color.gray : Color.clear)
                        .stroke(Color.gray, lineWidth: 1.0)
                )
        }
    }
}
#Preview {
    NavigationView {
        MainView()
    }
}
