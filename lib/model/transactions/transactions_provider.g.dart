// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'c4215354ffab1bd6083dfe094e9c1c324f391059';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<Transaction>>.internal(
  transactions,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionsRef = AutoDisposeFutureProviderRef<List<Transaction>>;
String _$transactionHash() => r'6a6f27f9bbda9924daa2e8611737bb1adf50aa48';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef TransactionRef = AutoDisposeFutureProviderRef<Transaction>;

/// See also [transaction].
@ProviderFor(transaction)
const transactionProvider = TransactionFamily();

/// See also [transaction].
class TransactionFamily extends Family<AsyncValue<Transaction>> {
  /// See also [transaction].
  const TransactionFamily();

  /// See also [transaction].
  TransactionProvider call(
    String id,
  ) {
    return TransactionProvider(
      id,
    );
  }

  @override
  TransactionProvider getProviderOverride(
    covariant TransactionProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionProvider';
}

/// See also [transaction].
class TransactionProvider extends AutoDisposeFutureProvider<Transaction> {
  /// See also [transaction].
  TransactionProvider(
    this.id,
  ) : super.internal(
          (ref) => transaction(
            ref,
            id,
          ),
          from: transactionProvider,
          name: r'transactionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionHash,
          dependencies: TransactionFamily._dependencies,
          allTransitiveDependencies:
              TransactionFamily._allTransitiveDependencies,
        );

  final String id;

  @override
  bool operator ==(Object other) {
    return other is TransactionProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
