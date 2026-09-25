import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/service/calculation_pdf_service.dart';
import '../../../dashboard/data/models/calculation_result.dart';



enum PdfExportStatus { idle, generating, generated, failure }

class PdfExportState {
  final PdfExportStatus status;
  final String? filePath;
  final String? message;

  const PdfExportState({this.status = PdfExportStatus.idle, this.filePath, this.message});

  bool get isBusy => status == PdfExportStatus.generating;
}

class PdfExportCubit extends Cubit<PdfExportState> {
  PdfExportCubit({CalculationPdfService? service})
      : _service = service ?? CalculationPdfService(),
        super(const PdfExportState());

  final CalculationPdfService _service;

  Future<void> downloadPdf(CalculationResult result) async {
    if (state.isBusy) return;

    emit(const PdfExportState(status: PdfExportStatus.generating));

    try {
      final bytes = await _service.build(result);
      final name = _fileName();

      final openFile = await _writeTemp(bytes, 'open', name);

      if (Platform.isAndroid) {

        final saveFile = await _writeTemp(bytes, 'save', name);
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = 'SmartVert';
        final info = await MediaStore().saveFile(
          tempFilePath: saveFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );
        if (info == null || !info.isSuccessful) {
          throw Exception('Could not save the PDF to Downloads');
        }
      } else {

        final docs = await getApplicationDocumentsDirectory();
        await openFile.copy('${docs.path}/$name');
      }

      emit(PdfExportState(
        status: PdfExportStatus.generated,
        filePath: openFile.path,
        message: 'PDF generated successfully',

      ));

      final opened = await OpenFilex.open(openFile.path, type: 'application/pdf');
      debugPrint('OpenFilex result: ${opened.type} - ${opened.message}');
      if (opened.type != ResultType.done) {
        emit(PdfExportState(
          status: PdfExportStatus.failure,
          message: 'PDF saved, but it could not be opened: ${opened.message}',
        ));
      }
    } catch (e, st) {
      debugPrint('PDF download failed: $e\n$st');
      emit(PdfExportState(status: PdfExportStatus.failure, message: _errorText('Could not generate PDF', e)));
    }
  }

  Future<void> sharePdf(CalculationResult result) async {
    if (state.isBusy) return;
    emit(const PdfExportState(status: PdfExportStatus.generating));

    try {
      final bytes = await _service.build(result);
      final file = await _writeTemp(bytes, 'share', _fileName());

      emit(const PdfExportState());
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          text: 'My SmartVert power recommendation',
        ),
      );
    } catch (e, st) {

      debugPrint('PDF share failed: $e\n$st');
      emit(PdfExportState(status: PdfExportStatus.failure, message: _errorText('Could not share PDF', e)));
    }
  }

  Future<File> _writeTemp(List<int> bytes, String subFolder, String name) async {
    final base = await getTemporaryDirectory();
    final dir = Directory('${base.path}/$subFolder');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  String _errorText(String prefix, Object e) =>
      kDebugMode ? '$prefix: $e' : '$prefix. Please try again.';

  String _fileName() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return 'SmartVert_Report_${n.year}-${two(n.month)}-${two(n.day)}_${two(n.hour)}${two(n.minute)}.pdf';
  }
}