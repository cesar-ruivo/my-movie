import UIKit

struct HomeLayoutFactory {
    
    // Adicionamos um parâmetro: uma função que recebe a página atual (Int)
    func createLayout(onBannerPageChange: @escaping (Int) -> Void, sectionTypeProvider: @escaping (Int) -> HomeSections?) -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, Enviroment) -> NSCollectionLayoutSection? in
            guard let sectionType = sectionTypeProvider(sectionIndex) else { return nil }
            
            switch sectionType {
            case .nowPlaying:
                return self.createBannerSection(onPageChange: onBannerPageChange)
            case .popular:
                return self.createListSection()
            case .topRate:
                return self.createListSection()
            }
        }
        return layout
    }
    
    // Atualizamos a assinatura para receber a função
    private func createBannerSection(onPageChange: @escaping (Int) -> Void) -> NSCollectionLayoutSection {
        
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: "Footer", alignment: .bottomLeading)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [footer]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
            let bannerWidth = environment.container.contentSize.width
            let page = Int(round(point.x / bannerWidth))
            onPageChange(page)
        }
        
        return section
    }

    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .estimated(290))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .estimated(290))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "Header", alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
}
