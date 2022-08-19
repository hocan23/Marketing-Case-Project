//
//  Extensions.swift
//  MomentupCase
//
//  Created by Hasan Onur Can on 8/7/22.
//

import Foundation
import AVFAudio
import Lottie
class Utils{
    static var sortedProducts : [Product]?
    static func saveLocal (array:[String], key : String){
    let defaults = UserDefaults.standard
    defaults.set(array, forKey: key)
}
    static func readLocal (key: String)->[String]{
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: key) ?? [String]()
        return myarray
    }
    
   
    }

