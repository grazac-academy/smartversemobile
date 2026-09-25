import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../feautures/dashboard/data/models/calculation_result.dart';

class CalculationPdfService {
  static const _navy = PdfColor.fromInt(0xff0B1A33);
  static const _grey = PdfColor.fromInt(0xff8A8A8A);
  static const _tile = PdfColor.fromInt(0xffEAEFF5);
  static const _orange = PdfColor.fromInt(0xffE87A2D);
  static const _orangeSoft = PdfColor.fromInt(0xffFDF2EA);

  Future<Uint8List> build(CalculationResult result, {DateTime? date}) async {
    final when = date ?? DateTime.now();
    final rec = result.recommendation;
    final voltage = rec.battery.systemVoltage?.toString() ?? '-';
    final panelWatts = rec.solar.panelWatts?.toString() ?? '-';
    final hasSolar = rec.solar.panelCount > 0;

    final doc = pw.Document(title: 'SmartVert Report', author: 'SmartVert');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (_) => pw.Center(
          child: pw.Text(
            'Calculations based on industry standards | smartvert.ng',
            style: const pw.TextStyle(fontSize: 9, color: _grey),
          ),
        ),
        build: (_) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('SmartVert',
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: _orange)),
              pw.Text(_formatDate(when), style: const pw.TextStyle(fontSize: 11, color: _grey)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text('Power System Recommendation',
              style: const pw.TextStyle(fontSize: 12, color: _grey)),
          pw.SizedBox(height: 6),
          pw.Divider(color: _orange, thickness: 2),
          pw.SizedBox(height: 12),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(color: _navy, borderRadius: pw.BorderRadius.circular(10)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Recommended inverter',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.white)),
                pw.SizedBox(height: 4),
                pw.Text('${rec.inverterKva.toInt()} kVA',
                    style: pw.TextStyle(
                        fontSize: 26, fontWeight: pw.FontWeight.bold, color: _orange)),
              ],
            ),
          ),

          pw.SizedBox(height: 14),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _statTile('Battery', '${rec.battery.capacityAh}Ah/${voltage}V'),
              pw.SizedBox(width: 10),
              _statTile('Solar', hasSolar ? '${rec.solar.panelCount} panels' : '-'),
              pw.SizedBox(width: 10),
              _statTile('Daily energy',
                  '${(result.summary.dailyEnergyWh / 1000).toStringAsFixed(1)} kWh'),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _statTile('Running load', '${result.summary.totalRunningLoadWatts} W'),
              pw.SizedBox(width: 10),
              _statTile('Peak load', '${result.summary.peakLoadWatts} W'),
              pw.SizedBox(width: 10),
              pw.Expanded(child: pw.SizedBox()),
            ],
          ),
          pw.SizedBox(height: 18),

          pw.Text('Appliances',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _navy)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Appliance', 'Qty', 'Watts', 'Hours/day', 'Daily Wh'],
            data: [
              for (final b in result.breakdown)
                [
                  b.applianceName,
                  '${b.quantity}',
                  '${b.wattage}',
                  '${b.hoursPerDay}',
                  b.dailyEnergyWh.toStringAsFixed(0),
                ],
            ],
            headerStyle: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: _navy),
            cellStyle: const pw.TextStyle(fontSize: 10, color: _navy),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            oddRowDecoration: const pw.BoxDecoration(color: _tile),
          ),
          pw.SizedBox(height: 18),

          // No borderRadius here: pdf doesn't allow it with a one-sided border
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: const pw.BoxDecoration(
              color: _orangeSoft,
              border: pw.Border(left: pw.BorderSide(color: _orange, width: 3)),
            ),
            child: pw.Text(
              'Based on the appliances you selected, we recommend a '
                  '${rec.inverterKva.toStringAsFixed(0)} kVA inverter, '
                  'a ${rec.battery.capacityAh}Ah/${voltage}V battery bank, '
                  '${hasSolar ? 'and ${rec.solar.panelCount} x ${panelWatts}W solar panels' : 'and no solar panels needed (backup-only mode)'}.',
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 3, color: _navy),
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _statTile(String title, String value) => pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(color: _tile, borderRadius: pw.BorderRadius.circular(8)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 9, color: _grey)),
          pw.SizedBox(height: 3),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 12, fontWeight: pw.FontWeight.bold, color: _navy)),
        ],
      ),
    ),
  );

  String _formatDate(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }
}