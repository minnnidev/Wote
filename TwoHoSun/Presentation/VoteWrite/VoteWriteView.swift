//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import PhotosUI
import SwiftUI

struct VoteWriteView: View {
    @EnvironmentObject var voteRouter: NavigationRouter

    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isLinkFocused: Bool
    @FocusState private var isContentFocused: Bool

    @State private var isRegisterButtonDidTap: Bool = false
    @State private var isEditing: Bool = false

    @StateObject var viewModel: VoteWriteViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(spacing: 48) {
                        titleView

                        priceView

                        imageView

                        linkView

                        contentView

                        Spacer()
                    }
                    .padding(.top, 16)
                }
                voteRegisterButton
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("투표 만들기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .photosPicker(isPresented: $viewModel.isPhotoPickerShowed, selection: $viewModel.selectedItem)
            .confirmationDialog("imageAlert", isPresented: $viewModel.isImageSheetShowed) {
                Button {
                    viewModel.send(action: .presentPhotoPicker)
                } label: {
                    Text("수정하기")
                }

                Button {
                    viewModel.send(action: .removeImage)
                } label: {
                    Text("삭제하기")
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(NSNotification.voteStateUpdated)
        }
    }
}

extension VoteWriteView {

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerLabel("제목을 입력해주세요. ", essential: true)
                .padding(.bottom, 4)

            HStack(spacing: 6) {
                TextField("",
                          text: $viewModel.title,
                          prompt:
                            Text("예) 아이폰, 맥북 에어 사고싶은데")
                    .font(.system(size: 14))
                    .foregroundColor(Color.placeholderGray)
                )
                .font(.system(size: 14))
                .focused($isTitleFocused)
                .foregroundStyle(.white)
                .frame(height: 44) 
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        if isTitleFocused {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.activeBlack)
                                .shadow(color: Color.strokeBlue.opacity(isTitleFocused ? 0.25 : 0), radius: 4)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(!viewModel.isTitleValid && isRegisterButtonDidTap ? .red : Color.darkBlue, lineWidth: 1)
                    }
                )
            }

            if !viewModel.isTitleValid && isRegisterButtonDidTap {
                HStack(spacing: 8) {
                    Image(systemName: "light.beacon.max")
                    Text("제목을 입력해주세요.")
                }
                .font(.system(size: 12))
                .foregroundStyle(.red)
            }
        }
    }
    
    private var priceView: some View {
        VStack(alignment: .leading) {
            headerLabel("해당 상품의 가격을 알려주세요.", essential: false)
            HStack {
                TextField("",
                          text: $viewModel.price,
                          prompt: Text("예) 200,000")
                    .font(.system(size: 14))
                    .foregroundColor(Color.placeholderGray)
                )
                .focused($isPriceFocused)
                .font(.system(size: 14))
                .keyboardType(.numberPad)
                Text("원")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(
                ZStack {
                    if isPriceFocused {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.activeBlack)
                            .shadow(color: Color.strokeBlue.opacity(isPriceFocused ? 0.25 : 0), radius: 4)
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkBlue, lineWidth: 1)
                }
            )
        }
    }
    
    private var imageView: some View {
        VStack(alignment: .leading) {
            headerLabel("고민하는 상품의 사진을 등록해 주세요. ", essential: false)

            if let data = viewModel.selectedData,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipShape(.rect(cornerRadius: 16))
                    .onTapGesture {
                        isEditing.toggle()
                        viewModel.isImageSheetShowed.toggle()
                    }
            } else {
                Button {
                    viewModel.send(action: .presentPhotoPicker)
                } label: {
                    HStack(spacing: 7) {
                        Image(systemName: "plus")
                            .font(.system(size: 16))
                        Text("상품 이미지")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(Color.lightBlue)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.darkBlue, lineWidth: 1)
                    }
                }
            }
        }
    } 
    
    private var linkView: some View {
        VStack(alignment: .leading) {
            headerLabel("해당 상품의 링크를 등록해 주세요. ", essential: false)
            TextField("",
                      text: $viewModel.externalURL,
                      prompt: Text("예) 상품 페이지 주소 붙여넣기")
                .font(.system(size: 14))
                .foregroundColor(Color.placeholderGray)
            )
            .font(.system(size: 14))
            .focused($isLinkFocused)
            .foregroundStyle(.white)
            .frame(height: 44)
            .padding(.horizontal, 16)
            .background(
                ZStack {
                    if isLinkFocused {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.activeBlack)
                            .shadow(color: Color.strokeBlue.opacity(isLinkFocused ? 0.25 : 0), radius: 4)
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.darkBlue, lineWidth: 1)
                }
            )
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            headerLabel("고민하는 내용을 작성해 주세요. ", essential: false)
            textEditorView
        }
    }
    
    private var textEditorView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.content.isEmpty {
                TextEditor(text: $viewModel.placeholderText)
                    .foregroundStyle(Color.placeholderGray)
                    .scrollContentBackground(.hidden)
            }

            TextEditor(text: $viewModel.content)
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 24)
                .focused($isContentFocused)

            contentTextCountView
                .padding(.bottom, 4)
                .padding(.trailing, 4)
        }
        .font(.system(size: 14, weight: .medium))
        .frame(height: 110)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                if isContentFocused {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.activeBlack)
                        .shadow(color: Color.strokeBlue.opacity(isContentFocused ? 0.25 : 0), radius: 4)
                }
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
        )
        .onSubmit {
            dismissKeyboard()
        }
    }
    
    private var contentTextCountView: some View {
        Text("\(viewModel.content.count) ")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color.subGray1)
        + Text("/ 150")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
    }
    
    private var voteRegisterButton: some View {
        Button {
            isRegisterButtonDidTap = true

            if viewModel.isTitleValid {
                viewModel.send(action: .createVote)
                voteRouter.pop()
            }
        } label: {
            Text("등록하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.title != "" ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
    }
    
    private func headerLabel(_ title: String, essential: Bool) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
        + Text(essential ? "(필수)" : "(선택)")
            .font(.system(size: 12, weight: essential ? .semibold : .medium))
            .foregroundColor(essential ? .red : Color.subGray3)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

#Preview {
    VoteWriteView(
        viewModel: .init(photoUseCase: StubPhotoUseCase(),
                         voteUseCase: StubVoteUseCase())
    )
}
