// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_fetch.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$galleryFetchHash() => r'66012a9fcc6ce286cd982e7d3ab70adc5a71f391';

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

abstract class _$GalleryFetch
    extends BuildlessAutoDisposeAsyncNotifier<GalleryState> {
  late final AssetPathEntity asset;
  late final int page;

  FutureOr<GalleryState> build(
    AssetPathEntity asset,
    int page,
  );
}

/// See also [GalleryFetch].
@ProviderFor(GalleryFetch)
const galleryFetchProvider = GalleryFetchFamily();

/// See also [GalleryFetch].
class GalleryFetchFamily extends Family<AsyncValue<GalleryState>> {
  /// See also [GalleryFetch].
  const GalleryFetchFamily();

  /// See also [GalleryFetch].
  GalleryFetchProvider call(
    AssetPathEntity asset,
    int page,
  ) {
    return GalleryFetchProvider(
      asset,
      page,
    );
  }

  @override
  GalleryFetchProvider getProviderOverride(
    covariant GalleryFetchProvider provider,
  ) {
    return call(
      provider.asset,
      provider.page,
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
  String? get name => r'galleryFetchProvider';
}

/// See also [GalleryFetch].
class GalleryFetchProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GalleryFetch, GalleryState> {
  /// See also [GalleryFetch].
  GalleryFetchProvider(
    this.asset,
    this.page,
  ) : super.internal(
          () => GalleryFetch(GalleryState.initial())
            ..asset = asset
            ..page = page,
          from: galleryFetchProvider,
          name: r'galleryFetchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$galleryFetchHash,
          dependencies: GalleryFetchFamily._dependencies,
          allTransitiveDependencies:
              GalleryFetchFamily._allTransitiveDependencies,
        );

  final AssetPathEntity asset;
  final int page;

  @override
  bool operator ==(Object other) {
    return other is GalleryFetchProvider &&
        other.asset == asset &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<GalleryState> runNotifierBuild(
    covariant GalleryFetch notifier,
  ) {
    return notifier.build(
      asset,
      page,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
