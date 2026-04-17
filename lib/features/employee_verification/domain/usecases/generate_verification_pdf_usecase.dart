import 'dart:io';
import 'package:flutter/services.dart';
import 'package:golstarsecurityapplatest/core/utils/public_downloads_exporter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateVerificationPdfUsecase {
  Future<File> call({
    required Map<String, dynamic> data,
    required String employeeName,
    required Uint8List? employeePhoto,
    required Uint8List? verifierSignature,
    required Uint8List? employeeSignature,
    String? createdDate,
    String? verifiedDate,
    String? verificationDate,
    String? verificationTimeSlot,
  }) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/arial_unicode.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/arial_bold.ttf'),
    );
    final theme = pw.ThemeData.withFont(base: regular, bold: bold);

    final doc = pw.Document();
    final now = DateTime.now();
    final generatedAtText = DateFormat('dd/MM/yyyy').format(now);
    final scheduleText =
        '${(verificationDate ?? '').trim()} ${(verificationTimeSlot ?? '').trim()}'
            .trim();

    final employeeDetails =
        (data['employeeDetails'] as Map<String, dynamic>?) ?? const {};
    final addressDetails =
        (data['addressDetails'] as Map<String, dynamic>?) ?? const {};
    final familyDetails =
        (data['familyDetails'] as Map<String, dynamic>?) ?? const {};
    final references =
        (data['references'] as Map<String, dynamic>?) ?? const {};
    final criminalRecord =
        (data['criminalRecord'] as Map<String, dynamic>?) ?? const {};
    final decision = (data['decision'] as Map<String, dynamic>?) ?? const {};

    String v(Map<String, dynamic> map, String key) {
      final raw = map[key];
      final s = (raw?.toString() ?? '').trim();
      // For a "filled printed form" layout, missing fields should look blank.
      if (s.isEmpty || s == '-' || s == '—') return '';
      return s;
    }

    String vOrDash(Map<String, dynamic> map, String key) {
      final s = v(map, key);
      return s.isEmpty ? '-' : s;
    }

    final genderText = v(employeeDetails, 'Gender').toLowerCase();
    final isMale =
        genderText.startsWith('m') || genderText.contains('male') == true;
    final isFemale =
        genderText.startsWith('f') || genderText.contains('female') == true;

    bool? parseYesNo(String text) {
      final t = text.trim().toLowerCase();
      if (t.isEmpty || t == '-' || t == '—' || t == 'na' || t == 'n/a') {
        return null;
      }
      if (t.startsWith('y') || t == 'true' || t == 'yes') return true;
      if (t.startsWith('n') || t == 'false' || t == 'no') return false;
      return null;
    }

    final isAddressConfirmed = parseYesNo(
      v(addressDetails, 'Address Confirmed'),
    );
    final hasCriminal = parseYesNo(v(criminalRecord, 'Has Criminal Cases'));

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(18),
        build: (context) {
          const borderColor = PdfColors.grey700;
          const hairline = 0.8;

          final labelStyle = pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey800,
          );
          final valueStyle = const pw.TextStyle(fontSize: 9.5);
          final headerStyle = pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          );

          pw.Widget sectionTitle(String title) {
            return pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 5),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
                border: pw.Border(
                  bottom: pw.BorderSide(color: borderColor, width: hairline),
                ),
              ),
              child: pw.Center(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          pw.Widget checkbox(bool checked) {
            return pw.Container(
              width: 10,
              height: 10,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 0.8),
              ),
              child: checked
                  ? pw.Center(
                      child: pw.Text(
                        '✓',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    )
                  : null,
            );
          }

          pw.Widget yesNoRow({required String label, required bool? value}) {
            return pw.Row(
              children: [
                if (label.trim().isNotEmpty)
                  pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(width: 6),
                checkbox(value == true),
                pw.SizedBox(width: 4),
                pw.Text('Yes', style: const pw.TextStyle(fontSize: 9)),
                pw.SizedBox(width: 12),
                checkbox(value == false),
                pw.SizedBox(width: 4),
                pw.Text('No', style: const pw.TextStyle(fontSize: 9)),
              ],
            );
          }

          pw.Widget boxed(pw.Widget child) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: hairline),
              ),
              child: child,
            );
          }

          pw.Widget underlineValue(
            String value, {
            int maxLines = 1,
            pw.TextAlign align = pw.TextAlign.left,
          }) {
            return pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 1),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.black, width: 0.6),
                ),
              ),
              child: pw.Text(
                value,
                style: valueStyle,
                maxLines: maxLines,
                overflow: pw.TextOverflow.clip,
                textAlign: align,
              ),
            );
          }

          pw.Widget lineField({
            required String label,
            required String value,
            double labelWidth = 78,
            int maxLines = 1,
          }) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: borderColor, width: hairline),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.SizedBox(
                    width: labelWidth,
                    child: pw.Text('$label :', style: labelStyle),
                  ),
                  pw.Expanded(child: underlineValue(value, maxLines: maxLines)),
                ],
              ),
            );
          }

          pw.Widget smallKeyValueRow({
            required String leftLabel,
            required String leftValue,
            required String rightLabel,
            required String rightValue,
          }) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: borderColor, width: hairline),
                ),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Row(
                      children: [
                        pw.Text('$leftLabel : ', style: labelStyle),
                        pw.Expanded(child: underlineValue(leftValue)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                    child: pw.Row(
                      children: [
                        pw.Text('$rightLabel : ', style: labelStyle),
                        pw.Expanded(child: underlineValue(rightValue)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          pw.Widget photoBox() {
            return pw.Container(
              width: 110,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: borderColor, width: hairline),
                ),
              ),
              padding: const pw.EdgeInsets.all(6),
              child: pw.Container(
                height: 110,
                width: double.infinity,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor, width: hairline),
                ),
                child: employeePhoto == null
                    ? pw.Text(
                        'Emp. Photo',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      )
                    : pw.Image(
                        pw.MemoryImage(employeePhoto),
                        fit: pw.BoxFit.cover,
                      ),
              ),
            );
          }

          List<String> splitRef(String input) {
            final normalized = input.replaceAll(' - ', '|');
            final parts = normalized.split('|').map((e) => e.trim()).toList();
            if (parts.isEmpty) return const ['', ''];
            final name = parts.isNotEmpty && parts[0].isNotEmpty
                ? parts[0]
                : '';
            final mobile = parts.length > 1 && parts[1].isNotEmpty
                ? parts[1]
                : '';
            return [name, mobile];
          }

          final ref1 = splitRef(v(references, 'Ref1'));
          final ref2 = splitRef(v(references, 'Ref2'));

          final outerBorder = pw.BoxDecoration(
            border: pw.Border.all(color: borderColor, width: 1),
          );

          pw.Widget signatureBox({
            required String label,
            required Uint8List? signatureBytes,
          }) {
            return pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    height: 62,
                    width: double.infinity,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: borderColor,
                        width: hairline,
                      ),
                    ),
                    child: (signatureBytes == null)
                        ? pw.SizedBox()
                        : pw.Image(
                            pw.MemoryImage(signatureBytes),
                            fit: pw.BoxFit.contain,
                          ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            );
          }

          return pw.Container(
            decoration: outerBorder,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // Header (no photo here; photo belongs to Personal Details box)
                  boxed(
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(
                                  'GOLD STAR JEWELLERY PVT. LTD',
                                  style: headerStyle,
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'Employee Verification Form',
                                  style: const pw.TextStyle(fontSize: 9.5),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Container(
                            width: 150,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text('Date : ', style: labelStyle),
                                    pw.Container(
                                      width: 85,
                                      child: underlineValue(
                                        generatedAtText,
                                        align: pw.TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                if (scheduleText.isNotEmpty)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(top: 4),
                                    child: pw.Text(
                                      'Schedule: $scheduleText',
                                      style: const pw.TextStyle(fontSize: 8),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ),
                                if ((createdDate ?? '').trim().isNotEmpty)
                                  pw.Text(
                                    'Created: ${createdDate!.trim()}',
                                    style: const pw.TextStyle(fontSize: 8),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                if ((verifiedDate ?? '').trim().isNotEmpty)
                                  pw.Text(
                                    'Verified: ${verifiedDate!.trim()}',
                                    style: const pw.TextStyle(fontSize: 8),
                                    textAlign: pw.TextAlign.right,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 8),

                  // Personal Details (line-by-line to match the scanned sheet)
                  boxed(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        sectionTitle('Personal Details'),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.stretch,
                                children: [
                                  smallKeyValueRow(
                                    leftLabel: 'Name',
                                    leftValue: v(
                                      employeeDetails,
                                      'Employee Name',
                                    ),
                                    rightLabel: 'Code No',
                                    rightValue: v(
                                      employeeDetails,
                                      'Employee Code',
                                    ),
                                  ),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          color: borderColor,
                                          width: hairline,
                                        ),
                                      ),
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Text('Gender : ', style: labelStyle),
                                        checkbox(isMale),
                                        pw.SizedBox(width: 4),
                                        pw.Text(
                                          'Male',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                        pw.SizedBox(width: 10),
                                        checkbox(isFemale),
                                        pw.SizedBox(width: 4),
                                        pw.Text(
                                          'Female',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                        pw.Spacer(),
                                        pw.Text('Age : ', style: labelStyle),
                                        pw.Container(
                                          width: 40,
                                          child: underlineValue(
                                            '',
                                            align: pw.TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  smallKeyValueRow(
                                    leftLabel: 'Mobile',
                                    leftValue: v(employeeDetails, 'Mobile'),
                                    rightLabel: 'Alt Mobile',
                                    rightValue: v(
                                      employeeDetails,
                                      'Alt Mobile',
                                    ),
                                  ),
                                  smallKeyValueRow(
                                    leftLabel: 'Email (Official)',
                                    leftValue: v(
                                      employeeDetails,
                                      'Email Official',
                                    ),
                                    rightLabel: 'Email (Personal)',
                                    rightValue: v(
                                      employeeDetails,
                                      'Email Personal',
                                    ),
                                  ),
                                  smallKeyValueRow(
                                    leftLabel: 'Aadhaar',
                                    leftValue: v(employeeDetails, 'Aadhaar'),
                                    rightLabel: 'PAN',
                                    rightValue: v(employeeDetails, 'PAN'),
                                  ),
                                  lineField(
                                    label: 'Address',
                                    value: v(addressDetails, 'Old Address'),
                                    labelWidth: 60,
                                    maxLines: 2,
                                  ),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          color: borderColor,
                                          width: hairline,
                                        ),
                                      ),
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Text(
                                          'Confirm Address : ',
                                          style: labelStyle,
                                        ),
                                        yesNoRow(
                                          label: '',
                                          value: isAddressConfirmed,
                                        ),
                                        pw.Spacer(),
                                        pw.Text(
                                          'Residence No. : ',
                                          style: labelStyle,
                                        ),
                                        pw.Container(
                                          width: 55,
                                          child: underlineValue(
                                            '',
                                            align: pw.TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  lineField(
                                    label: 'If No, correct address / landmark',
                                    value: v(addressDetails, 'New Address'),
                                    labelWidth: 150,
                                    maxLines: 2,
                                  ),
                                  lineField(
                                    label: 'GPS',
                                    value: v(addressDetails, 'GPS'),
                                    labelWidth: 35,
                                    maxLines: 1,
                                  ),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          color: borderColor,
                                          width: hairline,
                                        ),
                                      ),
                                    ),
                                    child: pw.Row(
                                      children: [
                                        pw.Text(
                                          'Crosscheck of the Home : ',
                                          style: labelStyle,
                                        ),
                                        checkbox(false),
                                        pw.SizedBox(width: 4),
                                        pw.Text(
                                          'Rented',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                        pw.SizedBox(width: 12),
                                        checkbox(false),
                                        pw.SizedBox(width: 4),
                                        pw.Text(
                                          'Owned',
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    child: pw.Text(
                                      'Family Details :',
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  lineField(
                                    label: 'Father',
                                    value: v(familyDetails, 'Father'),
                                    labelWidth: 60,
                                  ),
                                  lineField(
                                    label: 'Mother',
                                    value: v(familyDetails, 'Mother'),
                                    labelWidth: 60,
                                  ),
                                  lineField(
                                    label: 'Spouse',
                                    value: v(familyDetails, 'Spouse'),
                                    labelWidth: 60,
                                  ),
                                  lineField(
                                    label: 'Brother',
                                    value: v(familyDetails, 'Brother'),
                                    labelWidth: 60,
                                  ),
                                  lineField(
                                    label: 'Sister',
                                    value: v(familyDetails, 'Sister'),
                                    labelWidth: 60,
                                  ),
                                  lineField(
                                    label: 'Children',
                                    value: v(familyDetails, 'Children'),
                                    labelWidth: 60,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            photoBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 8),

                  // References / Criminal / Decision
                  boxed(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Container(
                          width: double.infinity,
                          color: PdfColors.grey200,
                          padding: const pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Center(
                            child: pw.Text(
                              'References / Criminal Cases',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(
                                color: borderColor,
                                width: hairline,
                              ),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.Text('1)', style: labelStyle),
                                    pw.SizedBox(height: 3),
                                    smallKeyValueRow(
                                      leftLabel: 'Name',
                                      leftValue: ref1[0],
                                      rightLabel: 'Mob',
                                      rightValue: ref1[1],
                                    ),
                                  ],
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.Text('2)', style: labelStyle),
                                    pw.SizedBox(height: 3),
                                    smallKeyValueRow(
                                      leftLabel: 'Name',
                                      leftValue: ref2[0],
                                      rightLabel: 'Mob',
                                      rightValue: ref2[1],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(
                                color: borderColor,
                                width: hairline,
                              ),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.Text(
                                'Any Criminal Cases : ',
                                style: labelStyle,
                              ),
                              yesNoRow(label: '', value: hasCriminal),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Row(
                                  children: [
                                    pw.Text('Details : ', style: labelStyle),
                                    pw.Expanded(
                                      child: underlineValue(
                                        v(criminalRecord, 'Details'),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Keep existing decision fields in a printed-form style
                        lineField(
                          label: 'Verification Status',
                          value: vOrDash(decision, 'Status'),
                          labelWidth: 110,
                        ),
                        lineField(
                          label: 'Reason (if rejected)',
                          value: vOrDash(decision, 'Rejection Reason'),
                          labelWidth: 110,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Signatures
                  pw.Row(
                    children: [
                      signatureBox(
                        label: 'Signature for Verification Officer',
                        signatureBytes: verifierSignature,
                      ),
                      pw.SizedBox(width: 10),
                      signatureBox(
                        label: 'Signature of Employee / Family Member',
                        signatureBytes: employeeSignature,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    height: 60,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: borderColor,
                        width: hairline,
                      ),
                    ),
                    child: pw.Text(
                      'Signature of Receiver (Human Resources)',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    final safeName = _sanitizeFileName(employeeName);
    final fileName = '${safeName}_${now.millisecondsSinceEpoch}.pdf';
    final bytes = await doc.save();

    // Keep a private copy for upload. Public Downloads on Android is created
    // via MediaStore and often does not provide a filesystem path usable by Dio.
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    if (Platform.isAndroid) {
      // Best-effort export to public Downloads so user can see it.
      await PublicDownloadsExporter.savePdfToPublicDownloads(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
      );
    }
    return file;
  }

  String _sanitizeFileName(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return cleaned.isEmpty ? 'employee_verification' : cleaned;
  }
}
