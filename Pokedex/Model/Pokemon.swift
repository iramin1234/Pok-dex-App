//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ramin Ikhilov  on 6/19/18.
//  Copyright © 2018 Ramin Ikhilov. All rights reserved.
//

import Foundation

class Pokemon{
    private var _name: String!
    private var _id: Int!
    
    var name: String{
        return _name
    }
    var id: Int{
        return _id
    }
    
    init(name: String, id: Int){
        _name = name
        _id = id
    }
}
