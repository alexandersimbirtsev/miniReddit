
import Foundation

class AsyncOperation: Operation {
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
    override var isReady:        Bool { super.isReady && state == .ready }
    override var isExecuting:    Bool { state == .executing }
    override var isFinished:     Bool { state == .finished }
    override var isAsynchronous: Bool { true }
    
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

//MARK: - State
extension AsyncOperation {
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
}
