//
//  ProfileModifyView.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import SwiftUI

struct ProfileModifyView: View {

    @StateObject var viewModel: ProfileModifyViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileModifyView(viewModel: .init(userUseCase: StubUserUseCase()))
}
