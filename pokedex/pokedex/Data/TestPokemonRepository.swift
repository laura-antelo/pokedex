//
//  TestPokemonRepository.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 20/4/26.
//

import UIKit
import Combine


class TestPokemonRepository: PokemonRepository {
        
    // MARK: - Listado Pokemons
    
    private func allPokemons() -> [Pokemon] {
        return [
            Pokemon(id: 4, name: "Charmander", images: loadImages(front: "front_4", back: "back_4"), types: ["Fire"], collectionState: .none),
            Pokemon(id: 7, name: "Squirtle", images: loadImages(front: "front_7", back: "back_7"), types: ["Water"], collectionState: .none),
            Pokemon(id: 25, name: "Pikachu", images: loadImages(front: "front_25", back: "back_25"), types: ["Electric"], collectionState: .none)
        ]
    }
    
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], Error> {
        let pokemons = allPokemons()
        return Just (pokemons)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Detalle pokemons
    
    private func detailPokemon(_ id: Int) -> PokemonDetail {
        let pokemon = getPokemonById(id)
        switch id {
        case 4:
            return PokemonDetail(id: pokemon?.id ?? 0, name: pokemon?.name ?? "", images: pokemon?.images ?? [], description: "La llama de su cola indica la fuerza vital de Charmander", types: ["Fire"], collectionState: .none)
        case 7:
            return PokemonDetail(id: pokemon?.id ?? 0, name: pokemon?.name ?? "", images: pokemon?.images ?? [], description: "El caparazón es blando al nacer. Pronto se vuelve an resistente que los dedos que lo pinchan rebotarán en él y volverá a salir", types: ["Water"], collectionState: .none)
        case 25:
            return PokemonDetail(id: pokemon?.id ?? 0, name: pokemon?.name ?? "", images: pokemon?.images ?? [], description: "Levanta la cola para vigilar los alrededores. A veces, puede ser alcanzado por un rayo en esa pose", types: ["Electric"], collectionState: .none)
        default:
            return PokemonDetail(id: pokemon?.id ?? 0, name: pokemon?.name ?? "", images: pokemon?.images ?? [], description: "Descripción de prueba de prueba de prueba de prueba de prueba de prueba", types: ["tipo de prueba", "tipo de prueba"], collectionState: .none)
        }
    }
    
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, Error> {
        let detail = detailPokemon(id)
        
        return Just(detail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
        
    
    // MARK: - Helpers
    
    private func getPokemonById(_ id: Int) -> Pokemon? {
        return allPokemons().first(where: { $0.id == id })
    }
    
    private func loadImages(front: String, back: String) -> [UIImage] {
        return [front, back].compactMap { UIImage(named: $0) }
    }
}
