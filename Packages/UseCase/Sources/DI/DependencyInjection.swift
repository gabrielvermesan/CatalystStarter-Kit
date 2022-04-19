//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import Foundation
import Repository
import Common

final public class Injection {
    public static var shared: Injection = Injection()
    
    public var mainboardUseCase: MainboardUseCase {
        MainboardUseCaseImpl(userRepository: userRepository, tweetsRepository: tweetsRepository)
    }
    
    
    // MARK: Private
    
    private var userRepository: UserRepository { UserRepositoryImpl(schedulers: schedulers) }
    private var tweetsRepository: TweetsRepository { TweetsRepositoryImpl(schedulers: schedulers) }

    private lazy var schedulers: Schedulers = SchedulersImpl()
}
