import Foundation
import Moya
import RxSwift
protocol getPhotos {
    func getPhotos(albumId : Int)
}

class PhotosViewModel : getPhotos{
  
  let disposeBag = DisposeBag()
  
    var bindingPhotos:(()->())?
    
    
    var ObservablePhotos: PublishSubject<[Photos]> = .init()

    
    func getPhotos(albumId : Int) {
        
        let dataProvider = MoyaProvider<UserService>()
        dataProvider.request(.readpicture(albumId: albumId)) { result in
            switch result {
                
            case .success(let response):
                
                do{
                    let photos = try JSONDecoder().decode([Photos].self, from: response.data)
                    dump(photos)
                    self.ObservablePhotos.onNext(photos)
                   // self.photosCollectionView.reloadData()
                   
                }catch let error{
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
       
        }
    }
