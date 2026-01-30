//
//  ContentView.swift
//  SearchAppForGitHubRepositories
//
//  Created by 河田翔也 on 2026/01/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GitHubSearchViewModel()
    var body: some View {
        NavigationView {
            VStack {
                TextField("", text: $viewModel.searchText, prompt: Text("GitHubレポジトリを検索").foregroundColor(.white))
                    .padding()
                    .frame(width: .infinity, height: 50)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding()
                ZStack {
                    // 結果リスト
                    List(viewModel.repositories) { repo in
                        Link(destination: URL(string: repo.htmlUrl)!) {
                            VStack(alignment: .leading) {
                                Text(repo.name)
                                    .font(.headline)
                                if let desc = repo.description {
                                    Text(desc)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
                if viewModel .isLoading {
                    ProgressView("検索中...")
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .navigationTitle(Text("GitHub検索"))
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
