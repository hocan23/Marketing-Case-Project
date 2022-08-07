//
//  ProductModel.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/6/22.
//

import Foundation


struct Welcome: Codable {
    let products: [Product]
    let totalProductCount: Int
    let filterOptions: [FilterOption]
    let sortOptions: [SortOption]

    enum CodingKeys: String, CodingKey {
        case products
        case totalProductCount = "total_product_count"
        case filterOptions = "filter_options"
        case sortOptions = "sort_options"
    }
}
struct SortOption: Codable {
    let id: String
    let name: String
}

// MARK: - FilterOption
struct FilterOption: Codable {
    let name: String
    let values: [String]
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let price: Double
    let name: String
    let category: Category
    let currency: Currency
    let imageName: String
    let color: Color
    var isFavorite : Bool?
    var isInBag : Bool?

    enum CodingKeys: String, CodingKey {
        case id, price, name, category, currency
        case imageName = "image_name"
        case color
    }
}

enum Category: String, Codable {
    case coat = "Coat"
    case dress = "Dress"
    case sweater = "Sweater"
}

enum Color: String, Codable {
    case black = "Black"
    case blue = "Blue"
    case white = "White"
}

enum Currency: String, Codable {
    case usd = "USD"
}

 
