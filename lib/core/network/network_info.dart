// Network connectivity checker for online/offline detection.
// Relates to: auth_repository_impl.dart, soap_client.dart

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

