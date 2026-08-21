//
//  PokemonDependenciesMock.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

final class PokemonDependenciesMock: PokemonDependencies {
    var pokemonRepository: PokemonRepository?
    var getAllPokemonsUseCase: GetAllPokemonUseCase?
    var pokemonViewModel: PokemonViewModel?
    var pokemonViewController: PokemonViewController?
    var pokemonCoordinator: PokemonCoordinator?
    
    var getPokemonDetailUseCase: GetPokemonDetailUseCase?
    var pokemonDetailCoordinator: PokemonDetailCoordinator?
    
    var pokemonCollectionStateRepository: PokemonCollectionStateRepository?
    var setpokemonCollectionStateUseCase: SetPokemonCollectionStateUseCase?
    
    func resolve() -> any PokemonRepository {
        pokemonRepository ?? TestPokemonRepository()
    }
    
    func resolve() -> any GetAllPokemonUseCase {
        getAllPokemonsUseCase ?? DefaultGetAllPokemonUseCase(repository: resolve())
    }
    
    func resolve() -> any PokemonViewModel {
        pokemonViewModel ?? DefaultPokemonViewModel(dependencies: self)
    }
    
    func resolve() -> PokemonViewController {
        pokemonViewController ?? PokemonViewController(dependencies: self)
    }
    
    func resolve() -> any PokemonCoordinator {
        pokemonCoordinator ?? DefaultPokemonCoordinator(dependencies: self)
    }
    
    func resolve() -> any GetPokemonDetailUseCase {
        getPokemonDetailUseCase ?? DefaultGetPokemonDetailUseCase(repository: resolve())
    }
    
    func resolve() -> any PokemonDetailCoordinator {
        pokemonDetailCoordinator ?? DefaultPokemonDetailCoordinator(dependencies: self)
    }
    
    func resolve() -> any PokemonCollectionStateRepository {
        pokemonCollectionStateRepository ?? DefaultPokemonCollectionStateRepository()
    }
    
    func resolve() -> any SetPokemonCollectionStateUseCase {
        setpokemonCollectionStateUseCase ?? DefaultSetPokemonCollectionStateUseCase(repository: resolve())
    }
    
}
