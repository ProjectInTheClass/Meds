//
//  CustomTableViewCell.swift
//  MedsApp
//
//  Created by 최민건 on 2021/05/29.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var IngredientImage: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
