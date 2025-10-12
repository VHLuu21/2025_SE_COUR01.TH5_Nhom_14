import 'package:cinenight_movie_app/data/db_service.dart';

class FavoriteService {
  //Thêm phim vào favorite
  static Future<void> addToFavorite(int userId, int movieId) async {
    final con = await DbService.connect();
    await con.execute(
      "INSERT INTO favorites (user_id, movie_id, create_at) "
      "VALUES (:userId, :movieId, CURRENT_TIMESTAMP) "
      "ON DUPLICATE KEY UPDATE create_at = CURRENT_TIMESTAMP",
      {"userId": userId, "movieId": movieId},
    );
    await con.close();
  }

  //Xóa phim khỏi favorite
  static Future<void> removeFromFavorite(int userId, int movieId) async {
    final con = await DbService.connect();
    await con.execute(
      "DELETE FROM favorites WHERE user_id = :userId AND movie_id = :movieId",
      {"userId": userId, "movieId": movieId},
    );
    await con.close();
  }

  //Lấy danh sách favorite của user
  static Future<List<int>> getFavorite(int userId) async {
    final con = await DbService.connect();
    final result = await con.execute(
      "SELECT movie_id FROM favorites WHERE user_id = :userId",
      {"userId": userId},
    );
    await con.close();
    return result.rows
        .map((row) => int.parse(row.colByName("movie_id")!))
        .toList();
  }
}
