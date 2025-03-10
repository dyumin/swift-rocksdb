import CxxStdlib
import cpp_intepop
import rocksdb
import Foundation // Data

extension rocksdb.Status: Error, CustomStringConvertible, @unchecked Sendable {
    @inlinable
    public var description: String {
        "\(ToString())"
    }
}

extension swiftrocks.TransactionDBOpenResult {
    @inlinable
    public consuming func asResult() -> Result<
        swiftrocks.TransactionDB, rocksdb.Status
    > {
        if self.status.ok() {
            return Result.success(self.db)
        } else {
            return Result.failure(self.status)
        }
    }
}

public class Iterator: IteratorProtocol {
    @usableFromInline
    let handle: swiftrocks.Iterator
    @usableFromInline
    var first = true
    @usableFromInline
    let rocksDBIterator: OpaquePointer!  // to avoid double pointer hopping

    @inlinable
    init(handle: swiftrocks.Iterator) {
        self.handle = handle
        rocksDBIterator = swiftrocks.GetIterator(handle)
        swiftrocks.SeekToFirst(rocksDBIterator)
    }

    @inlinable
    public func next() -> (key: rocksdb.Slice, value: rocksdb.Slice)? {
        if first {
            guard swiftrocks.Valid(rocksDBIterator) else {
                return nil
            }
            first = false
        } else {
            swiftrocks.Next(rocksDBIterator)
            guard swiftrocks.Valid(rocksDBIterator) else {
                return nil
            }
        }

        return (
            swiftrocks.key(rocksDBIterator), swiftrocks.value(rocksDBIterator)
        )
    }

    public typealias Element = (key: rocksdb.Slice, value: rocksdb.Slice)
}

// only one active iterator supported currently
extension swiftrocks.Iterator: Sequence {
    @inlinable
    public func makeIterator() -> Iterator {
        return Iterator(handle: self)
    }
}

extension swiftrocks.Transaction {
    @inlinable
    public func GetIterator(
        _ options: rocksdb.ReadOptions
    ) -> swiftrocks.Iterator {
        return swiftrocks.GetIterator(self, options)
    }

    @inlinable
    public func GetIterator(
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!,
        _ options: rocksdb.ReadOptions
    ) -> swiftrocks.Iterator {
        return swiftrocks.GetIterator(self, options, columnFamily)
    }

    @inlinable
    public func Put(_ key: rocksdb.Slice, _ value: rocksdb.Slice)
        -> rocksdb.Status
    {
        return swiftrocks.Put(self, key, value)
    }

    @inlinable
    public func Put(
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!,
        _ key: rocksdb.Slice,
        _ value: rocksdb.Slice
    )
        -> rocksdb.Status
    {
        return swiftrocks.Put(self, columnFamily, key, value)
    }

    @inlinable
    public func Get(
        _ readOptions: rocksdb.ReadOptions, _ key: rocksdb.Slice,
        _ value: UnsafeMutablePointer<std.string>!
    )
        -> rocksdb.Status
    {
        return swiftrocks.Get(self, readOptions, key, value)
    }

    @inlinable
    public func Get(
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!,
        _ readOptions: rocksdb.ReadOptions, _ key: rocksdb.Slice,
        _ value: UnsafeMutablePointer<std.string>!
    )
        -> rocksdb.Status
    {
        return swiftrocks.Get(self, readOptions, columnFamily, key, value)
    }

    @inlinable
    public func Delete(
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!,
        _ key: rocksdb.Slice
    )
        -> rocksdb.Status
    {
        return swiftrocks.Delete(self, columnFamily, key)
    }

    @inlinable
    public func Commit()
        -> rocksdb.Status
    {
        return swiftrocks.Commit(self)
    }
}

extension swiftrocks.TransactionDB {
    @inlinable
    public func Put(
        _ writeOptions: rocksdb.WriteOptions, _ key: rocksdb.Slice,
        _ value: rocksdb.Slice
    )
        -> rocksdb.Status
    {
        return swiftrocks.Put(self, writeOptions, key, value)
    }

    @inlinable
    public func Get(
        _ readOptions: rocksdb.ReadOptions, _ key: rocksdb.Slice,
        _ value: UnsafeMutablePointer<std.string>!
    )
        -> rocksdb.Status
    {
        return swiftrocks.Get(self, readOptions, key, value)
    }

    @inlinable
    public func Get(
        _ readOptions: rocksdb.ReadOptions,
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!, _ key: rocksdb.Slice,
        _ value: UnsafeMutablePointer<std.string>!
    )
        -> rocksdb.Status
    {
        return swiftrocks.Get(self, readOptions, columnFamily, key, value)
    }

    @inlinable
    public func NewIterator(
        _ readOptions: rocksdb.ReadOptions,
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!
    )
        -> swiftrocks.Iterator
    {
        return swiftrocks.NewIterator(self, readOptions, columnFamily)
    }

    @inlinable
    public func BeginTransaction(
        _ writeOptions: rocksdb.WriteOptions,
        _ transactionOptions: rocksdb.TransactionOptions
    ) -> swiftrocks.Transaction {
        return swiftrocks.BeginTransaction(
            self, writeOptions, transactionOptions)
    }

    @inlinable
    public func EnableAutoCompaction(
        _ columnFamilyHandles: swiftrocks.ColumnFamilyHandlePointerVector
    ) -> rocksdb.Status {
        return swiftrocks.EnableAutoCompaction(
            self, columnFamilyHandles)
    }

    @inlinable
    public func CreateColumnFamilies(
        _ columnFamilyOptions: rocksdb.ColumnFamilyOptions,
        _ columnFamilyNames: swiftrocks.ColumnFamiliesVector,
        _ columnFamilyHandles: inout swiftrocks.ColumnFamilyHandlePointerVector
    ) -> rocksdb.Status {
        return swiftrocks.CreateColumnFamilies(
            self, columnFamilyOptions, columnFamilyNames, &columnFamilyHandles)
    }

    @inlinable
    public func GetProperty(
        _ columnFamily: UnsafeMutablePointer<rocksdb.ColumnFamilyHandle>!,
        _ property: rocksdb.Slice,
        _ value: UnsafeMutablePointer<std.string>!
    )
        -> Bool
    {
        return swiftrocks.GetProperty(self, columnFamily, property, value)
    }
}

extension rocksdb.Slice {
    @inlinable
    public func asArray() -> [UInt8] {
        if self.empty() {
            return []
        }
        return .init(
            unsafeUninitializedCapacity: self.size(),
            initializingWith: { buffer, initializedCount in
                memcpy(buffer.baseAddress!, self.data(), self.size())
                initializedCount = self.size()
            })
    }

    @inlinable
    public func asData() -> Data {
        return Data(bytes: self.data(), count: self.size())
    }

    @inlinable
    public init(_ staticString: StaticString) {
        self.init(staticString.utf8Start, staticString.utf8CodeUnitCount)
    }
}
