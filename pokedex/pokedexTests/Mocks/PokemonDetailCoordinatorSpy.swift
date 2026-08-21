//
//  PokemonDetailCoordinatorSpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

final class PokemonDetailCoordinatorSpy: PokemonDetailCoordinator {
    var startCallCount = 0
    var receviedPokemonId: Int?
    let returnedViewController = UIViewController()
    
    func start(pokemonId: Int) -> UIViewController {
        startCallCount += 1
        receviedPokemonId = pokemonId
        return returnedViewController
    }
}
