//
//  DetailViewController.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 09.12.20.
//

import UIKit

class DetailViewController : UITableViewController {
    var parentController: RootViewController?
    var isNew = true
    var contactName: String = ""
    var contacts: AddressBook = AddressBook()
    var currentContact: AddressCard? = AddressCard.init()
    
    let sectionTitles = ["Address", "Hobbies", "Friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
//                self.navigationItem.leftBarButtonItem = newBackButton
        
        if let del = UIApplication.shared.delegate as? AppDelegate {
            contacts = del.addressBook ?? AddressBook()
        }
        
        if contactName.count != 0 {
            getLastName()
            getContact()
        }
        
        let array: [AddressCard] = currentContact?.friends ?? [AddressCard]()
        for card in array {
            if !contacts.addressCards.contains(card) {
                guard let index = currentContact?.friends.firstIndex(of: card) else { return }
                currentContact?.friends.remove(at: index)
            }
        }
    }
    
    func getLastName(){
        let words = contactName.split(separator: " ")
        contactName = String(words[1])
    }
    
    func getContact(){
        currentContact = contacts.searchAddressCard(lastname: contactName)?.first
//        contacts.remove(card: currentContact!)
//        print(currentContact)
    }
    
    @objc func back(sender: UIBarButtonItem) {
            // Perform your custom actions
//        contacts.add(card: currentContact!)
//        contacts.changeCard(old_lastname: contactName, card: currentContact!)
            // Go back to the previous ViewController
        parentController?.tableView.reloadData()
        _ = navigationController?.popViewController(animated: true)
        }
    
    func addHobby(){
        currentContact?.add(hobby: "")
        tableView.reloadData()
    }
    
    func updateCard(indexPath: IndexPath?, detail: String?){
        if !isNew {
            contacts.remove(card: currentContact!)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath!) as! CustomCell1
        
        switch (indexPath?.section, indexPath?.row) {
        case (0, 0):
            currentContact?.firstname = detail ?? ""
        case (0, 1):
            isNew = false
            currentContact?.lastname = detail ?? ""
        case (0, 2):
            let old_number = String(currentContact?.streetAndNumber.split(separator: " ").last ?? "")
            
            currentContact?.streetAndNumber = detail ?? "" + " " + old_number
        case (0, 3):
            let old_street = String(currentContact?.streetAndNumber.split(separator: " ").first ?? "")
            
            currentContact?.streetAndNumber = old_street + " " + (detail ?? "")
        case (0, 4):
            currentContact?.zipcode = Int (detail ?? "-1") ?? -1
        case (0, 5):
            currentContact?.city = detail ?? ""
        case (1, _):
            currentContact?.hobbies[indexPath?.row ?? -1] = detail ?? ""
        case (2, _):
            print("dei mudda")
        default:
            cell.textLabel?.text = "fucke you"
        }
        
        if !isNew {
            contacts.add(card: (currentContact!))
            contacts.sortAddressCards()
        }
    }
    

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        else if section == 1 {
            return currentContact?.hobbies.count ?? 0
        }
        else if section == 2 {
            return currentContact?.friends.count ?? 0
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell1
        cell.indexPath = indexPath
        cell.controller = self
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! CustomCell3
        cell3.controller = self
        
        let cell4 = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! CustomCell4
        cell4.controller = self
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.title.text = "First Name"
            cell.detail.text = currentContact?.firstname
        case (0, 1):
            cell.title.text = "Last Name"
            cell.detail.text = currentContact?.lastname
        case (0, 2):
            cell.title.text = "Street"
            cell.detail.text = String(currentContact?.streetAndNumber.split(separator: " ").first ?? "")
        case (0, 3):
            cell.title.text = "Number"
            cell.detail.text = String(currentContact?.streetAndNumber.split(separator: " ").last ?? "")
        case (0, 4):
            cell.title.text = "Zipcode"
            let temp = String(currentContact?.zipcode ?? 0)
            cell.detail.text = temp != "0" ? temp : ""
        case (0, 5):
            cell.title.text = "City"
            cell.detail.text = currentContact?.city
        case (0, 6):
//            cell3.controller = self
            return cell3
        case (0, 7):
            return cell4
        case (1, _):
            cell.title.text = "Hobby"
            cell.detail.text = currentContact?.hobbies[indexPath[1]]
        case (2, _):
            let firstname = currentContact?.friends[indexPath.row].firstname ?? "nobody"
            let lastname = currentContact?.friends[indexPath.row].lastname ?? "kill ur self"
            let labelText = firstname + " " + lastname
            cell2.textLabel?.text = labelText
            
            let zip = String (currentContact?.friends[indexPath[1]].zipcode ?? 030)
            let city = currentContact?.friends[indexPath[1]].city ?? "no boy cares"
            let street = currentContact?.friends[indexPath[1]].streetAndNumber ?? "about you"
                cell2.detailTextLabel?.text = zip + " " + city + ", " + street
        
            return cell2
        default:
            cell.textLabel?.text = "fucke you"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 1 {
                currentContact?.hobbies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if indexPath.section == 2 {
                currentContact?.friends.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue2" {
            if let cont = segue.destination as? FriendViewController {
                if (sender as? UIButton) != nil {
                    cont.parentController = self
                    cont.currentContact = currentContact
                }
            }
        }
    }
}
