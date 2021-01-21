//
//  MyGroupsTableViewController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//


import UIKit
import WebKit
import Kingfisher
import RealmSwift

var availableGroups = Groups.allGroups.sorted()
var myGroups = [String]()
var filteredGroup = [Group]()

class MyGroupsTableViewController: UITableViewController {
    
    private let vkService = VKServices()
    var groups: Results<Group>?
    
    var searchedGroups = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var notInGroupsNameArray: [String] = []
    
    lazy var notInGroupsImagesArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        vkService.getGroups() { [weak self] groups in
            if let self = self {
                RealmProvider.save(items: groups)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                for group in groups {
                    myGroups.append(group.name)
                }
            }
        }
        
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: config)
            self.groups = realm.objects(Group.self)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Setup a Search Controller
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск групп"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchedGroups.count
        }
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        
        let group: String
        let newImage = UIImageView()
        
        if isFiltering() {
            group = searchedGroups[indexPath.row].name
            
            let url = searchedGroups[indexPath.row].photo
            if URL(string: url) != nil {
                let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
                newImage.kf.setImage(with: resource)
            } else {
                newImage.image = UIImage(named: "placeholder")
            }
            
            cell.GroupImage.kf.setImage(with: URL(string: searchedGroups[indexPath.row].photo))
        } else {
            group = groups?[indexPath.row].name ?? "Unknow"
            cell.GroupImage.kf.setImage(with: URL(string: groups?[indexPath.row].photo ?? ""))
        }
        
        cell.GroupName.text = group
        
        return cell
    }

    @IBAction func back() {
        Data.clearCookies()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            availableGroups.append(myGroups.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
            let availableGroupController = segue.source as! AvailableGroupTableViewController
            if let indexPath = availableGroupController.tableView.indexPathForSelectedRow {
                let group = availableGroups[indexPath.row]
                if !myGroups.contains(group) {
                    myGroups.append(group)
                    myGroups.sort()
                    availableGroups.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
//        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let groups = groups else { return }
        searchedGroups = groups.filter({ (group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension MyGroupsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
