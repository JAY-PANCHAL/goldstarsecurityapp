class VerificationSubmitModel {
  final int employeeId;
  final String status;
  final String pdfPath;
  final String? rejectionReason;

  VerificationSubmitModel({
    required this.employeeId,
    required this.status,
    required this.pdfPath,
    this.rejectionReason,
  });
}
