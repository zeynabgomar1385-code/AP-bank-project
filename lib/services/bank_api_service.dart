import 'dart:convert';
import 'dart:io';

class BankApiService {
  final String host;
  final int port;

  BankApiService({
    this.host = '127.0.0.1',
    this.port = 4040,
  });

  Future<Map<String, dynamic>> _send(Map<String, dynamic> body) async {
    final socket = await Socket.connect(host, port);

    final jsonString = jsonEncode(body);
    socket.write('$jsonString\n');

    final responseLine = await socket
        .map((event) => utf8.decode(event))
        .transform(const LineSplitter())
        .first;

    await socket.close();

    return jsonDecode(responseLine) as Map<String, dynamic>;
  }

  Future<bool> ping() async {
    final res = await _send({
      'action': 'PING',
    });
    return res['status'] == 'ok';
  }

  Future<bool> login(String username, String password) async {
    final res = await _send({
      'action': 'LOGIN',
      'username': username,
      'password': password,
    });
    return res['status'] == 'ok';
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final res = await _send({
      'action': 'GET_ACCOUNTS',
    });

    if (res['status'] != 'ok') {
      throw Exception('Failed to load accounts');
    }

    final List<dynamic> list = res['accounts'] as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }
}