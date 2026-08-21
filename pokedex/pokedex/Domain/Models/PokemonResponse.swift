//
//  PokemonResponse.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit

struct PokemonListResponse: Decodable {
    let results: [PokemonListItemResponse]
}

struct PokemonListItemResponse: Decodable {
    let name: String
    let url: String
}

struct PokemonResponse: Decodable {
    let id: Int
    let species: SpeciesResponse
    let sprites: SpritesResponse
    let types: [TypesResponse]
}

struct SpeciesResponse: Decodable {
    let name: String
}

struct SpritesResponse: Decodable {
    let frontDefault: String?
    let backDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}

struct TypesResponse: Decodable {
    let slot: Int
    let type: TypeNameResponse
}

struct TypeNameResponse: Decodable {
    let name: String
}

struct PokemonSpeciesResponse: Decodable {
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Decodable {
    let flavorText: String
    let language: LanguageResponse
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct LanguageResponse: Decodable {
    let name: String
}
