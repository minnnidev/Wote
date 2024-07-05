//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Combine
import Foundation

final class ReviewWriteViewModel: ObservableObject {
    @Published var isPurchased: Bool = true
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var content: String = ""
    @Published var image: Data?

    @Published var isCreatingReview = false
    @Published var review: ReviewCreateModel?
    @Published var isCompleted = false

    private var cancellable = Set<AnyCancellable>()


    var isValid: Bool {
        if isPurchased {
            if !title.isEmpty && image != nil {
                return true
            } else {
                return false
            }
        } else {
            if !title.isEmpty {
                return true
            } else {
                return false
            }
        }
    }

    func setReview() {
        review = ReviewCreateModel(title: title,
                                   contents: content.isEmpty ? nil : content,
                                   price: price.isEmpty ? nil : Int(price),
                                   isPurchased: isPurchased,
                                   image: image)
    }
    
    func createReview() {
        isCreatingReview.toggle()
        setReview()
        guard let review = review else { return isCreatingReview.toggle()}

        // TODO: 리뷰 등록 API
    }
    
    func clearData(_ state: Bool) {
        isPurchased = state
        title = ""
        price = ""
        content = ""
        image = nil
    }
}
