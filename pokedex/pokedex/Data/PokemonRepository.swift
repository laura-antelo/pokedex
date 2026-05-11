//
//  PokemonRepository.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 20/4/26.
//

import UIKit
import Combine

protocol PokemonRepository {
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], Error>
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, Error>
}
