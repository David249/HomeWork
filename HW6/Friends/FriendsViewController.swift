//
//  FriendsTVC.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 05.11.2020.
//
import UIKit
import Kingfisher
import RealmSwift

let friends = Friends()

@IBDesignable class FriendsViewController: UITableViewController {
    
    private let vkService = VKServices()
    var users: Results<User>?
    var owner: User?
    
    var friendsNames = [String](Friends.allFriends.keys).sorted()
    var searchedNames = [String]()
    let presentTransition = PresentModalAnimator()
    let dismissTransition = DismissModalAnimator()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // Смещение тени
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3)

    // Прозрачность тени
    @IBInspectable var shadowOpacity: Float = 0.3

    // Радиус блура тени
    @IBInspectable var shadowRadius: CGFloat = 5
    
    // Цвет тени
    @IBInspectable var shadowColor: UIColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = RealmProvider.get(User.self)
        
        vkService.getFriends() { users in
                RealmProvider.save(items: users)
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
        
//        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//
//        do {
//            let realm = try Realm(configuration: config)
//            users = realm.objects(User.self)
//        } catch {
//            print(error)
//        }
//    }
    
    // MARK: - Setup a Search Controller
    func setupSearchController() {
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if isFiltering() {
//            return firstLetters(in: searchedNames).count
//        } else {
//            return firstLetters(in: friendsNames).count
//
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
//        if isFiltering() {
//            return filterNames(from: searchedNames, in: section).count
//        } else {
//            return filterNames(from: friendsNames, in: section).count
//        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if isFiltering() {
//            return firstLetters(in: searchedNames)[section]
//        } else {
//            return firstLetters(in: friendsNames)[section]
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
//
//        var filteredFriendsNames = [String]()
//        if isFiltering() {
//            filteredFriendsNames = filterNames(from: searchedNames, in: indexPath.section)
//        } else {filteredFriendsNames = filterNames(from: friendsNames, in: indexPath.section)
//        }
//        cell.friendNameLabel.text = filteredFriendsNames[indexPath.row]
        
//        let border = UIView()
//        border.frame = cell.friendImageView.bounds
//        border.layer.cornerRadius = cell.friendImageView.bounds.height / 2
//        border.layer.masksToBounds = true
//        cell.friendImageView.addSubview(border)
//
//        let newFriendAvatar = UIImageView()
//        newFriendAvatar.image = UIImage(named: "\(filteredFriendsNames[indexPath.row])")
//
//        newFriendAvatar.frame = border.bounds
//        border.addSubview(newFriendAvatar)
        
        if let users = users {
            cell.configure(with: users[indexPath.row])
        }
        
        return cell
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        if isFiltering() {
//            return firstLetters(in: searchedNames)
//        } else {
//            return firstLetters(in: friendsNames)
//        }
//    }
    
    @IBAction func back() {
        Data.clearCookies()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let imageView = UIImageView()
        guard segue.identifier == "friendSeque",
            let friendFotoController = segue.destination as? FriendCollectionViewController,
        let row = tableView.indexPathForSelectedRow?.row else { return }
        
        if let users = users {
            friendFotoController.friendName = "\(users[row].first_name) \(users[row].last_name)"
//            friendFotoController.friendID = users[row].id
            
//            ownerId = friendFotoController.users?[row].id ?? 0
//            fotoFriendsController.ownerId = ownerId
            
            friendFotoController.ownerId = users[row].id
//            imageView.kf.setImage(with: URL(string: users[row].avatar))
        }
        
//        if let image = imageView.image {
//            friendFotoController.friendImage = image
//        }
    }
    
    func filterNames (from names: [String], in section: Int) -> [String] {
        let key = firstLetters(in: names)[section]
        return names.filter {$0.first! == Character(key)}
    }
    
    func firstLetters (in names: [String]) -> [String] {
        let keys = [String](names)
        var firstLetters: [String] = []
        for key in keys {
            firstLetters.append(String(key.first!))
        }
        return Array(Set(firstLetters)).sorted()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchedNames = friendsNames.filter({( name ) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension OuterView {

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

}

extension FriendsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension FriendsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
