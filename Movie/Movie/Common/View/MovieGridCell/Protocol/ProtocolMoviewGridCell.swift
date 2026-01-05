import Foundation

protocol MovieGridCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: MovieGridCell)
}
