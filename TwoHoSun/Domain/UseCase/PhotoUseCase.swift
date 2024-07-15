//
//  PhotoUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/15/24.
//

import SwiftUI
import PhotosUI
import Combine

protocol PhotoUseCaseType {
    func loadTransferable(_ item: PhotosPickerItem?) -> AnyPublisher<Data, PhotoPickerError>
}

final class PhotoUseCase: PhotoUseCaseType {

    func loadTransferable(_ item: PhotosPickerItem?) -> AnyPublisher<Data, PhotoPickerError> {
        Future<Data, PhotoPickerError> { promise in
            guard let item = item else { return }
            
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case let .success(data):
                    if let data = data {
                        promise(.success(data))
                    } else {
                        promise(.failure(PhotoPickerError.invalid))
                    }
                    return
                case .failure(_):
                    promise(.failure(PhotoPickerError.importFaild))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

final class StubPhotoUseCase: PhotoUseCaseType {
    
    func loadTransferable(_ item: PhotosPickerItem?) -> AnyPublisher<Data, PhotoPickerError> {
        Empty()
            .eraseToAnyPublisher()
    }
}
