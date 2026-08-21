//
//  PokemonCoordinatorSpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

final class PokemonCoordinatorSpy: PokemonCoordinator {
    var startCallCount = 0
    var goToPokemonDetailCallCount = 0
    var goToAdvancedFiltersCallCount = 0
    var receviedPokemonId: Int?
    
    func start() -> UIViewController {
        startCallCount += 1
        return UIViewController()
    }
    
    func goToPokemonDetail(id: Int){
        goToPokemonDetailCallCount += 1
        receviedPokemonId = id
    }
    
    func goToAdvancedFilters() {
        goToAdvancedFiltersCallCount += 1
    }
}
