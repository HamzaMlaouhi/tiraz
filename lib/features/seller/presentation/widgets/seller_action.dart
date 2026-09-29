import 'package:flutter/material.dart';

/// Awaits a [SellerCubit] mutation and shows its failure message, if any,
/// as a snackbar — the optimistic UI has already rolled itself back.
Future<void> runSellerAction(BuildContext context, Future<String?> action) async {
  final error = await action;
  if (error != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
