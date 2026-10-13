// Mengambil nilai FIREBASE_* untuk env/<flavor>.json dari google-services.json.
//
//   dart run tool/firebase_env.dart ~/Downloads/google-services.json [com.kubus.work.droid]
//
// File google-services.json sendiri tidak perlu dimasukkan ke project; cukup
// nilai yang dicetak di sini.
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'Pemakaian: dart run tool/firebase_env.dart <google-services.json> [package]',
    );
    exit(64);
  }
  final json = jsonDecode(File(args[0]).readAsStringSync()) as Map<String, dynamic>;
  final project = json['project_info'] as Map<String, dynamic>;
  final clients = (json['client'] as List).cast<Map<String, dynamic>>();
  final wanted = args.length > 1 ? args[1] : null;

  final client = clients.firstWhere(
    (c) {
      final info = c['client_info'] as Map<String, dynamic>;
      final pkg = (info['android_client_info'] as Map<String, dynamic>?)?['package_name'];
      return wanted == null || pkg == wanted;
    },
    orElse: () {
      stderr.writeln('Tidak ada app Android dengan package $wanted di file ini.');
      exit(1);
    },
  );
  final info = client['client_info'] as Map<String, dynamic>;
  final apiKey = ((client['api_key'] as List).first as Map<String, dynamic>)['current_key'];

  stdout.writeln(const JsonEncoder.withIndent('  ').convert({
    'FIREBASE_API_KEY': apiKey,
    'FIREBASE_APP_ID': info['mobilesdk_app_id'],
    'FIREBASE_SENDER_ID': project['project_number'],
    'FIREBASE_PROJECT_ID': project['project_id'],
  }));
}
