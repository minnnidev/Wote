//
//  ProfileSettingsView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/16/23.
//

import PhotosUI
import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var appDependency: AppDependency
    
    @FocusState private var focusState: Bool
    
    @StateObject var viewModel: ProfileSettingViewModel
    
    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                titleLabel
                    .padding(.top, 40)
                Spacer()
                
                profileImageView
                
                Spacer()
                
                nicknameInputView
                    .padding(.bottom, 34)
                
                schoolInputView
                
                Spacer()
                
                nextButton
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            endTextEditing()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .confirmationDialog("Profile Modify Sheet", isPresented: $viewModel.isProfileSheetShowed) { 
            Button {
                viewModel.send(.initImages)
            } label: {
                Text("프로필 삭제하기")
            }

            Button {
                viewModel.send(.presentPhotoPicker)
            } label: {
                Text("프로필 수정하기")
            }
        }
        .photosPicker(isPresented: $viewModel.isPhotoPickerShowed, selection: $viewModel.selectedImage)
    }
}

extension ProfileSettingsView {
    
    private var titleLabel: some View {
        HStack(spacing: 7) {
            VStack(alignment: .leading, spacing: 9) {
                Image("logo")
                    .resizable()
                    .frame(width: 86, height: 28)
                Text("설정해")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color.white)
            }
            
            VStack(alignment: .leading) {
                Text("프로필")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.white) +
                Text("을")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color.white)
                Text("주세요.")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color.white)
            }
            Spacer()
        }
    }
    
    private var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let data = viewModel.selectedImageData,
                let image = UIImage(data: data) {
                Button {
                    viewModel.send(.presentProfileModifySheet)
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                }
            } else {
                Button {
                    viewModel.send(.presentPhotoPicker)
                } label: {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 130, height: 130)
                }
            }

            selectProfileButton
        }
    }
    
    private var selectProfileButton: some View {
        ZStack {
            Circle()
                .frame(width: 34, height: 34)
                .foregroundStyle(Color.lightBlue)
            Image(systemName: "plus")
                .font(.system(size: 20))
                .foregroundStyle(.white)
        }
    }

    private var nicknameInputView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .modifier(TitleTextStyle())
            
            HStack(spacing: 10) {
                TextField("",
                          text: $viewModel.nickname,
                          prompt: Text(ProfileInputType.nickname.placeholder)
                    .font(.system(size: 12))
                    .foregroundColor(Color.placeholderGray))
                .foregroundColor(Color.white)
                .font(.system(size: 14))
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(viewModel.nicknameValidationType.textfieldBorderColor, lineWidth: 1)
                        if (focusState || viewModel.nicknameValidationType == .empty || viewModel.nicknameValidationType == .none) {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(viewModel.nicknameValidationType.textfieldBorderColor, lineWidth: 1)
                                .shadow(color: Color.strokeBlue.opacity(0.15), radius: 2)
                                .blur(radius: 3)
                        }
                    }
                }
                checkDuplicatedIdButton
            }
            nicknameValidationAlertMessage(for: viewModel.nicknameValidationType)
                .padding(.top, 6)
        }
    }
    
    private var checkDuplicatedIdButton: some View {
        Button {
            viewModel.send(.checkDuplicatedNickname(viewModel.nickname))
            
            if viewModel.nicknameValidationType == .valid {
                endTextEditing()
            }
            
        } label: {
            Text("중복확인")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 103, height: 44)
                .background(Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.nicknameValidationType == .length)
    }
    
    @ViewBuilder
    private var schoolInputView: some View {
        NavigationLink {
            SchoolSearchView(
                selectedSchoolInfo: $viewModel.selectedSchoolInfo,
                viewModel: appDependency.container.resolve(SchoolSearchViewModel.self)!
            )
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Text("우리 학교")
                    .modifier(TitleTextStyle())
                
                roundedIconTextField(for: .school,
                                     text: viewModel.selectedSchoolInfo?.school.schoolName,
                                     isFilled: viewModel.isSchoolFilled)
                
                if !viewModel.isFormValid && !viewModel.isSchoolFilled {
                    schoolValidationAlertMessage
                        .padding(.top, 6)
                }
            }
        }
    }
    
    private var nextButton: some View {
        Button {
            guard viewModel.isAllInputValid else {
                viewModel.setInvalidCondition()
                return
            }
            
            viewModel.send(.completeProfileSetting)
        } label: {
            Text("완료")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(viewModel.isAllInputValid ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.isAllInputValid ? false : true)
    }
    
    private func roundedIconTextField(for input: ProfileInputType, text: String?, isFilled: Bool) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text(text ?? input.placeholder)
                    .font(.system(size: 14))
                    .foregroundColor(text != nil ? .white : Color.placeholderGray)
                    .frame(height: 45)
                    .padding(.leading, 17)
                
                Spacer()
                
                Image(systemName: input.iconName)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.placeholderGray)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(!isFilled && !viewModel.isFormValid ? Color.errorRed : Color.grayStroke, lineWidth: 1)
            }
        }
    }
    
    private func nicknameValidationAlertMessage(for input: NicknameValidationType) -> some View {
        HStack(spacing: 8) {
            Image(systemName: viewModel.nicknameValidationType == .valid ?
                  "checkmark.circle.fill" : "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(viewModel.nicknameValidationType.alertMessageColor)
    }
    
    private var schoolValidationAlertMessage: some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(ProfileInputType.school.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.errorRed)
    }
    
    struct TitleTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileSettingsView(
            viewModel: .init(userUseCase: StubUserUseCase(),
                             photoUseCase: StubPhotoUseCase())
        )
        .environmentObject(AppDependency())
    }
}
