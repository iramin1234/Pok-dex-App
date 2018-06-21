//
//  ViewController.swift
//  Pokedex
//
//  Created by Ramin Ikhilov  on 6/19/18.
//  Copyright © 2018 Ramin Ikhilov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var PokemonArr = [Pokemon]()
    var filteredPokemonArr = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer: AVAudioPlayer!
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        parseCSV()
        initializeAudio()
    }
    
    func parseCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                let pokemon = Pokemon(name: name, id: id)
                
                PokemonArr.append(pokemon)
            }
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            let lowerCase = searchBar.text!.lowercased()
            filteredPokemonArr = PokemonArr.filter({$0.name.range(of: lowerCase) != nil})
            collection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let pokemon: Pokemon!
            
            if inSearchMode{
                pokemon = filteredPokemonArr[indexPath.row]
            }else{
                pokemon = PokemonArr[indexPath.row]
            }
            cell.configCell(pokemon: pokemon)
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon: Pokemon!
        if inSearchMode{
            pokemon = filteredPokemonArr[indexPath.row]
        }else{
            pokemon = PokemonArr[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeDetailSegue", sender: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailSegue"{
            if let pokeDetailVC = segue.destination as? PokeDetailVC{
                if let pokemon = sender as? Pokemon{
                    pokeDetailVC.pokemon = pokemon
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemonArr.count
        }
        return PokemonArr.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func initializeAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
}

