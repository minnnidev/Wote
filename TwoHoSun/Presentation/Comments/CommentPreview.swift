//
//  CommentPreview.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct CommentPreview: View {
    var previewComment: String?
    var commentCount: Int?
    var commentPreviewImage: String?

    var body: some View {
        VStack {
            commentHeaderView()
            commentBodyView()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension CommentPreview {

    private func commentHeaderView() -> some View {
        HStack(spacing: 4) {
            Text("댓글")
                .foregroundColor(.priceGray)
                .font(.system(size: 14, weight: .medium))
            if let count = commentCount {
                Text("\(count)개")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            Spacer()
        }
    }

    private func commentBodyView() -> some View {
        HStack(spacing: 7) {
            profileImageView()
            commentTextView()
        }
        .frame(maxWidth: .infinity)
        .background(commentCount == nil ? Color.textFieldGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private func profileImageView() -> some View {
        if let previewImage = commentPreviewImage {
            ProfileImageView(imageURL: previewImage)
                .frame(width: 24, height: 24)
        } else {
            ProfileImageView(imageURL: UserData.shared.userProfile.profileImage)
                .frame(width: 24, height: 24)
        }
    }

    private func commentTextView() -> some View {
        HStack {
            if let previewComment = previewComment {
                Text(previewComment)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
            } else {
                Text("댓글 추가...")
                    .font(.system(size: 12))
                    .foregroundColor(.priceGray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
            }
            Spacer()
        }
    }
}

#Preview {
    CommentPreview()
}
