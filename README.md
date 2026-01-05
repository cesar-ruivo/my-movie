# 🎬 MovieApp - iOS Projeto de estudo
Este projeto é uma aplicação iOS nativa desenvolvida com foco no estudo aprofundado de **UIKit**, **ViewCode** e **Arquitetura Limpa**.
O objetivo principal foi criar uma aplicação robusta, escalável e testável, simulando desafios reais do mercado, como gerenciamento de concorrência, interfaces complexas e consumo de API.

## 🛠 Tecnologias e Ferramentas
* **Linguagem:** Swift 5
* **Interface:** UIKit (100% ViewCode - Sem Storyboards/Xibs)
* **Arquitetura:** VIPER
* **Networking:** URLSession 
* **Layout:** UICollectionViewCompositionalLayout & Auto Layout
* **Persistência:** UserDefaults (Codable)
* **Concorrência:** GCD (DispatchGroup, DispatchQueue)

## ✨ Features Implementadas

### 🏠 Home (Feed Principal)
* **Banners Rotativos:** Implementação de um carrossel automático ("Now Playing") com `Timer` e paginação visual.
* **Múltiplas Seções:** Uso de `UICollectionViewCompositionalLayout` para criar seções com comportamentos de scroll distintos (Horizontal Contínuo e Paging) na mesma tela.
* **Carregamento Simultâneo:** Uso de `DispatchGroup` no Interactor para garantir que todas as listas (Now Playing, Popular, Top Rated) sejam carregadas antes de atualizar a UI.

### 🔍 Busca (Search)
* **Estados de Tela:** Gerenciamento de estado entre "Showcase" (sugestões iniciais) e "Searching" (resultado da busca).
* **Requisições Dinâmicas:** Busca na API em tempo real conforme o usuário digita.

### ⭐ Favoritos
* **Persistência Local:** Sistema de favoritos salvos localmente usando `UserDefaults` com encoding JSON.
* **Gestos Modernos:** Implementação de **Swipe-to-Delete** utilizando `UICollectionLayoutListConfiguration`.
* **Atualização Reativa:** A mudança no status de favorito reflete instantaneamente em todas as telas (Home e Busca).

### 🎨 Theme System (Design System Dinâmico)
* **Remote Theming:** O app é capaz de buscar um arquivo JSON remoto para configurar cores e fontes.
* **Fallback Local:** Caso a requisição falhe, o app carrega um tema padrão local, garantindo a consistência da UI.
* **ThemeManager:** Singleton responsável por distribuir estilos de texto e paletas de cores para todos os componentes.

## 🏗 Arquitetura e Decisões Técnicas

O projeto segue estritamente o padrão **VIPER** para garantir o fluxo de dados e a separação de responsabilidades:

* **View:** Passiva, responsável apenas por exibir dados e capturar toques. Toda a construção é feita via `NSLayoutConstraints`.
* **Interactor:** Contém toda a lógica de negócios (chamadas de rede, lógica de favoritos, validações).
* **Presenter:** Formata os dados brutos recebidos do Interactor para ViewModels simples prontos para exibição na View.
* **Router:** Gerencia a navegação entre telas (`UINavigationController`).
* **Builder:** Responsável pela injeção de dependência e criação dos módulos.

### Destaque: Layout Factory
Para evitar que a ViewController ficasse massiva com a quantidade de codigo, a lógica de criação dos layouts complexos foi extraída para estruturas dedicadas (`HomeLayoutFactory`, `SearchSectionLayoutFactory`, `FavoriteLayoutFactory`).

### Destaque: Image Caching Customizado
Implementação de uma extensão de `UIImageView` com `NSCache` para evitar o download repetitivo de imagens durante a rolagem da lista.

# 🧠 Aprendizados

Durante o desenvolvimento, os principais desafios e aprendizados foram:

1.  **Domínio do Compositional Layout:** Criar layouts ortogonais (scroll horizontal dentro de vertical) e headers dinâmicos sem a complexidade de nested collection views.
2.  **Ciclo VIPER:** 
3.  **Gerenciamento de Threads:** Garantir que as atualizações de UI ocorram na `Main Thread` enquanto o processamento de dados e rede ocorre em background.
4.  **ViewCode Organizado:** Criação do protocolo `CodeView` para padronizar a criação de hierarquia e constraints.
5.  **Implementação de tema loca para estilos**
6.  **Realizar requisição de API**
7.  **Consumo de endPoint**

## 🚀 Melhorias Futuras

* [ ] Melhorar os teste unitários, cheguei a experimentar, mas falta entender melhor o conceito e ter mais prática.

---
Desenvolvido por **Cesar Ruivo** 
