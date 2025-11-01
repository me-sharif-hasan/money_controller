import 'dart:developer' as dev;
import 'package:flutter/material.dart';

/// Logs technical errors to console and returns user-friendly message
class ErrorHandler {
  /// Log error to console with context
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    dev.log(
      'Error in $context: $error',
      error: error,
      stackTrace: stackTrace,
      name: 'money_controller',
    );
  }

  /// Get user-friendly error message from technical error
  static String getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Authentication errors - check specific codes first
    if (errorString.contains('sign_in_required')) {
      return 'Please sign in to continue.';
    }

    if (errorString.contains('session_expired')) {
      return 'Your session has expired. Please sign in again.';
    }

    if (errorString.contains('authentication_failed')) {
      return 'Authentication failed. Please try signing in again.';
    }

    if (errorString.contains('backup_not_found')) {
      return 'No backup found. Please create a backup first.';
    }

    // Network errors
    if (errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }

    // Authentication errors - generic
    if (errorString.contains('sign_in_canceled') ||
        errorString.contains('cancelled')) {
      return 'Sign in was cancelled.';
    }

    if (errorString.contains('sign_in_failed') ||
        errorString.contains('authentication') ||
        errorString.contains('auth')) {
      return 'Sign in failed. Please try again or check your settings.';
    }

    // API errors
    if (errorString.contains('people api') ||
        errorString.contains('people.googleapis.com')) {
      return 'Google API configuration needed. Please contact support.';
    }

    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('access denied')) {
      return 'Permission denied. Please grant necessary permissions.';
    }

    // Data errors
    if (errorString.contains('not found') ||
        errorString.contains('404')) {
      return 'Requested data not found.';
    }

    if (errorString.contains('invalid') ||
        errorString.contains('format')) {
      return 'Invalid data format. Please check your input.';
    }

    // Storage errors
    if (errorString.contains('storage') ||
        errorString.contains('disk') ||
        errorString.contains('space')) {
      return 'Storage error. Please check available space.';
    }

    // Timeout errors
    if (errorString.contains('timeout') ||
        errorString.contains('timed out')) {
      return 'Operation timed out. Please try again.';
    }

    // Generic fallback
    return 'An error occurred. Please try again.';
  }

  /// Show error snackbar with user-friendly message and log technical error
  static void showErrorSnackBar(
    BuildContext context,
    String operationContext,
    dynamic error, {
    StackTrace? stackTrace,
    Duration duration = const Duration(seconds: 4),
  }) {
    // Log technical error
    logError(operationContext, error, stackTrace);

    // Show user-friendly message
    final message = getUserFriendlyMessage(error);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[700],
          duration: duration,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[700],
          duration: duration,
        ),
      );
    }
  }

  /// Show info snackbar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue[700],
          duration: duration,
        ),
      );
    }
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange[700],
          duration: duration,
        ),
      );
    }
  }
}

