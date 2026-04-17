class VerificationEntity {
  final int employeeId;
  final String status;
  final String pdfPath;
  final String? rejectionReason;

  VerificationEntity({
    required this.employeeId,
    required this.status,
    required this.pdfPath,
    this.rejectionReason,
  });
}
