import rocksdb

extension rocksdb.Status : Error, CustomStringConvertible, @unchecked Sendable {
    public var description: String {
        "\(ToString())"
    }
}
