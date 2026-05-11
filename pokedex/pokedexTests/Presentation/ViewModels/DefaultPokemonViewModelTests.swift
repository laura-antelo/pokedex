//
//  DefaultPokemonViewModelTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import Combine

struct DefaultPokemonViewModelTests {
    
    @MainActor
    @Test func When_ViewDidLoadIsCalled_Then_ShouldPublishAllPokemons() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        let value = await sut.pokemonsPublisher.values.first(where: { _ in true })
        
        #expect(value?.count == 2)
    }
    
    @MainActor
    @Test func When_SearchTextMatchesOnePokemon_Then_ShouldPublishOneFilteredPokemon() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.updateSearchText("char")
        let value = await sut.pokemonsPublisher.values.first(where: { $0.count == 1 })
            
        #expect(value?.first?.name == "Charmander")
    }
    
    @MainActor
    @Test func When_SearchTextIsEmpty_Then_ShouldPublishAllPokemons() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.updateSearchText("")
        let value = await sut.pokemonsPublisher.values.first(where: { _ in true })
            
        #expect(value?.count == 2)
    }
    
    @MainActor
    @Test func When_AdvancedFilterByNameIsApplied_Then_ShouldPublishOnePokemon() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.applyAdvancedFilters(PokemonAdvancedFilter(nameText: "Pika"))
        let value = await sut.pokemonsPublisher.values.first(where: { $0.count == 1 })
        
        #expect(value?.first?.name == "Pikachu")
    }
    
    @MainActor
    @Test func When_AdvancedFilterByIdIsApplied_Then_ShouldPublishOnePokemon() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.applyAdvancedFilters(PokemonAdvancedFilter(numberText: "25"))
        let value = await sut.pokemonsPublisher.values.first(where: { $0.count == 1 })
        
        #expect(value?.first?.id == 25)
    }
    
    @MainActor
    @Test func When_AdvancedFilterByTypeIsApplied_Then_ShouldPublishOnePokemon() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.applyAdvancedFilters(PokemonAdvancedFilter(selectedTypes: ["Fire"]))
        let value = await sut.pokemonsPublisher.values.first(where: { $0.count == 1 })
        
        #expect(value?.first?.id == 4)
    }
    
    @MainActor
    @Test func When_AdvancedFilterByCollectionStateIsApplied_Then_ShouldPublishOnePokemon() async throws {
        let useCase = GetAllPokemonUseCaseSpy(pokemons: TestPokemons.samplePokemons)
        let dependencies = PokemonDependenciesMock()
        dependencies.getAllPokemonsUseCase = useCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.viewDidLoad()
        sut.applyAdvancedFilters(PokemonAdvancedFilter(selectedCollectionStates: [.wanted]))
        let value = await sut.pokemonsPublisher.values.first(where: { $0.count == 1 })
        
        #expect(value?.first?.id == 4)
    }
    
    @MainActor
    @Test func When_AdvancedFiltersAreEmpty_Then_HasActiveAdvancedFiltersPublisherShouldReturnFalse() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        let value = await sut.hasActiveAdvancedFiltersPublisher.values.first(where: { _ in true })
        
        #expect(value == false)
    }
    
    @MainActor
    @Test func When_CurrentAdvancedFiltersIsRequested_Then_ShouldReturnLastAppliedFilters() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        let filter = PokemonAdvancedFilter(nameText: "Pika", selectedTypes: ["Electric"])
        
        sut.applyAdvancedFilters(filter)
        
        #expect(sut.currentAdvancedFilters() == filter)
    }
    
    @MainActor
    @Test func When_DidChangeCollectionStateIsCalled_Then_ShouldExecuteSetPokemonCollectionStateUseCase() async throws {
        let setUseCase = SetPokemonCollectionStateUseCaseSpy()
        let dependencies = PokemonDependenciesMock()
        dependencies.setpokemonCollectionStateUseCase = setUseCase
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.didChangeCollectionState(id: 25, to: .wanted)
        
        #expect(setUseCase.executeCallCount == 1)
    }
    
    @MainActor
    @Test func When_DidSelectedPokemonIsCalled_Then_ShouldAskCoordinatorToNavegateToDetail() async throws {
        let coordinator = PokemonCoordinatorSpy()
        let dependencies = PokemonDependenciesMock()
        dependencies.pokemonCoordinator = coordinator
        let sut = DefaultPokemonViewModel(dependencies: dependencies)
        
        sut.didSelectedPokemon(id: 25)
        
        #expect(coordinator.goToPokemonDetailCallCount == 1)
    }
}
