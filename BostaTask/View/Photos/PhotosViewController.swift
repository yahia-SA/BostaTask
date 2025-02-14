
import UIKit
import Kingfisher
import RxSwift
class PhotosViewController: UIViewController {
    
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    let searchController = UISearchController()
    var albumeId: Int?
    var albumName: String?
    var photosArr: [Photos]?
    var photoFilter: [Photos] = []
    var photoViewModel: PhotosViewModel?
    //var photos: Photos?
    var isSearchBarEmpty: Bool{
            return searchController.searchBar.text!.isEmpty
        }
    var isFiltering : Bool{
            return searchController.isActive && !isSearchBarEmpty
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        title = albumName
        photoViewModel = PhotosViewModel()
        photoViewModel?.ObservablePhotos.subscribe(onNext: { [weak self] photos in
            self?.photosArr = photos
            self?.photosCollectionView.reloadData()
        }).disposed(by: photoViewModel!.disposeBag)

        photoViewModel?.getPhotos(albumId: albumeId!)
        
        

    }
    

    // MARK: - Navigation

 }

extension PhotosViewController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering{
            return photoFilter.count
        }else {
            return photosArr?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCollectionViewCell", for: indexPath) as! photosCollectionViewCell
        if isFiltering{
            cell.photoImageView.kf.setImage(with: URL(string: photoFilter[indexPath.row].url ?? "no"),placeholder: UIImage(named: "no"))
        }else{
            cell.photoImageView.kf.setImage(with: URL(string: photosArr![indexPath.row].url ?? "no"),placeholder: UIImage(named: "no"))
        }
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            
        return CGSize(width:self.view.frame.width * 0.333 - 10.5, height: self.view.frame.height*0.10)

        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Adjust the vertical spacing between cells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Adjust the horizontal spacing between cells
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhotoUrl: String
        let selectedPhotoTitle: String

        if isFiltering {
            selectedPhotoUrl = photoFilter[indexPath.row].url ?? ""
            selectedPhotoTitle = photoFilter[indexPath.row].title ?? "No Title"
        } else {
            selectedPhotoUrl = photosArr?[indexPath.row].url ?? ""
            selectedPhotoTitle = photosArr?[indexPath.row].title ?? "No Title"
        }
        
        let detailVC = PhotoDetailViewController()
        detailVC.imageUrl = selectedPhotoUrl
        detailVC.imageTitle = selectedPhotoTitle
        navigationController?.pushViewController(detailVC, animated: true)
    }

    
}

//------------------for-------------search-----------------
extension PhotosViewController: UISearchResultsUpdating, UISearchBarDelegate{

    func makeSearchBar(){

            searchController.searchResultsUpdater = self
            searchController.searchBar.tintColor = .black
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search for Pictures"
            let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField

            textFieldInsideSearchBar?.textColor = .black
            navigationItem.searchController = searchController
            definesPresentationContext = false
                
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        photoFilter = (photosArr)!.filter({ filter in
                return filter.title!.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        photosCollectionView.reloadData()
    }

}
