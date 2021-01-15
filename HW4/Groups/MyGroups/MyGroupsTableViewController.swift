//
//  MyGroupsTableViewController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//


import UIKit
import WebKit

var availableGroups = Groups.allGroups.sorted()
var myGroups = [String]()

class MyGroupsTableViewController: UITableViewController {
    
    private let vkService = VKServices()
    public var groups = [Group]()
    
    var searchedGroups = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var notInGroupsNameArray: [String] = []
    
    lazy var notInGroupsImagesArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        vkService.getGroups() { [weak self] groups, error in
            if let error = error {
                print(error)
                return
            } else if let groups = groups, let self = self {
                self.groups = groups
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: - Setup a Search Controller
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups"
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
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        
        let group: String
        
        if isFiltering() {
            group = searchedGroups[indexPath.row]
        } else {
            group = groups[indexPath.row].name
        }
        
        cell.GroupName.text = group
//        cell.GroupImage.image = UIImage(named: group)
        // Получаем список групп для конкретной строки
        
        let border = UIView()
        border.frame = cell.GroupImage.bounds
        border.layer.cornerRadius = cell.GroupImage.bounds.height / 2
        border.layer.masksToBounds = true
        cell.GroupImage.addSubview(border)

        let newGroupAvatar = UIImageView()
//        newGroupAvatar.image = UIImage(named: group)
        newGroupAvatar.kf.setImage(with: URL(string: groups[indexPath.row].photo))
        newGroupAvatar.frame = border.bounds
        border.addSubview(newGroupAvatar)
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
//        if segue.identifier == "addGroup" {
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
        searchedGroups = myGroups.filter({( group ) -> Bool in
            return group.lowercased().contains(searchText.lowercased())
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
