import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'stayzio.db';
  static const int _version = 1;

  // Table names
  static const String _tableUser = 'user';
  static const String _tableHotel = 'hotel';
  static const String _tableHotelFacility = 'hotel_facility';
  static const String _tableBooking = 'booking';
  static const String _tableMessage = 'message';
  static const String _tablePaymentCard = 'payment_card';
  static const String _tablePromo = 'promo';

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<void> createTables(Database database) async {
    // User table
    await database.execute("""
      CREATE TABLE $_tableUser(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone_number TEXT,
        username TEXT UNIQUE,
        profile_image TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    """);

    // Hotel table
    await database.execute("""
      CREATE TABLE $_tableHotel(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        description TEXT,
        price_per_night REAL NOT NULL,
        rating REAL,
        image_url TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    """);

    // Hotel Facility table
    await database.execute("""
      CREATE TABLE $_tableHotelFacility(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        hotel_id INTEGER NOT NULL,
        facility_name TEXT NOT NULL,
        facility_icon TEXT,
        FOREIGN KEY (hotel_id) REFERENCES $_tableHotel(id) ON DELETE CASCADE
      )
    """);

    // Booking table
    await database.execute("""
      CREATE TABLE $_tableBooking(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_id INTEGER NOT NULL,
        hotel_id INTEGER NOT NULL,
        check_in_date TEXT NOT NULL,
        check_out_date TEXT NOT NULL,
        guests INTEGER NOT NULL,
        room_type TEXT,
        total_price REAL NOT NULL,
        cleaning_fee REAL,
        service_fee REAL,
        admin_fee REAL,
        status TEXT NOT NULL,
        payment_method_id INTEGER,
        promo_code TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $_tableUser(id) ON DELETE CASCADE,
        FOREIGN KEY (hotel_id) REFERENCES $_tableHotel(id) ON DELETE CASCADE,
        FOREIGN KEY (payment_method_id) REFERENCES $_tablePaymentCard(id)
      )
    """);

    // Message table
    await database.execute("""
      CREATE TABLE $_tableMessage(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        sender_id INTEGER NOT NULL,
        receiver_id INTEGER NOT NULL,
        message_text TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (sender_id) REFERENCES $_tableUser(id) ON DELETE CASCADE,
        FOREIGN KEY (receiver_id) REFERENCES $_tableUser(id) ON DELETE CASCADE
      )
    """);

    // Payment Card table
    await database.execute("""
      CREATE TABLE $_tablePaymentCard(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_id INTEGER NOT NULL,
        card_number TEXT NOT NULL,
        card_holder_name TEXT NOT NULL,
        expiry_date TEXT NOT NULL,
        cvv TEXT,
        card_type TEXT NOT NULL,
        is_default INTEGER DEFAULT 0,
        current_balance REAL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $_tableUser(id) ON DELETE CASCADE
      )
    """);

    // Promo table
    await database.execute("""
      CREATE TABLE $_tablePromo(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        description TEXT,
        discount_percentage INTEGER,
        cashback_percentage INTEGER,
        valid_until TEXT,
        is_active INTEGER DEFAULT 1
      )
    """);
  }

  // Methods for CRUD operations

  // User operations
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await _initializeDb();
    return await db.insert(_tableUser, user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _initializeDb();
    final List<Map<String, dynamic>> result = await db.query(
      _tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Hotel operations
  Future<List<Map<String, dynamic>>> getAllHotels() async {
    final db = await _initializeDb();
    return await db.query(_tableHotel);
  }

  Future<Map<String, dynamic>?> getHotelById(int id) async {
    final db = await _initializeDb();
    final List<Map<String, dynamic>> result = await db.query(
      _tableHotel,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Booking operations
  Future<int> createBooking(Map<String, dynamic> booking) async {
    final db = await _initializeDb();
    return await db.insert(_tableBooking, booking);
  }

  Future<List<Map<String, dynamic>>> getUserBookings(int userId) async {
    final db = await _initializeDb();
    return await db.query(
      _tableBooking,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Message operations
  Future<int> sendMessage(Map<String, dynamic> message) async {
    final db = await _initializeDb();
    return await db.insert(_tableMessage, message);
  }

  Future<List<Map<String, dynamic>>> getConversation(
      int userId1, int userId2) async {
    final db = await _initializeDb();
    return await db.rawQuery('''
      SELECT * FROM $_tableMessage
      WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)
      ORDER BY sent_at ASC
    ''', [userId1, userId2, userId2, userId1]);
  }

  // Payment Card operations
  Future<int> addPaymentCard(Map<String, dynamic> card) async {
    final db = await _initializeDb();
    return await db.insert(_tablePaymentCard, card);
  }

  Future<List<Map<String, dynamic>>> getUserCards(int userId) async {
    final db = await _initializeDb();
    return await db.query(
      _tablePaymentCard,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
