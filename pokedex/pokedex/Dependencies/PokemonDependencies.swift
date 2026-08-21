//
//  PokemonListDependencies.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit

protocol PokemonDependencies {
    func resolve() -> PokemonRepository
    func resolve() -> GetAllPokemonUseCase
    func resolve() -> PokemonViewModel
    func resolve() -> PokemonViewController
    func resolve() -> PokemonCoordinator
    
    func resolve() -> GetPokemonDetailUseCase
    func resolve() -> PokemonDetailCoordinator
    
    func resolve() -> PokemonCollectionStateRepository
    func resolve() -> SetPokemonCollectionStateUseCase
}
