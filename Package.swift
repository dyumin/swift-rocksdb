// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import class Foundation.FileManager

var rocksdbExclude = [
    "./rocksdb/db/db_basic_test.cc",
    "./rocksdb/env/env_basic_test.cc",

    "./rocksdb/cache/cache_reservation_manager_test.cc",
    "./rocksdb/cache/cache_test.cc",
    "./rocksdb/cache/compressed_secondary_cache_test.cc",
    "./rocksdb/cache/lru_cache_test.cc",
    "./rocksdb/cache/tiered_secondary_cache_test.cc",
    "./rocksdb/db/blob/blob_counting_iterator_test.cc",
    "./rocksdb/db/blob/blob_file_addition_test.cc",
    "./rocksdb/db/blob/blob_file_builder_test.cc",
    "./rocksdb/db/blob/blob_file_cache_test.cc",
    "./rocksdb/db/blob/blob_file_garbage_test.cc",
    "./rocksdb/db/blob/blob_file_reader_test.cc",
    "./rocksdb/db/blob/blob_garbage_meter_test.cc",
    "./rocksdb/db/blob/blob_source_test.cc",
    "./rocksdb/db/blob/db_blob_basic_test.cc",
    "./rocksdb/db/blob/db_blob_compaction_test.cc",
    "./rocksdb/db/blob/db_blob_corruption_test.cc",
    "./rocksdb/db/blob/db_blob_index_test.cc",
    "./rocksdb/db/column_family_test.cc",
    "./rocksdb/db/compact_files_test.cc",
    "./rocksdb/db/compaction/clipping_iterator_test.cc",
    "./rocksdb/db/compaction/compaction_job_stats_test.cc",
    "./rocksdb/db/compaction/compaction_job_test.cc",
    "./rocksdb/db/compaction/compaction_iterator_test.cc",
    "./rocksdb/db/compaction/compaction_picker_test.cc",
    "./rocksdb/db/compaction/compaction_service_test.cc",
    "./rocksdb/db/compaction/tiered_compaction_test.cc",
    "./rocksdb/db/comparator_db_test.cc",
    "./rocksdb/db/corruption_test.cc",
    "./rocksdb/db/cuckoo_table_db_test.cc",
    "./rocksdb/db/db_readonly_with_timestamp_test.cc",
    "./rocksdb/db/db_with_timestamp_basic_test.cc",
    "./rocksdb/db/db_block_cache_test.cc",
    "./rocksdb/db/db_bloom_filter_test.cc",
    "./rocksdb/db/db_compaction_filter_test.cc",
    "./rocksdb/db/db_compaction_test.cc",
    "./rocksdb/db/db_clip_test.cc",
    "./rocksdb/db/db_dynamic_level_test.cc",
    "./rocksdb/db/db_encryption_test.cc",
    "./rocksdb/db/db_flush_test.cc",
    "./rocksdb/db/db_inplace_update_test.cc",
    "./rocksdb/db/db_io_failure_test.cc",
    "./rocksdb/db/db_iter_test.cc",
    "./rocksdb/db/db_iter_stress_test.cc",
    "./rocksdb/db/db_iterator_test.cc",
    "./rocksdb/db/db_kv_checksum_test.cc",
    "./rocksdb/db/db_log_iter_test.cc",
    "./rocksdb/db/db_memtable_test.cc",
    "./rocksdb/db/db_merge_operator_test.cc",
    "./rocksdb/db/db_merge_operand_test.cc",
    "./rocksdb/db/db_options_test.cc",
    "./rocksdb/db/db_properties_test.cc",
    "./rocksdb/db/db_range_del_test.cc",
    "./rocksdb/db/db_rate_limiter_test.cc",
    "./rocksdb/db/db_secondary_test.cc",
    "./rocksdb/db/db_sst_test.cc",
    "./rocksdb/db/db_statistics_test.cc",
    "./rocksdb/db/db_table_properties_test.cc",
    "./rocksdb/db/db_tailing_iter_test.cc",
    "./rocksdb/db/db_test.cc",
    "./rocksdb/db/db_test2.cc",
    "./rocksdb/db/db_logical_block_size_cache_test.cc",
    "./rocksdb/db/db_universal_compaction_test.cc",
    "./rocksdb/db/db_wal_test.cc",
    "./rocksdb/db/db_with_timestamp_compaction_test.cc",
    "./rocksdb/db/db_write_buffer_manager_test.cc",
    "./rocksdb/db/db_write_test.cc",
    "./rocksdb/db/dbformat_test.cc",
    "./rocksdb/db/deletefile_test.cc",
    "./rocksdb/db/error_handler_fs_test.cc",
    "./rocksdb/db/obsolete_files_test.cc",
    "./rocksdb/db/external_sst_file_basic_test.cc",
    "./rocksdb/db/external_sst_file_test.cc",
    "./rocksdb/db/fault_injection_test.cc",
    "./rocksdb/db/file_indexer_test.cc",
    "./rocksdb/db/filename_test.cc",
    "./rocksdb/db/flush_job_test.cc",
    "./rocksdb/db/db_follower_test.cc",
    "./rocksdb/db/import_column_family_test.cc",
    "./rocksdb/db/listener_test.cc",
    "./rocksdb/db/log_test.cc",
    "./rocksdb/db/manual_compaction_test.cc",
    "./rocksdb/db/memtable_list_test.cc",
    "./rocksdb/db/merge_helper_test.cc",
    "./rocksdb/db/merge_test.cc",
    "./rocksdb/db/multi_cf_iterator_test.cc",
    "./rocksdb/db/options_file_test.cc",
    "./rocksdb/db/perf_context_test.cc",
    "./rocksdb/db/periodic_task_scheduler_test.cc",
    "./rocksdb/db/plain_table_db_test.cc",
    "./rocksdb/db/seqno_time_test.cc",
    "./rocksdb/db/prefix_test.cc",
    "./rocksdb/db/range_del_aggregator_test.cc",
    "./rocksdb/db/range_tombstone_fragmenter_test.cc",
    "./rocksdb/db/repair_test.cc",
    "./rocksdb/db/table_properties_collector_test.cc",
    "./rocksdb/db/version_builder_test.cc",
    "./rocksdb/db/version_edit_test.cc",
    "./rocksdb/db/version_set_test.cc",
    "./rocksdb/db/wal_manager_test.cc",
    "./rocksdb/db/wal_edit_test.cc",
    "./rocksdb/db/wide/db_wide_basic_test.cc",
    "./rocksdb/db/wide/wide_column_serialization_test.cc",
    "./rocksdb/db/wide/wide_columns_helper_test.cc",
    "./rocksdb/db/write_batch_test.cc",
    "./rocksdb/db/write_callback_test.cc",
    "./rocksdb/db/write_controller_test.cc",
    "./rocksdb/env/env_test.cc",
    "./rocksdb/env/io_posix_test.cc",
    "./rocksdb/env/mock_env_test.cc",
    "./rocksdb/file/delete_scheduler_test.cc",
    "./rocksdb/file/prefetch_test.cc",
    "./rocksdb/file/random_access_file_reader_test.cc",
    "./rocksdb/logging/auto_roll_logger_test.cc",
    "./rocksdb/logging/env_logger_test.cc",
    "./rocksdb/logging/event_logger_test.cc",
    "./rocksdb/memory/arena_test.cc",
    "./rocksdb/memory/memory_allocator_test.cc",
    "./rocksdb/memtable/inlineskiplist_test.cc",
    "./rocksdb/memtable/skiplist_test.cc",
    "./rocksdb/memtable/write_buffer_manager_test.cc",
    "./rocksdb/monitoring/histogram_test.cc",
    "./rocksdb/monitoring/iostats_context_test.cc",
    "./rocksdb/monitoring/statistics_test.cc",
    "./rocksdb/monitoring/stats_history_test.cc",
    "./rocksdb/options/configurable_test.cc",
    "./rocksdb/options/customizable_test.cc",
    "./rocksdb/options/options_settable_test.cc",
    "./rocksdb/options/options_test.cc",
    "./rocksdb/table/block_based/block_based_table_reader_test.cc",
    "./rocksdb/table/block_based/block_test.cc",
    "./rocksdb/table/block_based/data_block_hash_index_test.cc",
    "./rocksdb/table/block_based/full_filter_block_test.cc",
    "./rocksdb/table/block_based/partitioned_filter_block_test.cc",
    "./rocksdb/table/cleanable_test.cc",
    "./rocksdb/table/cuckoo/cuckoo_table_builder_test.cc",
    "./rocksdb/table/cuckoo/cuckoo_table_reader_test.cc",
    "./rocksdb/table/merger_test.cc",
    "./rocksdb/table/sst_file_reader_test.cc",
    "./rocksdb/table/table_test.cc",
    "./rocksdb/table/block_fetcher_test.cc",
    "./rocksdb/test_util/testutil_test.cc",
    "./rocksdb/trace_replay/block_cache_tracer_test.cc",
    "./rocksdb/trace_replay/io_tracer_test.cc",
    "./rocksdb/util/autovector_test.cc",
    "./rocksdb/util/bloom_test.cc",
    "./rocksdb/util/coding_test.cc",
    "./rocksdb/util/crc32c_test.cc",
    "./rocksdb/util/defer_test.cc",
    "./rocksdb/util/dynamic_bloom_test.cc",
    "./rocksdb/util/file_reader_writer_test.cc",
    "./rocksdb/util/filelock_test.cc",
    "./rocksdb/util/hash_test.cc",
    "./rocksdb/util/heap_test.cc",
    "./rocksdb/util/random_test.cc",
    "./rocksdb/util/rate_limiter_test.cc",
    "./rocksdb/util/repeatable_thread_test.cc",
    "./rocksdb/util/ribbon_test.cc",
    "./rocksdb/util/slice_test.cc",
    "./rocksdb/util/slice_transform_test.cc",
    "./rocksdb/util/string_util_test.cc",
    "./rocksdb/util/timer_queue_test.cc",
    "./rocksdb/util/timer_test.cc",
    "./rocksdb/util/thread_list_test.cc",
    "./rocksdb/util/thread_local_test.cc",
    "./rocksdb/util/udt_util_test.cc",
    "./rocksdb/util/work_queue_test.cc",
    "./rocksdb/utilities/agg_merge/agg_merge_test.cc",
    "./rocksdb/utilities/backup/backup_engine_test.cc",
    "./rocksdb/utilities/blob_db/blob_db_test.cc",
    "./rocksdb/utilities/cassandra/cassandra_functional_test.cc",
    "./rocksdb/utilities/cassandra/cassandra_format_test.cc",
    "./rocksdb/utilities/cassandra/cassandra_row_merge_test.cc",
    "./rocksdb/utilities/cassandra/cassandra_serialize_test.cc",
    "./rocksdb/utilities/checkpoint/checkpoint_test.cc",
    "./rocksdb/utilities/env_timed_test.cc",
    "./rocksdb/utilities/memory/memory_test.cc",
    "./rocksdb/utilities/merge_operators/string_append/stringappend_test.cc",
    "./rocksdb/utilities/object_registry_test.cc",
    "./rocksdb/utilities/option_change_migration/option_change_migration_test.cc",
    "./rocksdb/utilities/options/options_util_test.cc",
    "./rocksdb/utilities/persistent_cache/hash_table_test.cc",
    "./rocksdb/utilities/persistent_cache/persistent_cache_test.cc",
    "./rocksdb/utilities/persistent_cache/persistent_cache_bench.cc",
    "./rocksdb/utilities/simulator_cache/cache_simulator_test.cc",
    "./rocksdb/utilities/simulator_cache/sim_cache_test.cc",
    "./rocksdb/utilities/table_properties_collectors/compact_for_tiering_collector_test.cc",
    "./rocksdb/utilities/table_properties_collectors/compact_on_deletion_collector_test.cc",
    "./rocksdb/utilities/transactions/optimistic_transaction_test.cc",
    "./rocksdb/utilities/transactions/transaction_test.cc",
    "./rocksdb/utilities/transactions/lock/point/point_lock_manager_test.cc",
    "./rocksdb/utilities/transactions/write_committed_transaction_ts_test.cc",
    "./rocksdb/utilities/transactions/write_prepared_transaction_test.cc",
    "./rocksdb/utilities/transactions/write_unprepared_transaction_test.cc",
    "./rocksdb/utilities/transactions/lock/range/range_locking_test.cc",
    "./rocksdb/utilities/transactions/timestamped_snapshot_test.cc",
    "./rocksdb/utilities/ttl/ttl_test.cc",
    "./rocksdb/utilities/types_util_test.cc",
    "./rocksdb/utilities/util_merge_operators_test.cc",
    "./rocksdb/utilities/write_batch_with_index/write_batch_with_index_test.cc",

    "./rocksdb/utilities/secondary_index/faiss_ivf_index_test.cc",
    "./rocksdb/utilities/secondary_index/faiss_ivf_index.cc",


    "./rocksdb/test_util/mock_time_env.cc",
    "./rocksdb/test_util/testharness.cc",

    "./rocksdb/utilities/env_mirror_test.cc",
    "./rocksdb/utilities/cassandra/test_utils.cc",

    "./rocksdb/util/crc32c_ppc.c",
    "./rocksdb/util/crc32c_ppc_asm.S",
    "./rocksdb/util/build_version.cc.in",

    "./rocksdb/test_util/secondary_cache_test_util.cc",

    "./rocksdb/table/mock_table.cc",

    "./rocksdb/db/db_with_timestamp_test_util.cc",
    "./rocksdb/db/db_test_util.cc",

    "./rocksdb/port/README",

    "./rocksdb/cache/cache_bench.cc",
    "./rocksdb/db/c_test.c",
    "./rocksdb/db/forward_iterator_bench.cc",
    "./rocksdb/db/range_del_aggregator_bench.cc",
    "./rocksdb/util/filter_bench.cc",
    "./rocksdb/table/table_reader_bench.cc",
    "./rocksdb/memtable/memtablerep_bench.cc",
    "./rocksdb/util/log_write_bench.cc",
    "./rocksdb/utilities/persistent_cache/hash_table_bench.cc",

    "./rocksdb/utilities/transactions/lock/range/range_tree/lib/README",
    "./rocksdb/utilities/transactions/lock/range/range_tree/lib/COPYING.GPLv2",
    "./rocksdb/utilities/transactions/lock/range/range_tree/lib/COPYING.APACHEv2",
    "./rocksdb/utilities/transactions/lock/range/range_tree/lib/COPYING.AGPLv3",

    "./rocksdb/include/rocksdb/utilities/lua",
]

let package = Package(
    name: "swift-rocksdb",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "mybin", targets: ["mybin"]),
        .library(
            name: "swift-rocksdb",
            targets: ["rocksdb"]),
        .library(
            name: "cpp-intepop",
            targets: ["cpp-intepop"]),
    ],
    targets: [
        .executableTarget(
            name: "mybin",
            dependencies: [
                "rocksdb", "cpp-intepop",
            ],
            swiftSettings: [.interoperabilityMode(.Cxx)]),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "swift-rocksdb",
            swiftSettings: [.interoperabilityMode(.Cxx)]),
        .testTarget(
            name: "swift-rocksdbTests",
            dependencies: ["swift-rocksdb"]
        ),
        .target(
            name: "rocksdb",
            exclude: rocksdbExclude,
            sources: [
                "./rocksdb/cache",
                "./rocksdb/db",
                "./rocksdb/env",
                "./rocksdb/file",
                "./rocksdb/logging",
                "./rocksdb/memory",
                "./rocksdb/memtable",
                "./rocksdb/monitoring",
                "./rocksdb/options",
                "./rocksdb/port",
                "./rocksdb/table",
                "./rocksdb/test_util",
                "./rocksdb/trace_replay",
                "./rocksdb/util",
                "./rocksdb/utilities",
                "./extras/build_version.cc",
            ],
            publicHeadersPath: "./rocksdb/include",
            cSettings: [
                // This is available on all modern Linux systems, and is needed for efficient
                // MicroTimer implementation. Otherwise busy waits are used.
                .define("HAVE_TIMERFD", .when(platforms: [.linux])),
                .define(
                    "ROCKSDB_PLATFORM_POSIX",
                    .when(platforms: [.linux, .macOS])),
                .define(
                    "ROCKSDB_LIB_IO_POSIX", .when(platforms: [.linux, .macOS])),
                .define("OS_LINUX", .when(platforms: [.linux])),
                .define("OS_MACOSX", .when(platforms: [.macOS])),
                .headerSearchPath("./rocksdb"),
            ],
            cxxSettings: [
                // This is available on all modern Linux systems, and is needed for efficient
                // MicroTimer implementation. Otherwise busy waits are used.
                .define("HAVE_TIMERFD", .when(platforms: [.linux])),
                .define(
                    "ROCKSDB_PLATFORM_POSIX",
                    .when(platforms: [.linux, .macOS])),
                .define(
                    "ROCKSDB_LIB_IO_POSIX", .when(platforms: [.linux, .macOS])),
                .define("OS_LINUX", .when(platforms: [.linux])),
                .define("OS_MACOSX", .when(platforms: [.macOS])),
                .headerSearchPath("./rocksdb"),
            ],
            linkerSettings: [
                .linkedLibrary("m")
            ]
        ),
        .target(
            name: "cpp-intepop",
            dependencies: [
                "rocksdb"
            ],
            sources: [
                "./"
            ],
            publicHeadersPath: "./include",
            cSettings: [
                // This is available on all modern Linux systems, and is needed for efficient
                // MicroTimer implementation. Otherwise busy waits are used.
                .define("HAVE_TIMERFD", .when(platforms: [.linux])),
                .define("ROCKSDB_PLATFORM_POSIX", .when(platforms: [.linux])),
                .define("ROCKSDB_LIB_IO_POSIX", .when(platforms: [.linux])),
                .define("OS_LINUX", .when(platforms: [.linux])),
                .headerSearchPath("./rocksdb"),
            ],
            cxxSettings: [
                // This is available on all modern Linux systems, and is needed for efficient
                // MicroTimer implementation. Otherwise busy waits are used.
                .define("HAVE_TIMERFD", .when(platforms: [.linux])),
                .define("ROCKSDB_PLATFORM_POSIX", .when(platforms: [.linux])),
                .define("ROCKSDB_LIB_IO_POSIX", .when(platforms: [.linux])),
                .define("OS_LINUX", .when(platforms: [.linux])),
                .headerSearchPath("./rocksdb"),
            ]),
    ],

    cxxLanguageStandard: .cxx17
)
