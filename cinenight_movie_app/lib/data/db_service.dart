import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

class DbService {
  static Future<MySQLConnection> connect() async {
    final con = await MySQLConnection.createConnection(
      host: dotenv.env['DB_HOST'] ?? '',
      port: int.parse(dotenv.env['DB_PORT'] ?? '0'),
      userName: dotenv.env['DB_USER'] ?? '',
      password: dotenv.env['DB_PASSWORD'] ?? '',
      databaseName: dotenv.env['DB_NAME'] ?? '',
      secure: true,
    );
    await con.connect();
    return con;
  }
}
