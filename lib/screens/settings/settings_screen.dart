import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idg2recipes/providers/backup_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final file = await ref.read(backupActionsProvider.notifier).exportData();

      if (!context.mounted) return;

      // 모바일: 바로 공유 시트 표시
      if (Platform.isAndroid || Platform.isIOS) {
        final result = await Share.shareXFiles(
          [XFile(file.path)],
          subject: '레시피 백업',
        );

        if (!context.mounted) return;

        if (result.status == ShareResultStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('백업 파일이 공유되었습니다.')),
          );
        } else if (result.status == ShareResultStatus.dismissed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('공유가 취소되었습니다.')),
          );
        }
        return;
      }

      // Desktop: 다이얼로그로 저장 경로 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('내보내기 완료'),
          content: Text('백업 파일이 Downloads 폴더에 저장되었습니다.\n\n${file.path}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('내보내기 실패: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref, {required bool merge}) async {
    // 경고 다이얼로그
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(merge ? '데이터 병합' : '데이터 불러오기'),
        content: Text(
          merge
              ? '기존 데이터에 새로운 데이터를 추가합니다.\n중복된 항목은 건너뜁니다.'
              : '⚠️ 기존 데이터가 모두 삭제됩니다!\n계속하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: merge ? null : FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(merge ? '병합' : '불러오기'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    // 파일 선택
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);

    try {
      final importResult = await ref.read(backupActionsProvider.notifier)
          .importData(file, merge: merge);

      if (!context.mounted) return;

      // 결과 다이얼로그
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('불러오기 완료'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('레시피: ${importResult.recipesImported}개 추가됨'),
              Text('재료: ${importResult.ingredientsImported}개 추가됨'),
              if (importResult.recipesSkipped > 0)
                Text('레시피: ${importResult.recipesSkipped}개 건너뜀 (중복)'),
              if (importResult.ingredientsSkipped > 0)
                Text('재료: ${importResult.ingredientsSkipped}개 건너뜀 (중복)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('불러오기 실패'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Text('설정'),
          ],
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '데이터 관리',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('데이터 내보내기'),
            subtitle: const Text('레시피와 재료를 JSON 파일로 저장'),
            onTap: () => _exportData(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('데이터 불러오기 (덮어쓰기)'),
            subtitle: const Text('기존 데이터가 모두 삭제됩니다'),
            onTap: () => _importData(context, ref, merge: false),
          ),
          ListTile(
            leading: const Icon(Icons.merge),
            title: const Text('데이터 병합'),
            subtitle: const Text('기존 데이터에 새 데이터를 추가'),
            onTap: () => _importData(context, ref, merge: true),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '앱 정보',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('버전'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
