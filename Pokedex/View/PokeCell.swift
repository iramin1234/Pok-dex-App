//
//  PokeCell.swift
//  Pokedex
//
//  Created by Ramin Ikhilov  on 6/19/18.
//  Copyright © 2018 Ramin Ikhilov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbimg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configCell(pokemon: Pokemon){
        self.pokemon = pokemon
        let id = "\(self.pokemon.id)"
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbimg.image = UIImage(named: id)
    }
}
