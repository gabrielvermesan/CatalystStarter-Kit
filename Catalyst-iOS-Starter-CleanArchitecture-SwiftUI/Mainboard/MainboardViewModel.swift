//
//  MainBoardViewModel.swift
//  Catalyst-iOS-Starter-CleanArchitecture-SwiftUI
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import Combine
import UseCase
import Foundation
import RxSwift

class MainboardViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var name: String = ""
    @Published var avatarUrl: URL = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/logo.png")!
    @Published var profileUrl: URL = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/logo.png")!
    
    @Published var tweets: [TweetDetails] = []
    
    private var anyCancallables = Set<AnyCancellable>()
    
    private let usecase: MainboardUseCase
    init(usecase: MainboardUseCase = Injection.shared.mainboardUseCase) {
        self.usecase = usecase
        
        usecase.getUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] resource in
                let value: UserDetails? = resource.value ?? nil
                
                if let userName = value?.userName {
                    self?.userName = userName
                }
                
                if let name = value?.name {
                    self?.name = name
                }
                
                if let avatar = value?.avatar, let url = URL(string: avatar) {
                    self?.avatarUrl = url
                }
                
                if let profile = value?.profile, let url = URL(string: profile) {
                    self?.profileUrl = url
                }
            }
            .store(in: &anyCancallables)
        
        usecase.getAllTweets()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] resource in
                let values = resource.value ?? []
                
                self?.tweets = values
            }
            .store(in: &anyCancallables)
    }
}
