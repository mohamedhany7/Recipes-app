//
//  Recipe.swift
//  Recipes
//
//  Created by Mohamed Hany on 04/06/2022.
//

import Foundation

class Recipe: Codable{
    let image: String
    let label: String
    let source: String
    let healthLabels: [String]
    let ingredientLines: [String]
    let url: String
}
