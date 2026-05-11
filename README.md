# Pokedex iOS

Aplicación iOS desarrollada en **Swift** que utiliza **PokeAPI** y muestra un catálogo de Pokemon con listado, detalle, filtros avanzados y colecciones. 

Se realiza como práctica de aprendizaje de desarrollo iOS. 

## Características principales

* Listado de Pokemons con imagen y nombre con swipe y botones para añadir el pokemon a una colección
* Búsqueda en tiempo real por nombre desde un buscador superior
* Búsqueda mediante filtros avanzados de nombre, ID, tipos y/o estado de colección.
* Galería reutilizable de imágenes y funcionalidad para hacer zoom con doble tap.
* Accesibilidad con VoiceOver y tamaño de letra

## Patrones y conceptos usados

* **MVVM** para separar vista y lógica de presentación
* **Coordinators** para navegación entre pantallas
* **Dependency Injection** para desacoplar dependencias y facilitar testing
* **Combine** para el flujo reactivo de datos
* **Decorator** para añadir caché y modificación del dominio

## Flujo principal de la app

### Listado
La pantalla principal muestra una lista de Pokemon obtenida desde un repositorio. Sobre esa lista se aplican:
* Búsqueda rápida local por nombre
* Filtros avanzados
* Estado de colección ('none', 'wanted', 'owned')

### Detalle de Pokemon
Al seleccionar un Pokemon, se navega a una pantalla de detalle que muestra:
* Galería de imágenes del Pokemon
* Nombre
* ID
* Descripción
* Tipo

### Zoom
Al hacer doble tap en una imagen de la galería, se abre una pantalla independiente de zoom.

Tanto la galería como la pantalla de zoom son componentes reutilizables y cargables desde XIB.

### VoiceOver

Se ha tenido en cuenta el uso de VoiceOver en la galería de imágenes. Cuando este está activo se desactiva el scroll horizontal de la galería y aparecen unos botones de navegación que permiten ir a la imagen anterior o siguiente.

## Testing

El proyecto incluye test centrados en la lógica más importante:

* Casos de uso
* Coordinators
* View Models
* Decorators
* Repositorios

Se utiliza **Swift Testing** y se asegura una cobertura del 57%
