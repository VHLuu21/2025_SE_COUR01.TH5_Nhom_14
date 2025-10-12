import 'package:cinenight_movie_app/data/db_service.dart';

class WishlistService {
  // Thêm phim vào wishlist
  static Future<void> addToWishlist(int userId, int movieId) async {
    final con = await DbService.connect();
    await con.execute(
      "INSERT INTO wishlists (user_id, movie_id, create_at) "
      "VALUES (:userId, :movieId, CURRENT_TIMESTAMP) "
      "ON DUPLICATE KEY UPDATE create_at = CURRENT_TIMESTAMP",
      {"userId": userId, "movieId": movieId},
    );
    await con.close();
  }

  // Xóa phim khỏi wishlist
  static Future<void> removeFromWishlist(int userId, int movieId) async {
    final con = await DbService.connect();
    await con.execute(
      "DELETE FROM wishlists WHERE user_id = :userId AND movie_id = :movieId",
      {"userId": userId, "movieId": movieId},
    );
    await con.close();
  }

  // Lấy danh sách wishlist của user
  static Future<List<int>> getWishlist(int userId) async {
    final con = await DbService.connect();
    final result = await con.execute(
      "SELECT movie_id FROM wishlists WHERE user_id = :userId",
      {"userId": userId},
    );
    await con.close();

    return result.rows
        .map((row) => int.parse(row.colByName("movie_id")!))
        .toList();
  }
}
