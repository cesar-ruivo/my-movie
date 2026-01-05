import UIKit

struct FavoriteLayoutFactory {
    private let onDelete: (IndexPath) -> Void
    
    init(onDelete: @escaping (IndexPath) -> Void) {
        self.onDelete = onDelete
    }
    
    func createLayout(sectionTypeProvider: @escaping (Int) -> FavoriteSection? ) -> UICollectionViewLayout {
        // Passamos o enviroment
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, enviroment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = sectionTypeProvider(sectionIndex) else { return nil }
            
            switch sectionType {
            case .favorite:
                return self.createFavoriteSeaction(enviroment: enviroment)
            }
        }
        return layout
    }
    
    private func createFavoriteSeaction(enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // 1. Configuração da Lista
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.backgroundColor = .clear
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [self] action, view, completion in
                self.onDelete(indexPath)
                completion(true)
            }
            
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: enviroment)
        
        // 3. Ajustes Visuais
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
}
