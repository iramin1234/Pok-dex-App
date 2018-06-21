//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ramin Ikhilov  on 6/19/18.
//  Copyright © 2018 Ramin Ikhilov. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name: String!
    private var _id: Int!
    private var _bio: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _evoLvl: String!
    private var _nextEvoText: String!
    private var _nextEvoImage: String!
    
    
    private var _pokeURL: String!
    private var _bioURL: String!
    
    var nextEvoImage: String{
        if _nextEvoImage == nil{
            return "0"
        }else{
            return _nextEvoImage
        }
    }
    var bio: String{
        if _bio == nil{
            return ""
        }else{
            return _bio
        }
    }
    var type: String{
        if _type == nil{
            return ""
        }else{
            return _type
        }
    }
    var defense: String{
        if _defense == nil{
            return ""
        }else{
            return _defense
        }
    }
    var height: String{
        if _height == nil{
            return ""
        }else{
            return _height
        }
    }
    var weight: String{
        if _weight == nil{
            return ""
        }else{
            return _weight
        }
    }
    var attack: String{
        if _attack == nil{
            return ""
        }else{
            return _attack
        }
    }
    var evoLvl: String{
        if _evoLvl == nil{
            return ""
        }else{
            return _evoLvl
        }
    }
    var nextEvoText: String{
        if _nextEvoText == nil{
            return "NO EVOLUTION"
        }else{
            return _nextEvoText
        }
    }
    
    var name: String{
        return _name
    }
    var id: Int{
        return _id
    }
    
    init(name: String, id: Int){
        _name = name
        _id = id
        
        self._pokeURL = "\(BASE_URL)\(POKEMON_URL)\(self._id!)"
        self._bioURL = "\(BASE_URL)\(SPECIES_URL)\(self._id!)"
    }
    
    
    func downloadPokeDetails(complete: @escaping DownloadComplete){
        
        let url = URL(string: _pokeURL)!
        print(_pokeURL)
        Alamofire.request(url).responseJSON { (response) in
            //print(response.result.value ?? "empty")

            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? Int{
                    self._weight = "\(weight)"
                    print(weight)
                }
                if let height = dict["height"] as? Int{
                    self._height = "\(height)"
                    print(height)
                }
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    if let attack = stats[4]["base_stat"] as? Int{
                        self._attack = "\(attack)"
                        print(attack)
                    }
                    if let defense = stats[3]["base_stat"] as? Int{
                        self._defense = "\(defense)"
                        print(defense)
                    }
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    
                    if let type = types[0]["type"] as? Dictionary<String, AnyObject>{
                        if let name = type["name"] as? String{
                            self._type = name.capitalized
                        }
                    }
                    // if there is more than one type
                    if types.count > 1{
                        for x in 1..<types.count{
                            if let type = types[x]["type"] as? Dictionary<String, AnyObject>{
                                if let name = type["name"] as? String{
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                    
                }else{
                    self._type = ""
                }
            }
            
            let bioURL = URL(string: self._bioURL)!
            print(bioURL)
            Alamofire.request(bioURL).responseJSON(completionHandler: { (response) in
                if let dict = response.result.value as? Dictionary<String, AnyObject>{
                    if let flavor_text_entries = dict["flavor_text_entries"] as? [Dictionary<String, AnyObject>]{
                        for x in 0..<flavor_text_entries.count{
                            if let language = flavor_text_entries[x]["language"] as? Dictionary<String, AnyObject>{
                                if let name = language["name"] as? String{
                                    if name == "en"{
                                        if let flavor_text = flavor_text_entries[x]["flavor_text"] as? String{
                                            // remove instances of \n that is retrieved from api call
                                            //let filteredString = String(flavor_text.filter { !"\n\t\r".contains($0) })
                                            var filteredString = flavor_text.replacingOccurrences(of: "^\\n*", with: "", options: .regularExpression)
                                            filteredString = filteredString.replacingOccurrences(of: "POKMON", with: "Pokémon", options: .regularExpression)
                                            self._bio = filteredString
                                            print(self._bio)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                //Now get the evolution URL from the current URL
                
                if let evoURLDict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let evoURLRaw = evoURLDict["evolution_chain"]!["url"]! {
                        
                        let evoURL = "\(evoURLRaw)"
                        print(evoURL)
                        //Now request the relative evolution URL
                        Alamofire.request(evoURL).responseJSON(completionHandler: { (response) in
                            print(response.result)
                            
                            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                               
                                if let chain = dict["chain"] as? Dictionary<String, AnyObject>{
                                    if let firstSpeciesName = chain["species"]!["name"] as? String{
                                        if firstSpeciesName.lowercased() == self._name.lowercased(){
                                            var firstEvoText = "Evolution: "
                                            
                                            // find first evo
                                            if let firstEvo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] , firstEvo.count > 0{
                                                // get first evolution name
                                                if let firstEvoName = firstEvo[0]["species"]!["name"] as? String{
                                                    firstEvoText += "\(firstEvoName.capitalized) "
                                                }
                                                // get first evo min level
                                                if let evolution_details = firstEvo[0]["evolution_details"] as? [Dictionary<String, AnyObject>]{
                                                    
                                                    if let min_level = evolution_details[0]["min_level"] as? Int{
                                                        firstEvoText += "at lvl \(min_level)"
                                                    }
                                                }
                                                
                                                self._nextEvoText = firstEvoText
                                                
                                                
                                                if let firstEvoURL = firstEvo[0]["species"]!["url"] as? String {
                                                    
                                                    let evoString2 = (firstEvoURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                    
                                                    self._nextEvoImage = (evoString2 as AnyObject).replacingOccurrences(of: "/", with: "")
                                                }
                                                
                                            }
                                        }else{
                                            //look to see if there is a 2nd evo example: charmeleon -> charizard
                                            if let firstEvo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] , firstEvo.count > 0{
                                                if let firstEvoName = firstEvo[0]["species"]!["name"] as? String{
                                                    if self._name.lowercased() == firstEvoName{
                                                        
                                                
                                                        var secondEvoText = "Evolution: "
                                                        // find second evo
                                                        if let secondEvo = firstEvo[0]["evolves_to"] as? [Dictionary<String, AnyObject>] , secondEvo.count > 0{
                                                            // get second evolution name
                                                            if let secondEvoName = secondEvo[0]["species"]!["name"] as? String{
                                                                secondEvoText += "\(secondEvoName.capitalized) "
                                                            }
                                                            // get second evo min level
                                                            if let evolution_details = secondEvo[0]["evolution_details"] as? [Dictionary<String, AnyObject>]{
                                                                
                                                                if let min_level = evolution_details[0]["min_level"] as? Int{
                                                                    secondEvoText += "at lvl \(min_level)"
                                                                }
                                                            }
                                                            
                                                            self._nextEvoText = secondEvoText
                                                            
                                                            
                                                            if let secondEvoURL = secondEvo[0]["species"]!["url"] as? String {
                                                                
                                                                let secondEvoString = (secondEvoURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                                
                                                                self._nextEvoImage = (secondEvoString as AnyObject).replacingOccurrences(of: "/", with: "")
                                                            }
                                                        }
                                                    }else{
                                                        self._nextEvoImage = ""
                                                        self._nextEvoText = "NO EVOLUTION"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                

                            }
                            complete()
                        })
                        
                    }
                }
                
                complete()
            })
            complete()
        }
        
    }
}






