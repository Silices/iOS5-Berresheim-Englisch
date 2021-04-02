//
//  CustomCell3.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 17.12.20.
//

import UIKit

class CustomCell3: UITableViewCell {

    var controller: DetailViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addHobby(_ sender: Any) {
//        print("add hobby")
        controller?.addHobby()
    }
}
