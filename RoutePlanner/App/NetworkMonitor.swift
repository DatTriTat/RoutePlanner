import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var isConnected: Bool = true

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    public var isReachable: Bool {
        return isConnected
    }
}
