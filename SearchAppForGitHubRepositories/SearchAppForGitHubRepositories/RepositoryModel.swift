//
//  RepositoryModel.swift
//  SearchAppForGitHubRepositories
//
//  Created by 河田翔也 on 2026/01/21.
//

import Foundation

struct GitHubResponse: Codable {
    let items: [Repository]
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case htmlUrl = "html_url"
    }
}
