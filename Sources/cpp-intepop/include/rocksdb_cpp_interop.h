#pragma once

#include <rocksdb/db.h>
#include <rocksdb/utilities/transaction_db.h>

namespace swiftrocks {

using namespace rocksdb;
class TransactionDB {
public:
  TransactionDB() noexcept = default;
  ~TransactionDB() noexcept;

  Status Open(const Options& options,
    const TransactionDBOptions& txn_db_options,
    const std::string& dbname) noexcept;

  Iterator* NewIterator(const ReadOptions &options) noexcept;

  std::shared_ptr<rocksdb::TransactionDB> m_db;
};

} // namespace swiftrocks
