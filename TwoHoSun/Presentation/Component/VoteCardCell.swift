//
//  VoteCardView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//
import SwiftUI
import Kingfisher

struct VoteCardCell: View {

    enum VoteCardCellType {
        case standard
        case myVote
    }

    var cellType: VoteCardCellType
    var data: VoteModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if data.postStatus == PostStatus.closed.rawValue {
                            EndLabel()
                        }

                        Text(data.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }

                    Text(data.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    
                    HStack(spacing: 0) {
                        if let price = data.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }
                        Text(data.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }

                Spacer()

                ZStack {
                    CardImageView(imageURL: data.image)
                        .opacity(data.postStatus == PostStatus.closed.rawValue
                                 ? 0.5 : 1.0)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(cellType != .myVote ? Color.disableGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

}

#Preview {
    VoteCardCell(
        cellType: .standard,
        data: .voteStub2
    )
}
