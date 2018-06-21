//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Ramin Ikhilov  on 6/19/18.
//  Copyright © 2018 Ramin Ikhilov. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {

    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
   
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var preEvoImage: UIImageView!
    @IBOutlet weak var evoImage: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // take info from Pokemon object that was passed through segue to update images and text on view
        nameLbl.text = pokemon.name.capitalized
        let curImg = UIImage(named: "\(pokemon.id)")
        mainImg.image = curImg
        preEvoImage.image = curImg
        idLbl.text = "\(pokemon.id)"
        
        pokemon.downloadPokeDetails {
            self.updateUI()
        }
        
    }
    func updateUI(){
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        typeLbl.text = pokemon.type
        
        bioTextView.text = pokemon.bio
        
        let nextEvoImg = UIImage(named: "\(pokemon.nextEvoImage)")
        evoImage.image = nextEvoImg
        
        nextEvoLbl.text = pokemon.nextEvoText
        
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
