//
//  StudentsCell.swift
//  CoreData Students
//
//  Created by Yusmi Putra on 7/27/23.
//

import UIKit

class StudentsCell: UITableViewCell {
    
    @IBOutlet weak var lastNameStudent: UILabel!
    @IBOutlet weak var firstNameStudent: UILabel!
    @IBOutlet weak var imageStudent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
