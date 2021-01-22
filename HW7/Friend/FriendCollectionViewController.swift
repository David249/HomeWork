//
//  FriendCollectionViewController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//
import UIKit
import RealmSwift

class FriendCollectionViewController: UICollectionViewController {
    
    private let vkService = VKServices()
//    public var photos = [Photo]()
    
    public var ownerId: Int = 0
    private var photos: Results<Photo>?
    private var notificationToken: NotificationToken?
    
    var friendID = Session.shared.userId
    
     lazy var friendImage: UIImage = UIImage()
     lazy var friendName: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = friendName
        
        getPhoto()
        bindObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func getPhoto() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: config)
            photos = realm.objects(Photo.self).filter("ANY owner.id == %@", ownerId)
            
            vkService.getPhotos(for: ownerId) { photos in
                guard let user = realm.object(ofType: User.self, forPrimaryKey: self.ownerId) else { return }
                
                try? realm.write {
                    realm.add(photos, update: .all)
                    user.photos.append(objectsIn: photos)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func bindObserver() {
        guard let photo = photos else { return }
        
        notificationToken = photo.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.collectionView.reloadData()
            case .update(_, let dels, let ins, let mods):
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: ins.map({ IndexPath(row: $0, section: 0) }))
                    self.collectionView.deleteItems(at: dels.map({ IndexPath(row: $0, section: 0)}))
                    self.collectionView.reloadItems(at: mods.map({ IndexPath(row: $0, section: 0) }))
                    self.collectionView.reloadData()
                }, completion: nil)
            case .error(let error):
                print(error)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! FriendCollectionViewCell
    
        if let photos = photos {
            cell.configure(with: photos[indexPath.row])
        }
        return cell
    }

}
