//
//  Binder.swift
//  MomentupCase
//
//  Created by Hasan onur Can on 18.08.2022.
//

import Foundation
class Binder <T> {
    var value: T?{
        didSet{
            observer?(value)
        }
    }
    var observer:((T?)->())?
    func bind (observer:@escaping (T?)->()){
        self.observer = observer
    }
}
