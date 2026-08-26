class KycProfile {
  final String fullName;
  final String dob;
  final String panMasked;
  final String bankMasked;
  final String status;
  final String message;

  const KycProfile({required this.fullName, required this.dob, required this.panMasked, required this.bankMasked, required this.status, required this.message});

  factory KycProfile.fromJson(Map<String, dynamic> json) => KycProfile(
    fullName: json['full_name']?.toString() ?? '',
    dob: json['dob']?.toString() ?? '',
    panMasked: json['pan_masked']?.toString() ?? '',
    bankMasked: json['bank_masked']?.toString() ?? '',
    status: json['status']?.toString() ?? 'pending',
    message: json['message']?.toString() ?? '',
  );
}
