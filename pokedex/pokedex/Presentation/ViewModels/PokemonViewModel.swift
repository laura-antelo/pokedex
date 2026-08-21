//
//  PokemonViewModel.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 22/4/26.
//

import UIKit
import Combine

protocol PokemonViewModel {
    var pokemonsPublisher: AnyPublisher<[Pokemon], Never> { get }
    var hasActiveAdvancedFiltersPublisher: AnyPublisher<Bool, Never> { get }
    
    func viewDidLoad()
    func didSelectedPokemon(id: Int)
    func didChangeCollectionState(id: Int, to state: PokemonCollectionState)
    func updateSearchText(_ text: String)
    func applyAdvancedFilters(_ filter: PokemonAdvancedFilter)
    func currentAdvancedFilters() -> PokemonAdvancedFilter
}

class DefaultPokemonViewModel: PokemonViewModel {
    
    private let dependencies: PokemonDependencies
    private var cancellables = Set<AnyCancellable>()
    
    private let allPokemonSubject = CurrentValueSubject<[Pokemon], Never>([])
    private let searchTextSubject = CurrentValueSubject<String, Never>("")
    private let advancedFilterSubject = CurrentValueSubject<PokemonAdvancedFilter, Never>(.empty)
    
    var pokemonsPublisher: AnyPublisher<[Pokemon], Never> {
        Publishers.CombineLatest3(
            allPokemonSubject,
            searchTextSubject.removeDuplicates(),
            advancedFilterSubject.removeDuplicates()
        ).map { pokemons, searchText, advandedFilter in
            Self.filterPokemons(pokemons, searchText: searchText, advancedFilter: advandedFilter)
        }
        .eraseToAnyPublisher()
    }
    
    var hasActiveAdvancedFiltersPublisher: AnyPublisher<Bool, Never> {
        advancedFilterSubject
            .map(\.hasAdvancedFilters)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    init(dependencies: PokemonDependencies) {
        self.dependencies = dependencies
    }
    
    func viewDidLoad() {
        let useCase: GetAllPokemonUseCase = dependencies.resolve()
        
        useCase.execute()
            .replaceError(with: [])
            .sink{ [weak self] pokemons in
                self?.allPokemonSubject.send(pokemons)
            }
            .store(in: &cancellables)
    }
    
    func didSelectedPokemon(id: Int) {
        let coordinator: PokemonCoordinator = dependencies.resolve()
        coordinator.goToPokemonDetail(id: id)
    }
    
    func didChangeCollectionState(id: Int, to state: PokemonCollectionState) {
        let useCase: SetPokemonCollectionStateUseCase = dependencies.resolve()
        useCase.execute(state, for: id)
    }
    
    func updateSearchText(_ text: String) {
        searchTextSubject.send(text)
    }
    
    func applyAdvancedFilters(_ filter: PokemonAdvancedFilter) {
        advancedFilterSubject.send(filter)
    }
    
    func currentAdvancedFilters() -> PokemonAdvancedFilter {
        return advancedFilterSubject.value
    }
}

private extension DefaultPokemonViewModel {
    private static func filterPokemons(_ pokemons: [Pokemon], searchText: String, advancedFilter: PokemonAdvancedFilter) -> [Pokemon] {
        return pokemons.filter { pokemon in
            matchesQuickSearch(pokemon, searchText: searchText) &&
            matchesAdvancedName(pokemon, filter: advancedFilter) &&
            matchesAdvancedId(pokemon, filter: advancedFilter) &&
            matchesAdvancedTypes(pokemon, filter: advancedFilter) &&
            matchesCollectionStates(pokemon, filter: advancedFilter)
        }
    }
    
    static func matchesQuickSearch(_ pokemon: Pokemon, searchText: String) -> Bool {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return true }
        
        let lowercasedText = trimmedText.lowercased()
        
        return pokemon.name.lowercased().contains(lowercasedText)
    }
    
    static func matchesAdvancedName(_ pokemon: Pokemon, filter: PokemonAdvancedFilter) -> Bool {
        let trimmedText = filter.nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return true }
        
        let lowercasedText = trimmedText.lowercased()
        
        return pokemon.name.lowercased().contains(lowercasedText)
    }
    
    static func matchesAdvancedId(_ pokemon: Pokemon, filter: PokemonAdvancedFilter) -> Bool {
        let trimmedText = filter.numberText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return true }
        
        return String(pokemon.id).contains(trimmedText)
    }
    
    static func matchesAdvancedTypes(_ pokemon: Pokemon, filter: PokemonAdvancedFilter) -> Bool {
        guard !filter.selectedTypes.isEmpty else { return true }
        
        let pokemonTypes = Set(pokemon.types.map { $0.lowercased()})
        let selectedTypes = Set(filter.selectedTypes.map { $0.lowercased() })
        
        return !pokemonTypes.intersection(selectedTypes).isEmpty
    }
    
    private static func matchesCollectionStates(_ pokemon: Pokemon, filter: PokemonAdvancedFilter) -> Bool {
        guard !filter.selectedCollectionStates.isEmpty else { return true }

        return filter.selectedCollectionStates.contains(pokemon.collectionState)
    }
}
