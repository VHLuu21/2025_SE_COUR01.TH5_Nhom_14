import 'package:mysql_client/mysql_client.dart';

class DbService {
  static Future<MySQLConnection> connect() async {
    final con = await MySQLConnection.createConnection(
      host: "cinenight-db-2025-cinenight25.e.aivencloud.com",
      port: 13121,
      userName: "avnadmin",
      password: "AVNS_a7b4r3jvOtYT7Mp-Ccl",
      databaseName: "defaultdb",
      secure: true,
    );
    await con.connect();
    return con;
  }
}
