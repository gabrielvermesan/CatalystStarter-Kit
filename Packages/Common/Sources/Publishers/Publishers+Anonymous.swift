//
//  Publishers+Anonymous.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import Combine

public struct AnyObserver<Output, Failure: Error> {
    public let onNext: ((Output) -> Void)
    public let onError: ((Failure) -> Void)
    public let onComplete: (() -> Void)
}

public struct Disposable {
    public let dispose: () -> Void
    public init(dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
}

extension Publishers {

    public struct Anonymous<Output, Failure: Swift.Error>: Publisher {
        private var closure: (AnySubscriber<Output, Failure>) -> Void

        public init(closure: @escaping (AnySubscriber<Output, Failure>) -> Void) {
            self.closure = closure
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Anonymous.Failure == S.Failure, Anonymous.Output == S.Input {
            let subscription = Subscriptions.Anonymous(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.start(closure)
        }
    }

}

extension Subscriptions {

    final class Anonymous<SubscriberType: Subscriber, Output, Failure>: Subscription where SubscriberType.Input == Output, Failure == SubscriberType.Failure {

        private var subscriber: SubscriberType?

        init(subscriber: SubscriberType) {
            self.subscriber = subscriber
        }

        func start(_ closure: @escaping (AnySubscriber<Output, Failure>) -> Void) {
            if let subscriber = subscriber {
                closure(AnySubscriber(subscriber))
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // Ignore demand for now
        }

        func cancel() {
            self.subscriber = nil
        }
    }

}

extension AnyPublisher {

    public static func create(_ closure: @escaping (AnySubscriber<Output, Failure>) -> Void) -> Self {
        Publishers.Anonymous<Output, Failure>(closure: closure)
            .eraseToAnyPublisher()
    }
    
    public static func create(subscribe: @escaping (AnyObserver<Output, Failure>) -> Disposable) -> Self {
        let subject = PassthroughSubject<Output, Failure>()
        var disposable: Disposable?
        return subject
            .handleEvents(receiveSubscription: { _ in
                disposable = subscribe(AnyObserver(
                    onNext: { output in subject.send(output) },
                    onError: { failure in subject.send(completion: .failure(failure)) },
                    onComplete: { subject.send(completion: .finished) }
                ))
            }, receiveCancel: { disposable?.dispose() })
            .eraseToAnyPublisher()
    }
}
