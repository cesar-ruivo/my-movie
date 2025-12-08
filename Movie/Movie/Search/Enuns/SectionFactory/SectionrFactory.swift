import UIKit

struct SearchSectionLayoutFactory {
    func createLayout(onBannerPageChange: @escaping (Int) -> Void, sectionTypeProvider: @escaping (Int) -> SearchSection?) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, Enviroment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = sectionTypeProvider(sectionIndex) else { return nil }
            
            switch sectionType {
            case .nowPlaying:
                return self.createListSection()
            case .popular:
                return self.createListSection()
            case .topRate:
                return self.createListSection()
            }
        }
        return layout
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .estimated(290)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .estimated(290)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        return section
    }
}
