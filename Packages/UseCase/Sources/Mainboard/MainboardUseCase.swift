
import Combine
import Repository
import Common

public protocol MainboardUseCase {
    func getUserProfile() -> AnyPublisher<Resource<UserDetails?>, Never>
    func getAllTweets() -> AnyPublisher<Resource<[TweetDetails]>, Never>
}

final class MainboardUseCaseImpl: MainboardUseCase {
    
    private let userRepository: UserRepository
    private let tweetsRepository: TweetsRepository

    init(userRepository: UserRepository, tweetsRepository: TweetsRepository) {
        self.userRepository = userRepository
        self.tweetsRepository = tweetsRepository
    }
    
    func getUserProfile() -> AnyPublisher<Resource<UserDetails?>, Never> {
        userRepository.getUserProfile()
            .map { resource -> Resource<UserDetails?> in
                
                let value: UserResponse? = resource.value ?? nil
                return resource.mapAs(value: UserDetails(response: value))
            }
            .eraseToAnyPublisher()
    }
    
    func getAllTweets() -> AnyPublisher<Resource<[TweetDetails]>, Never> {
        tweetsRepository.getAllTweets()
            .map { resource -> Resource<[TweetDetails]> in
                
                let values = resource.value ?? []
                return resource.mapAs(value: values.map(TweetDetails.init))
            }
            .eraseToAnyPublisher()
    }
}
