enum KycState { notStarted, detailsSubmitted, panVerified, bankVerified, underReview, verified, rejected }

class KycStatus {
  final KycState state;
  final String message;
  const KycStatus({required this.state, required this.message});

  factory KycStatus.fromJson(Map<String, dynamic> json) {
    final value = json['status']?.toString().toLowerCase() ?? 'not_started';
    final map = {
      'details_submitted': KycState.detailsSubmitted,
      'pan_verified': KycState.panVerified,
      'bank_verified': KycState.bankVerified,
      'under_review': KycState.underReview,
      'verified': KycState.verified,
      'rejected': KycState.rejected,
    };
    return KycStatus(state: map[value] ?? KycState.notStarted, message: json['message']?.toString() ?? '');
  }
}
