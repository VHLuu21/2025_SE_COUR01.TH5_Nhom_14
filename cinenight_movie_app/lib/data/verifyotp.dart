
import 'dart:math';

import 'package:cinenight_movie_app/data/db_service.dart';

class Verifyotp {
  // Hàm kiểm tra mail
  Future<String?> getUserIdByEmail(String email) async{
    final con = await DbService.connect();
    var result = await con.execute("SELECT id FROM users WHERE email = :email", {"email": email});
    if (result.rows.isNotEmpty) {
      return result.rows.first.colByName("id");
    }
    return null;
  }

  // Sinh otp code tự động
  String generateOtp(){
    final rand = Random();
    return (10000+ rand.nextInt(90000)).toString();
  }

  // Lưu Otp vào Db
  Future<void> saveOtp(int userId, String otp) async {
    final con = await DbService.connect();
    await con.execute("DELETE FROM verify WHERE user_id = :id", {"id": userId});
    await con.execute(
      "INSERT INTO verify (user_id, otp, created_at) VALUES (:id, :otp, NOW())",
      {"id": userId, "otp": otp}
    );
  }

  // Kiểm tra Otp
  Future<bool> verifyOtp(int userId, String otp) async{
    final con = await DbService.connect();
    var result = await con.execute(
      """
      SELECT * FROM verify 
      WHERE user_id = :id AND otp = :otp
      AND TIMESTAMPDIFF(MINUTE, created_at, NOW()) < 2
      """, {"id": userId, "otp": otp}
    );

    if(result.rows.isNotEmpty){
      await con.execute(
        "DELETE FROM verify WHERE user_id = :id", {"id": userId}
      );
      return true;
    }
    return false;
  }

  // Cập nhật mật khẩu 
  Future<void> updatePassword(String userId, String newPassword) async{
    final con = await DbService.connect();
    await con.execute(
      "UPDATE users SET password = :password WHERE id = :id",
      {"password": newPassword, "id": userId}
    );
  }
}