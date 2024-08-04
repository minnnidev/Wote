//
//  SettingBlockView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

struct SettingBlockView: View {
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if viewModel.blockUsersList.isEmpty {
                Text("차단한 사용자가 없습니다.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.subGray1)
            } else {
                ScrollView {
                    Divider()
                        .foregroundStyle(Color.dividerGray)

                    ForEach(viewModel.blockUsersList, id: \.id) { user in
                        BlockListCell(
                            blockUser: user,
                            unblockButtonDidTapped: { id in
                                viewModel.send(action: .unblockUser(memberId: id))
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("차단 목록")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .onAppear {
            viewModel.send(action: .loadBlockUsers)
        }
    }
}

struct BlockListCell: View {
    var blockUser: BlockedUserModel
    var unblockButtonDidTapped: (Int) -> ()

    var body: some View {
        HStack {
            Image("defaultProfile")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 2)
            Text(blockUser.nickname)
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))

            Spacer()

            Button {
                unblockButtonDidTapped(blockUser.id)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 103, height: 44)
                        .foregroundStyle(Color.lightBlue)

                    Text("차단 해제하기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.woteWhite)
                }
            }
        }
        .padding(.horizontal, 8)

        Divider()
            .foregroundStyle(Color.dividerGray)
    }
}

#Preview {
    BlockListCell(
        blockUser: .stubBlockedUser1) { id in
            print("차단 해제하기")
        }
}
