import 'dart:convert';
import 'package:flutter/services.dart';

sealed class DataResult<T> {
  const DataResult();
}

class DataSuccess<T> extends DataResult<T> {
  final T data;
  const DataSuccess(this.data);
}

class DataError<T> extends DataResult<T> {
  final String message;
  final Object? error;
  const DataError(this.message, {this.error});
}

abstract class DataSource {
  Future<String> load(String path);
}

class BundleSource extends DataSource {
  @override
  Future<String> load(String path) async {
    return await rootBundle.loadString(path);
  }
}

class DataLoader<T> {
  final DataSource source;
  final String path;
  final T Function(dynamic) fromJson;

  const DataLoader(this.source, this.path, this.fromJson);

  Future<DataResult<T>> load() async {
    try {
      final jsonString = await source.load(path);
      final decoded = jsonDecode(jsonString);
      return DataSuccess(fromJson(decoded));
    } catch (e) {
      return DataError('Failed to load data from $path', error: e);
    }
  }
}
