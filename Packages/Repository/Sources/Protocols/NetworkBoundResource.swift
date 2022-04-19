//
//  NetworkBoundResource.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import Combine
import Common

protocol NetworkBoundResource {
    associatedtype Local
    associatedtype Remote
    associatedtype Output

    var schedulers: Schedulers { get }
    var shouldFetchFromRemote: Bool { get }
    func getLocalData() -> AnyPublisher<Local, Never>
    func getRemoteData() -> AnyPublisher<Remote, Error>
    
    func mapRemoteToLocal(_ remote: Remote) -> Local
    func mapLocalToOutput(_ local: Local) -> Output
    func saveToLocal(_ local: Local)
}

// Add isOnline functionality while doing HTTPS requests
extension NetworkBoundResource {
    
    var shouldFetchFromRemote: Bool { true }

    func load() -> AnyPublisher<Resource<Output>, Never> {
        AnyPublisher.create { (observer: AnyObserver<Resource<Output>, Never>) in
            
            var requestFinished = false
            var latestOutput: Output?
            
            let localCancellable = getLocalData()
                .receive(on: schedulers.main)
                .map { mapLocalToOutput($0) }
                .handleEvents(receiveOutput: { latestOutput = $0 })
                .map({output -> Resource<Output> in
                    if self.shouldFetchFromRemote {
                        return requestFinished ? Resource.success(output) : Resource.loading(output)
                    } else {
                        return Resource.success(output)
                    }
                })
                .sink { value in
                    observer.onNext(value)
                }

            var remoteCancellable: Cancellable?
            if shouldFetchFromRemote {
                remoteCancellable = getRemoteData()
                    .subscribe(on: schedulers.global)
                    .receive(on: schedulers.global)
                    .handleEvents(receiveOutput: { output in
                        requestFinished = true
                        let remote = mapRemoteToLocal(output)
                        saveToLocal(remote)
                    })
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            observer.onNext(.failure(latestOutput, error))
                        default: break
                        }
                    }, receiveValue: { local in
                        
                    })
            }
            return Disposable {
                localCancellable.cancel()
                remoteCancellable?.cancel()
            }
        }
    }
}
