//
//  Schedulers.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation

public protocol Schedulers {
    var main: DispatchQueue { get }
    var global: DispatchQueue { get }
}

final public class SchedulersImpl: Schedulers {
    
    public let main: DispatchQueue
    public let global: DispatchQueue
  
    public init(main: DispatchQueue = DispatchQueue.main,
                global: DispatchQueue = DispatchQueue.global()) {
        self.main = main
        self.global = global
    }
}
