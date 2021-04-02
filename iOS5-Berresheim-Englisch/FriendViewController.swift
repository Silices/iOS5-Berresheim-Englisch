//
//  FriendViewController.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 18.12.20.
//

import UIKit

class FriendViewController: UITableViewController{
    var parentController: DetailViewController?
    var currentContact: AddressCard?
    var contacts: [AddressCard] = []
    var potentialFriends: [AddressCard] = []
    var friends: [AddressCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let del = UIApplication.shared.delegate as? AppDelegate {
            contacts = del.addressBook?.addressCards ?? [AddressCard]()
            potentialFriends = contacts
        }
        
        friends = currentContact?.friends ?? [AddressCard]()
        
        deleteYourself()
        
        tableView.allowsMultipleSelection = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentContact?.friends = friends
        parentController?.tableView.reloadData()
    }
    
    func deleteYourself(){
        guard let index = potentialFriends.firstIndex(of: currentContact ?? AddressCard()) else { return }
        potentialFriends.remove(at: index)
//        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return potentialFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath)
        
        cell.textLabel?.text = potentialFriends[indexPath.row].firstname + " " + potentialFriends[indexPath.row].lastname
        
        cell.detailTextLabel?.text = String (potentialFriends[indexPath.row].zipcode) + " " + potentialFriends[indexPath.row].city + ", " + potentialFriends[indexPath.row].streetAndNumber
        
        markFriend(dude: potentialFriends[indexPath.row], cell: cell)
        
        return cell
    }
    
    func markFriend(dude: AddressCard, cell: UITableViewCell){
        let array: [AddressCard] = currentContact?.friends ?? [AddressCard]()
        for addressCard in array {
            if addressCard == dude {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row, and instead, show the state with a checkmark.
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            let card = potentialFriends[indexPath.row]
            guard let index = friends.firstIndex(of: card) else { return }
            friends.remove(at: index)
        }
        else if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            let card = potentialFriends[indexPath.row]
            friends.append(card)
        }
    }
}
