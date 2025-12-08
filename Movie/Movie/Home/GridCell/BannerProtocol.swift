import Foundation

protocol BannerMovieGridCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: BannerMovieGridCell)
    func didTapSeeMoreButton(in cell: BannerMovieGridCell)
}
protocol BannerPageControlFooterViewDelegate: AnyObject {
    func bannerFooter(_ footer: BannerPageControlFooterView, didRequestScrollTo index: Int)
}
