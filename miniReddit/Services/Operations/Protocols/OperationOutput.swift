
// For passing data between operation dependencies
protocol OperationOutput {
    associatedtype Output
    
    var output: Output? { get }
}
