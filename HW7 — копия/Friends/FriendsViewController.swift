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
    var notificationToken: NotificationToken?
    
    var arrayAllLastName = [String]()
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
        
        notificationToken = users?.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            
            case .update(_, _, _, _):
                self.sortUsersList()
                self.tableView.reloadData()
                
            case .error(let error):
                print(error)
            }
        }
        
        vkService.getFriends() { users in
            RealmProvider.save(items: users)
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sortUsersList()
    }
    
    private func sortUsersList() {
        users = users!.sorted(byKeyPath: "first_name", ascending: true)
    }
    
    // MARK: - Setup a Search Controller
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
        
        if let users = users {
            cell.configure(with: users[indexPath.row])
        }
        
        return cell
    }
    
    @IBAction func back() {
        Data.clearCookies()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "friendSeque",
            let friendFotoController = segue.destination as? FriendCollectionViewController,
            let row = tableView.indexPathForSelectedRow?.row else { return }
        
        if let users = users {
            friendFotoController.friendName = "\(users[row].first_name) \(users[row].last_name)"
            friendFotoController.ownerId = users[row].id
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
        
//        func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//            searchedNames = friendsNames.filter({( name ) -> Bool in
//                return name.lowercased().contains(searchText.lowercased())
//            })
//            tableView.reloadData()
//        }
        
        func isFiltering() -> Bool {
            return searchController.isActive && !searchBarIsEmpty()
        }
        
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

extension FriendsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
