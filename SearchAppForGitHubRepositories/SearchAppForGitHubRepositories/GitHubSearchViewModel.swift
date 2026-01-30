//
//  GitHubSearchViewModel.swift
//  SearchAppForGitHubRepositories
//
//  Created by 河田翔也 on 2026/01/21.
//

import Foundation
import Combine

class GitHubSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .handleEvents(receiveOutput: {
                [weak self] _ in
                self?.isLoading = true
            })
            .flatMap { query in
                self.searchRepositories(query: query)
            }
            // メイン画面のルートへ戻る
            .receive(on: RunLoop.main)
                        .sink { [weak self] repos in
                            self?.isLoading = false
                            // 結果を代入
                            self?.repositories = repos
                        }
                        // 保存
                        .store(in: &cancellables)
    }
    
    // API通信の実務を行うメソッド
        private func searchRepositories(query: String) -> AnyPublisher<[Repository], Never> {
            let urlString = "https://api.github.com/search/repositories?q=\(query)"
            guard let url = URL(string: urlString) else {
                return Just([]).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: GitHubResponse.self, decoder: JSONDecoder())
                .map { $0.items }
                // エラーが起きても空配列を流してパイプを止めない
                .replaceError(with: [])
                .eraseToAnyPublisher()
        }
}
