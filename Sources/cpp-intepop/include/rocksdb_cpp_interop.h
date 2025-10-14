#pragma once

#include <rocksdb/db.h>
#include <rocksdb/utilities/transaction_db.h>

namespace swiftrocks {

using namespace rocksdb;

using ColumnFamilyDescriptorVector = std::vector<ColumnFamilyDescriptor>;
using ColumnFamilyHandlePointerVector = std::vector<ColumnFamilyHandle *>;
using ColumnFamilyHandleUniquePtr = std::unique_ptr<ColumnFamilyHandle>;

using ColumnFamiliesVector = std::vector<std::string>;
inline Status ListColumnFamilies(const DBOptions &db_options,
                                 const std::string &name,
                                 ColumnFamiliesVector *column_families) {
    return rocksdb::DB::ListColumnFamilies(db_options, name, column_families);
}

using Transaction = std::shared_ptr<Transaction>;
using Iterator = std::shared_ptr<Iterator>;

using TransactionDB = std::shared_ptr<TransactionDB>;
using DB = std::unique_ptr<DB>;

inline Status
DestroyColumnFamilyHandle(const TransactionDB &transactionDB,
                          ColumnFamilyHandle *columnFamilyHandle) noexcept {
    return transactionDB->DestroyColumnFamilyHandle(columnFamilyHandle);
}

inline bool GetProperty(const TransactionDB &transactionDB,
                        ColumnFamilyHandle *column_family,
                        const Slice &property, std::string *value) noexcept {
    return transactionDB->GetProperty(column_family, property, value);
}

inline Status
CreateColumnFamilies(const TransactionDB &transactionDB,
                     const ColumnFamilyOptions &options,
                     const std::vector<std::string> &column_family_names,
                     std::vector<ColumnFamilyHandle *> *handles) noexcept {
    return transactionDB->CreateColumnFamilies(options, column_family_names,
                                               handles);
}

struct __attribute__((swift_attr("@frozen"))) TransactionDBOpenResult {
    TransactionDB db;
    Status status;
};

struct __attribute__((swift_attr("@frozen"))) DBOpenResult {
    DB db;
    Status status;
};

inline uint32_t GetID(const ColumnFamilyHandle *const handle) noexcept {
    return handle->GetID();
}

inline const std::string &
GetName(const ColumnFamilyHandle *const handle) noexcept {
    return handle->GetName();
}

inline TransactionDBOpenResult
Open(const Options &options, const TransactionDBOptions &txn_db_options,
     const ColumnFamilyDescriptorVector &column_families,
     ColumnFamilyHandlePointerVector *handles,
     const std::string &dbname) noexcept {
    handles->reserve(
                     column_families.size()); // after this assighment will not throw
    
    rocksdb::TransactionDB *dbptr = nullptr;
    auto status = rocksdb::TransactionDB::Open(options, txn_db_options, dbname,
                                               column_families, handles, &dbptr);
    
    return {TransactionDB(dbptr), std::move(status)};
}

inline Status
Close(const TransactionDB &transactionDB) noexcept {
    return transactionDB->Close();
}

inline Status
Close(const DB &db) noexcept {
    return db->Close();
}

inline DBOpenResult
OpenForReadOnly(const Options &options, const std::string &name,
                bool error_if_wal_file_exists = false) noexcept {
    std::unique_ptr<rocksdb::DB> dbptr;
    auto status = rocksdb::DB::OpenForReadOnly(options, name, &dbptr,
                                               error_if_wal_file_exists);
    return {DB(dbptr ? std::move(dbptr) : DB()), std::move(status)};
}

inline Status Get(const DB &db, const ReadOptions &options, const Slice &key,
                  std::string *value) noexcept {
    return db->Get(options, key, value);
}

inline Transaction
BeginTransaction(const TransactionDB &transactionDB,
                 const WriteOptions &write_options,
                 const TransactionOptions &txn_options) noexcept {
    return Transaction(
                       transactionDB->BeginTransaction(write_options, txn_options));
}

inline Iterator GetIterator(const Transaction &transaction,
                            const ReadOptions &options) noexcept {
    return Iterator(transaction->GetIterator(options));
}

inline Iterator GetIterator(const Transaction &transaction,
                            const ReadOptions &read_options,
                            ColumnFamilyHandle *column_family) noexcept {
    return Iterator(transaction->GetIterator(read_options, column_family));
}

inline Status Commit(const Transaction &transaction) noexcept {
    return transaction->Commit();
}

inline rocksdb::Iterator *GetIterator(const Iterator &iterator) noexcept {
    return iterator.get();
}

inline Status Put(const Transaction &transaction, const Slice &key,
                  const Slice &value) noexcept {
    return transaction->Put(key, value);
}

inline Status Put(const Transaction &transaction,
                  ColumnFamilyHandle *column_family, const Slice &key,
                  const Slice &value) noexcept {
    return transaction->Put(column_family, key, value);
}

inline Status Get(const Transaction &transaction, const ReadOptions &options,
                  const Slice &key, std::string *value) noexcept {
    return transaction->Get(options, key, value);
}

inline Status Get(const Transaction &transaction, const ReadOptions &options,
                  ColumnFamilyHandle *column_family, const Slice &key,
                  std::string *value) noexcept {
    return transaction->Get(options, column_family, key, value);
}

inline Status Delete(const Transaction &transaction,
                     ColumnFamilyHandle *column_family, const Slice &key,
                     const bool assume_tracked = false) noexcept {
    return transaction->Delete(column_family, key, assume_tracked);
}

inline Status Put(const TransactionDB &transactionDB,
                  const WriteOptions &options, const Slice &key,
                  const Slice &value) noexcept {
    return transactionDB->Put(options, key, value);
}

inline Status Get(const TransactionDB &transactionDB,
                  const ReadOptions &options, const Slice &key,
                  std::string *value) noexcept {
    return transactionDB->Get(options, key, value);
}

inline Status Get(const TransactionDB &transactionDB,
                  const ReadOptions &options, ColumnFamilyHandle *column_family,
                  const Slice &key, std::string *value) noexcept {
    return transactionDB->Get(options, column_family, key, value);
}

inline Iterator NewIterator(const TransactionDB &transactionDB,
                            const ReadOptions &options,
                            ColumnFamilyHandle *column_family) noexcept {
    return Iterator(transactionDB->NewIterator(options, column_family));
}

inline Status EnableAutoCompaction(
                                   const TransactionDB &transactionDB,
                                   const ColumnFamilyHandlePointerVector &column_family_handles) noexcept {
                                       return transactionDB->EnableAutoCompaction(column_family_handles);
                                   }

inline bool Valid(const Iterator &iterator) noexcept {
    return iterator->Valid();
}
inline bool Valid(rocksdb::Iterator *const iterator) noexcept {
    return iterator->Valid();
}
inline void SeekToFirst(const Iterator &iterator) noexcept {
    iterator->SeekToFirst();
}
inline void SeekToFirst(rocksdb::Iterator *const iterator) noexcept {
    iterator->SeekToFirst();
}
inline Slice key(const Iterator &iterator) noexcept { return iterator->key(); }
inline Slice key(rocksdb::Iterator *const iterator) noexcept {
    return iterator->key();
}
inline Slice value(const Iterator &iterator) noexcept {
    return iterator->value();
}
inline Slice value(rocksdb::Iterator *const iterator) noexcept {
    return iterator->value();
}
inline void Next(const Iterator &iterator) noexcept { return iterator->Next(); }
inline void Next(rocksdb::Iterator *const iterator) noexcept {
    return iterator->Next();
}

inline Status status(const Iterator &iterator) noexcept {
    return iterator->status();
}

} // namespace swiftrocks
