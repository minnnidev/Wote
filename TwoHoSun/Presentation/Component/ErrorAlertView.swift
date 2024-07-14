//
//  ErrorAlertView.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import SwiftUI

struct ErrorAlertView: View {
    @Binding var isPresented: Bool
    let error: WoteError

    var body: some View {
        ZStack {
            Color.clear
                .alert(error.localizedDescription, isPresented: $isPresented) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("OK")
                    }
                }

        }
    }
}

#Preview {
    ErrorAlertView(
        isPresented: .constant(true),
        error: WoteError.authenticateFailed
    )
}
