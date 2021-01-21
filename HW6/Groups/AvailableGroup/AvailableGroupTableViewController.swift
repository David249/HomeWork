//
//  AvailableGroupTableViewController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

class AvailableGroupTableViewController: UITableViewController {
    
    private let vkService = VKServices()
    public var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Доступные группы"
        
        vkService.getGroups() { [weak self] groups in
            if let self = self {
                RealmProvider.save(items: groups)
                DispatchQueue.main.sync {
                    self.tableView?.reloadData()
                }
                self.groups = groups
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableGroupCell", for: indexPath)
            as! AvailableGroupTableViewCell
        
//        availableGroups.sort()
        
//        let group = availableGroups[indexPath.row]
//
//        cell.NotInGroupLabel.text = group
        
        cell.configure(with: groups[indexPath.row])
        
//        let border = UIView()
//        border.frame = cell.AvailableGroupImageView.bounds
//        border.layer.cornerRadius = cell.AvailableGroupImageView.bounds.height / 2
//        border.layer.masksToBounds = true
//        cell.AvailableGroupImageView.addSubview(border)
//
//        let newGroupAvatar = UIImageView()
//        newGroupAvatar.image = UIImage(named: group)
//        newGroupAvatar.frame = border.bounds
//        border.addSubview(newGroupAvatar)
        return cell
    }
    
}
