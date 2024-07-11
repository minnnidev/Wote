//
//  SchoolSearchView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import SwiftUI

struct SchoolSearchView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var selectedSchoolInfo: SchoolInfoModel?

    @StateObject var viewModel: SchoolSearchViewModel

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                schoolSearchField
                    .padding(.horizontal, 16)

                schoolSearchResultView
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("학교 검색")
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .foregroundStyle(.white)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 100)
            }
        }
    }
}

extension SchoolSearchView {

    @ViewBuilder
    private var schoolSearchResultView: some View {
        switch viewModel.textFieldState {
        case .submitted:
            if viewModel.schools.isEmpty {
                emptyResultView
            } else {
                searchedSchoolList
                    .padding(.top, 16)
            }
        default:
            searchDescriptionView
                .padding(.top, 32)
        }
    }

    private var schoolSearchField: some View {
        TextField("",
                  text: $viewModel.searchSchoolText,
                  prompt: Text("학교명 검색")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(viewModel.textFieldState.placeholderColor))
            .font(.system(size: 16, weight: .medium))
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
            .frame(height: 44)
            .focused($isFocused)
            .background(viewModel.textFieldState.backgroundColor)
            .tint(Color.placeholderGray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                if viewModel.textFieldState == .active {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(viewModel.textFieldState.strokeColor, lineWidth: 1)
                        .blur(radius: 3)
                        .shadow(color: Color.shadowBlue, radius: 2)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(viewModel.textFieldState.strokeColor, lineWidth: 1)
            }
            .onSubmit {
                viewModel.send(action: .submit(viewModel.searchSchoolText))
            }
    }

    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image("imgNoResult")
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.subGray1)
        }
        .padding(.top, 170)
    }

    @ViewBuilder
    private var searchedSchoolList: some View {
        List(viewModel.schools.indices, id: \.self) { index in
            let school = viewModel.schools[index]
            SchoolListCell(schoolInfo: school, isLastCell: index == viewModel.schools.count - 1)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onTapGesture {
                let schoolModel = school.school
                selectedSchoolInfo = SchoolInfoModel(school: SchoolModel(schoolName: schoolModel.schoolName,
                                                                         schoolRegion: regionMapping[schoolModel.schoolRegion]
                                                                         ?? schoolModel.schoolRegion),
                                                     schoolAddress: school.schoolAddress)
                dismiss()
            }
        }
        .listStyle(.plain)
    }

    private var searchDescriptionView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("이렇게 검색해보세요")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.bottom, 20)
                Text("학교명")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.bottom, 5)
                Text("예) 세원고, 세원고등학교")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.subGray1)
            }
            Spacer()
        }
        .padding(.leading, 32)
    }
}

fileprivate struct SchoolListCell: View {
    let schoolInfo: SchoolInfoModel
    let isLastCell: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(schoolInfo.school.schoolName)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 13)
                    HStack(spacing: 5) {
                        infoLabel("도로명")
                        infoDescription(schoolInfo.schoolAddress ?? "")
                    }
                    .padding(.bottom, 10)
                    HStack(spacing: 16) {
                        infoLabel("지역")
                        infoDescription(schoolInfo.school.schoolRegion)
                    }
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .background(Color.clear)
            .padding(.vertical, 16)
            .padding(.horizontal, 26)

            if !isLastCell {
                Divider()
                    .background(Color.dividerGray)
                    .padding(.horizontal, 16)
            }
        }
    }

    private func infoLabel(_ labelName: String) -> some View {
        Text(labelName)
            .font(.system(size: 12, weight: .medium))
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.lightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 3.0))
    }

    private func infoDescription(_ description: String) -> some View {
        Text(description)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.infoGray)
    }
}

#Preview {
    SchoolSearchView(
        selectedSchoolInfo: .constant(.schoolInfoStub),
        viewModel: .init(userUseCase: StubUserUseCase())
    )
}
