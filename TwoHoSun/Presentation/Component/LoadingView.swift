//
//  LoadingView.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lightGray.opacity(0.8))
                .frame(width: 100, height: 100)

            ProgressView()
                .controlSize(.large)
        }
    }
}

#Preview {
    LoadingView()
}
