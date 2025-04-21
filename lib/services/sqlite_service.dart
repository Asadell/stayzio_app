import 'package:sqflite/sqflite.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/features/booking/data/model/payment_card.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel_facility.dart';
import 'package:stayzio_app/features/message/data/model/message.dart';
import 'package:path/path.dart';

class SqliteService {
  static const String _databaseName = 'stayzio1.db';
  static const int _version = 1;

  // Table names
  static const String _tableUser = 'user';
  static const String _tableHotel = 'hotel';
  static const String _tableHotelFacility = 'hotel_facility';
  static const String _tableBooking = 'booking';
  static const String _tableMessage = 'message';
  static const String _tablePaymentCard = 'payment_card';
  static const String _tablePromo = 'promo';

  // Singleton pattern
  static final SqliteService _instance = SqliteService._internal();
  factory SqliteService() => _instance;
  SqliteService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDb();
    return _database!;
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
        await _insertDummyData(database);
      },
    );
  }

  Future<void> createTables(Database database) async {
    await database.execute('''
    CREATE TABLE metadata (
      key TEXT PRIMARY KEY,
      value TEXT
    )
  ''');
    // User table
    await database.execute("""
      CREATE TABLE $_tableUser(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        fullName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phoneNumber TEXT,
        username TEXT UNIQUE,
        profileImage TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
        pricePerNight REAL NOT NULL,
        rating REAL,
        imageUrl TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    """);

    // Hotel Facility table
    await database.execute("""
      CREATE TABLE $_tableHotelFacility(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        hotelId INTEGER NOT NULL,
        facilityName TEXT NOT NULL,
        facilityIcon TEXT,
        FOREIGN KEY (hotelId) REFERENCES $_tableHotel(id) ON DELETE CASCADE
      )
    """);

    // Booking table
    await database.execute("""
      CREATE TABLE $_tableBooking(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        userId INTEGER NOT NULL,
        hotelId INTEGER NOT NULL,
        checkInDate TEXT NOT NULL,
        checkOutDate TEXT NOT NULL,
        guests INTEGER NOT NULL,
        roomType TEXT,
        totalPrice REAL NOT NULL,
        cleaningFee REAL,
        serviceFee REAL,
        adminFee REAL,
        status TEXT NOT NULL,
        paymentMethodId INTEGER,
        promoCode TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES $_tableUser(id) ON DELETE CASCADE,
        FOREIGN KEY (hotelId) REFERENCES $_tableHotel(id) ON DELETE CASCADE,
        FOREIGN KEY (paymentMethodId) REFERENCES $_tablePaymentCard(id)
      )
    """);

    // Message table
    await database.execute("""
      CREATE TABLE $_tableMessage(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        senderId INTEGER NOT NULL,
        receiverId INTEGER NOT NULL,
        messageText TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        sentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (senderId) REFERENCES $_tableUser(id) ON DELETE CASCADE,
        FOREIGN KEY (receiverId) REFERENCES $_tableUser(id) ON DELETE CASCADE
      )
    """);

    // Payment Card table
    await database.execute("""
      CREATE TABLE $_tablePaymentCard(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        userId INTEGER NOT NULL,
        cardNumber TEXT NOT NULL,
        cardHolderName TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        cvv TEXT,
        cardType TEXT NOT NULL,
        isDefault INTEGER DEFAULT 0,
        currentBalance REAL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES $_tableUser(id) ON DELETE CASCADE
      )
    """);

    // Promo table
    await database.execute("""
      CREATE TABLE $_tablePromo(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        description TEXT,
        discountPercentage INTEGER,
        cashbackPercentage INTEGER,
        validUntil TEXT,
        isActive INTEGER DEFAULT 1
      )
    """);
  }

  // USER CRUD OPERATIONS
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(_tableUser, user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      _tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(_tableUser);
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      _tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // HOTEL CRUD OPERATIONS
  Future<int> insertHotel(Hotel hotel) async {
    final db = await database;
    return await db.insert(_tableHotel, hotel.toMap());
  }

  Future<List<Hotel>> getAllHotels() async {
    final db = await database;
    final hotelMaps = await db.query(_tableHotel);

    return Future.wait(hotelMaps.map((hotelMap) async {
      final hotelId = hotelMap['id'] as int;
      final facilityMaps = await db.query(
        _tableHotelFacility,
        where: 'hotelId = ?',
        whereArgs: [hotelId],
      );

      final facilities = facilityMaps.map((facilityMap) {
        return HotelFacility.fromMap(facilityMap);
      }).toList();

      // Add facilities to the hotel map before creating the Hotel object
      final completeHotelMap = Map<String, dynamic>.from(hotelMap);
      completeHotelMap['facilities'] = facilities;

      return Hotel.fromMap(completeHotelMap);
    }).toList());
  }

  Future<List<Hotel>> getTop3HotelsByRating() async {
    final db = await database;

    final hotelMaps = await db.query(
      _tableHotel,
      orderBy: 'rating DESC, datetime(createdAt) DESC',
      limit: 3,
    );

    return Future.wait(hotelMaps.map((hotelMap) async {
      final hotelId = hotelMap['id'] as int;

      final facilityMaps = await db.query(
        _tableHotelFacility,
        where: 'hotelId = ?',
        whereArgs: [hotelId],
      );

      final facilities = facilityMaps.map((facilityMap) {
        return HotelFacility.fromMap(facilityMap);
      }).toList();

      final completeHotelMap = Map<String, dynamic>.from(hotelMap);
      completeHotelMap['facilities'] = facilities;

      return Hotel.fromMap(completeHotelMap);
    }).toList());
  }

  Future<Hotel?> getHotelById(int id) async {
    final db = await database;
    final hotelMaps = await db.query(
      _tableHotel,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (hotelMaps.isEmpty) return null;

    final facilityMaps = await db.query(
      _tableHotelFacility,
      where: 'hotelId = ?',
      whereArgs: [id],
    );

    final facilities = facilityMaps.map((facilityMap) {
      return HotelFacility.fromMap(facilityMap);
    }).toList();

    // Add facilities to the hotel map before creating the Hotel object
    final completeHotelMap = Map<String, dynamic>.from(hotelMaps.first);
    completeHotelMap['facilities'] = facilities;

    return Hotel.fromMap(completeHotelMap);
  }

  // HOTEL FACILITY OPERATIONS
  Future<int> insertHotelFacility(HotelFacility facility) async {
    final db = await database;
    return await db.insert(_tableHotelFacility, facility.toMap());
  }

  Future<List<HotelFacility>> getFacilitiesByHotelId(int hotelId) async {
    final db = await database;
    final maps = await db.query(
      _tableHotelFacility,
      where: 'hotelId = ?',
      whereArgs: [hotelId],
    );

    return List.generate(maps.length, (i) => HotelFacility.fromMap(maps[i]));
  }

  // BOOKING CRUD OPERATIONS
  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert(_tableBooking, booking.toMap());
  }

  Future<List<Booking>> getBookingsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      _tableBooking,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) => Booking.fromMap(maps[i]));
  }

  Future<List<Booking>> getBookingsByUserIdAndStatus(
      int userId, List<String> statuses) async {
    final db = await database;
    final placeholders =
        List.generate(statuses.length, (index) => '?').join(',');
    final maps = await db.query(
      _tableBooking,
      where: 'userId = ? AND status IN ($placeholders)',
      whereArgs: [userId, ...statuses],
    );

    return List.generate(maps.length, (i) => Booking.fromMap(maps[i]));
  }

  Future<int> updateBookingStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      _tableBooking,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PAYMENT CARD CRUD OPERATIONS
  Future<int> insertPaymentCard(PaymentCard card) async {
    final db = await database;
    return await db.insert(_tablePaymentCard, card.toMap());
  }

  Future<List<PaymentCard>> getPaymentCardsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      _tablePaymentCard,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) => PaymentCard.fromMap(maps[i]));
  }

  Future<int> updatePaymentCardDefault(int userId, int cardId) async {
    final db = await database;
    await db.update(
      _tablePaymentCard,
      {'isDefault': 0},
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return await db.update(
      _tablePaymentCard,
      {'isDefault': 1},
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

  Future<int> deletePaymentCard(int id) async {
    final db = await database;
    return await db.delete(
      _tablePaymentCard,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // MESSAGE CRUD OPERATIONS
  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert(_tableMessage, message.toMap());
  }

  Future<List<Message>> getMessagesBetweenUsers(
      int user1Id, int user2Id) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT * FROM $_tableMessage 
      WHERE (senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)
      ORDER BY sentAt ASC
    ''', [user1Id, user2Id, user2Id, user1Id]);

    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  Future<int> updateMessageReadStatus(int messageId, int isRead) async {
    final db = await database;
    return await db.update(
      _tableMessage,
      {'isRead': isRead},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  Future<List<Map<String, dynamic>>> getConversationList(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        u.id as userId,
        u.fullName,
        u.profileImage,
        m.messageText as lastMessage,
        m.sentAt as lastMessageTime,
        COUNT(CASE WHEN m.isRead = 0 AND m.receiverId = ? THEN 1 END) as unreadCount
      FROM $_tableUser u
      JOIN $_tableMessage m ON (u.id = m.senderId OR u.id = m.receiverId)
      WHERE 
        (m.senderId = ? OR m.receiverId = ?) AND
        u.id != ? AND
        m.id IN (
          SELECT MAX(id) FROM $_tableMessage
          WHERE (senderId = ? AND receiverId = u.id) OR (senderId = u.id AND receiverId = ?)
          GROUP BY CASE WHEN senderId = ? THEN receiverId ELSE senderId END
        )
      GROUP BY u.id
      ORDER BY m.sentAt DESC
    ''', [userId, userId, userId, userId, userId, userId, userId]);

    return result;
  }

  // INSERT DUMMY DATA
  Future<void> _insertDummyData(Database db) async {
    // Insert dummy users
    final user1Id = await db.insert(_tableUser, {
      'fullName': 'Satrio Asadel',
      'email': 'del',
      'password': 'del',
      'phoneNumber': '+6281234567890',
      'username': 'johndoe',
      'profileImage': 'https://randomuser.me/api/portraits/men/1.jpg',
    });

    final user2Id = await db.insert(_tableUser, {
      'fullName': 'Jane Smith',
      'email': 'jane@example.com',
      'password': 'password456',
      'phoneNumber': '+6287654321098',
      'username': 'janesmith',
      'profileImage': 'https://randomuser.me/api/portraits/women/1.jpg',
    });

    // Insert dummy hotels
    final hotelIds = [];
    final hotelData = [
      // 5-Star International Chain Hotels
      {
        'name': 'JW Marriott Hotel Surabaya',
        'location': 'Embong Kaliasin, Surabaya',
        'latitude': -7.2651,
        'longitude': 112.7373,
        'description':
            'Luxurious 5-star hotel with elegant rooms, fine dining restaurants, and a relaxing spa in the heart of Surabaya.',
        'pricePerNight': 1500000.0,
        'rating': 4.8,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Sheraton Surabaya Hotel & Towers',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2756,
        'longitude': 112.6954,
        'description':
            'Modern hotel connected to Tunjungan Plaza shopping mall with spacious rooms and excellent city views.',
        'pricePerNight': 1200000.0,
        'rating': 4.6,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Hotel Majapahit Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2575,
        'longitude': 112.7413,
        'description':
            'Historic colonial-style hotel with beautiful gardens, vintage charm, and rich cultural heritage.',
        'pricePerNight': 1100000.0,
        'rating': 4.7,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Shangri-La Surabaya',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2768,
        'longitude': 112.7315,
        'description':
            'Luxurious hotel with premium amenities, multiple dining options, and elegant rooms in central Surabaya.',
        'pricePerNight': 1350000.0,
        'rating': 4.7,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Four Points by Sheraton Surabaya',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2768,
        'longitude': 112.7278,
        'description':
            'Business-friendly hotel with comfortable rooms, connected to Tunjungan Plaza 6 with easy access to shopping.',
        'pricePerNight': 890000.0,
        'rating': 4.5,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'DoubleTree by Hilton Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2613,
        'longitude': 112.7336,
        'description':
            'Modern hotel with warm service, comfortable beds, and famous chocolate chip cookies upon arrival.',
        'pricePerNight': 1050000.0,
        'rating': 4.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'Ciputra World Surabaya Hotel',
        'location': 'Wiyung, Surabaya',
        'latitude': -7.2902,
        'longitude': 112.6952,
        'description':
            'Contemporary hotel connected to Ciputra World Mall with modern amenities and spacious accommodations.',
        'pricePerNight': 950000.0,
        'rating': 4.5,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'Fairfield by Marriott Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2658,
        'longitude': 112.7452,
        'description':
            'Modern hotel offering a seamless stay with contemporary rooms and complimentary breakfast.',
        'pricePerNight': 850000.0,
        'rating': 4.4,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Wyndham Surabaya',
        'location': 'Sukomanunggal, Surabaya',
        'latitude': -7.2818,
        'longitude': 112.7122,
        'description':
            'Contemporary high-rise hotel with city views, upscale dining, and a rooftop infinity pool in West Surabaya.',
        'pricePerNight': 920000.0,
        'rating': 4.3,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },

      // 4-Star Hotels
      {
        'name': 'Vasa Hotel Surabaya',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2849,
        'longitude': 112.7586,
        'description':
            'Stylish hotel with contemporary design, rooftop pool, and excellent dining options in East Surabaya.',
        'pricePerNight': 850000.0,
        'rating': 4.4,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Oakwood Hotel & Residence Surabaya',
        'location': 'Tegalsari, Surabaya',
        'latitude': -7.2729,
        'longitude': 112.7318,
        'description':
            'Modern serviced apartments and hotel rooms with kitchenettes, perfect for short and extended stays.',
        'pricePerNight': 780000.0,
        'rating': 4.5,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Bumi Surabaya City Resort',
        'location': 'Tegalsari, Surabaya',
        'latitude': -7.2690,
        'longitude': 112.7354,
        'description':
            'Tropical resort-style hotel with lush gardens, open-air corridors, and traditional Indonesian architecture.',
        'pricePerNight': 870000.0,
        'rating': 4.4,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Novotel Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2665,
        'longitude': 112.7465,
        'description':
            'Family-friendly hotel with outdoor pool, fitness center, and a central location near Surabaya attractions.',
        'pricePerNight': 750000.0,
        'rating': 4.2,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Mercure Grand Mirama Surabaya',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2880,
        'longitude': 112.7495,
        'description':
            'Modern hotel with one of Surabaya\'s largest outdoor swimming pools and convenient access to shopping areas.',
        'pricePerNight': 680000.0,
        'rating': 4.1,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Swiss-Belinn Tunjungan Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2677,
        'longitude': 112.7385,
        'description':
            'Modern hotel in downtown Surabaya with comfortable rooms and easy access to business and shopping areas.',
        'pricePerNight': 620000.0,
        'rating': 4.0,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Hotel Santika Premiere Gubeng Surabaya',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2834,
        'longitude': 112.7499,
        'description':
            'Modern hotel with traditional Indonesian hospitality, spacious rooms, and excellent facilities.',
        'pricePerNight': 710000.0,
        'rating': 4.3,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Ascott Waterplace Surabaya',
        'location': 'Mulyorejo, Surabaya',
        'latitude': -7.2753,
        'longitude': 112.7834,
        'description':
            'Luxury serviced apartments with full kitchens, living areas, and hotel amenities in East Surabaya.',
        'pricePerNight': 950000.0,
        'rating': 4.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Aria Centra Hotel Surabaya',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2897,
        'longitude': 112.7537,
        'description':
            'Modern business hotel with comfortable rooms, meeting facilities, and convenient location.',
        'pricePerNight': 550000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'Ibis Styles Surabaya Jemursari',
        'location': 'Tenggilis Mejoyo, Surabaya',
        'latitude': -7.3204,
        'longitude': 112.7563,
        'description':
            'Colorful and modern hotel with a swimming pool and family-friendly amenities in South Surabaya.',
        'pricePerNight': 510000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Best Western Papilio Hotel',
        'location': 'Gayungan, Surabaya',
        'latitude': -7.3297,
        'longitude': 112.7344,
        'description':
            'Contemporary hotel with comfortable rooms, a swimming pool, and a convenient location near City of Tomorrow Mall.',
        'pricePerNight': 580000.0,
        'rating': 4.1,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Quest Hotel Darmo Surabaya',
        'location': 'Wonokromo, Surabaya',
        'latitude': -7.2936,
        'longitude': 112.7371,
        'description':
            'Modern hotel with comfortable rooms and excellent service in Darmo area, close to attractions.',
        'pricePerNight': 490000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Pesonna Hotel Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2558,
        'longitude': 112.7383,
        'description':
            'Modern hotel with a traditional Indonesian touch, offering comfortable rooms and good facilities.',
        'pricePerNight': 520000.0,
        'rating': 4.0,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Hotel Gunawangsa MERR',
        'location': 'Sukolilo, Surabaya',
        'latitude': -7.2991,
        'longitude': 112.7870,
        'description':
            'Modern hotel and apartments with city views, a swimming pool, and a gym in East Surabaya.',
        'pricePerNight': 470000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Favehotel Rungkut Surabaya',
        'location': 'Rungkut, Surabaya',
        'latitude': -7.3259,
        'longitude': 112.7674,
        'description':
            'Budget-friendly hotel with clean, comfortable rooms and friendly service in Rungkut industrial area.',
        'pricePerNight': 420000.0,
        'rating': 3.9,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },

      // 3-Star Hotels
      {
        'name': 'Amaris Hotel Margorejo',
        'location': 'Wonocolo, Surabaya',
        'latitude': -7.3138,
        'longitude': 112.7391,
        'description':
            'Affordable hotel with modern rooms, free WiFi, and a strategic location in South Surabaya.',
        'pricePerNight': 350000.0,
        'rating': 3.8,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Whiz Hotel Pemuda Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2607,
        'longitude': 112.7445,
        'description':
            'Budget hotel with clean rooms and strategic location in central Surabaya near shopping and attractions.',
        'pricePerNight': 330000.0,
        'rating': 3.7,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Bekizaar Hotel Surabaya',
        'location': 'Krembangan, Surabaya',
        'latitude': -7.2333,
        'longitude': 112.7312,
        'description':
            'Affordable hotel with modern rooms, located in the North Surabaya business district.',
        'pricePerNight': 340000.0,
        'rating': 3.8,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'MaxOne Hotel Tidar Surabaya',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2798,
        'longitude': 112.7170,
        'description':
            'Modern budget hotel with comfortable beds and good amenities in West Surabaya.',
        'pricePerNight': 320000.0,
        'rating': 3.7,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Zoom Hotel Dharmahusada',
        'location': 'Mulyorejo, Surabaya',
        'latitude': -7.2714,
        'longitude': 112.7763,
        'description':
            'Clean and comfortable budget hotel near hospitals and university campuses in East Surabaya.',
        'pricePerNight': 310000.0,
        'rating': 3.7,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Ibis Budget Surabaya Airport',
        'location': 'Asemrowo, Surabaya',
        'latitude': -7.2201,
        'longitude': 112.7172,
        'description':
            'Affordable hotel with essential amenities close to Juanda International Airport.',
        'pricePerNight': 300000.0,
        'rating': 3.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'POP! Hotel Diponegoro',
        'location': 'Tegalsari, Surabaya',
        'latitude': -7.2706,
        'longitude': 112.7298,
        'description':
            'Vibrant budget hotel with clean rooms, free WiFi, and a convenient central location.',
        'pricePerNight': 280000.0,
        'rating': 3.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Hotel 88 Embong Kenongo',
        'location': 'Embong Kaliasin, Surabaya',
        'latitude': -7.2671,
        'longitude': 112.7429,
        'description':
            'Budget hotel offering clean rooms and basic amenities in a convenient downtown location.',
        'pricePerNight': 270000.0,
        'rating': 3.5,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Zest Hotel Jemursari',
        'location': 'Tenggilis Mejoyo, Surabaya',
        'latitude': -7.3233,
        'longitude': 112.7560,
        'description':
            'Affordable hotel with bright rooms and a convenient location in South Surabaya.',
        'pricePerNight': 290000.0,
        'rating': 3.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Citihub Hotel Mayjend Sungkono',
        'location': 'Dukuh Pakis, Surabaya',
        'latitude': -7.2897,
        'longitude': 112.7085,
        'description':
            'Modern budget hotel with essential amenities and a strategic location in West Surabaya.',
        'pricePerNight': 260000.0,
        'rating': 3.5,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },

      // Budget Hotels and Hostels
      {
        'name': 'Capsule Homestay Surabaya',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2821,
        'longitude': 112.7511,
        'description':
            'Modern capsule hotel with affordable pod-style beds, shared facilities, and a social atmosphere.',
        'pricePerNight': 180000.0,
        'rating': 3.5,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Inlet Hostel Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2623,
        'longitude': 112.7400,
        'description':
            'Affordable hostel with dormitory and private rooms, common areas, and a friendly atmosphere.',
        'pricePerNight': 150000.0,
        'rating': 3.4,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'Krowi Inn',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2825,
        'longitude': 112.7463,
        'description':
            'Cozy hostel with dorm beds and private rooms, a communal kitchen, and a relaxing atmosphere.',
        'pricePerNight': 160000.0,
        'rating': 3.5,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Hotel Malibu Surabaya',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2796,
        'longitude': 112.7223,
        'description':
            'Budget hotel with clean rooms, air-conditioning, and a central location.',
        'pricePerNight': 220000.0,
        'rating': 3.3,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Hotel 95 Pontianak',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2583,
        'longitude': 112.7417,
        'description':
            'Budget accommodation with basic amenities and a convenient downtown location.',
        'pricePerNight': 210000.0,
        'rating': 3.2,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },

      // East Surabaya Hotels
      {
        'name': 'Grand Mercure Surabaya Manyar',
        'location': 'Sukolilo, Surabaya',
        'latitude': -7.2911,
        'longitude': 112.7755,
        'description':
            'Upscale hotel with modern rooms, a swimming pool, and excellent dining options in East Surabaya.',
        'pricePerNight': 900000.0,
        'rating': 4.5,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Hotel Santika Pandegiling Surabaya',
        'location': 'Tegalsari, Surabaya',
        'latitude': -7.2776,
        'longitude': 112.7310,
        'description':
            'Comfortable hotel with Indonesian hospitality, modern amenities, and a central location.',
        'pricePerNight': 650000.0,
        'rating': 4.2,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'Luminor Hotel Surabaya',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2778,
        'longitude': 112.7210,
        'description':
            'Modern hotel with comfortable rooms, a restaurant, and business facilities in Central Surabaya.',
        'pricePerNight': 600000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
      {
        'name': 'Elmi Hotel Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2589,
        'longitude': 112.7447,
        'description':
            'Long-established hotel with classic charm, comfortable rooms, and a central location.',
        'pricePerNight': 540000.0,
        'rating': 3.9,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Surabaya Suite Hotel',
        'location': 'Sawahan, Surabaya',
        'latitude': -7.2801,
        'longitude': 112.7253,
        'description':
            'Comfortable hotel with spacious rooms, a swimming pool, and good amenities in central Surabaya.',
        'pricePerNight': 610000.0,
        'rating': 4.1,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },

      // West Surabaya Hotels
      {
        'name': 'Verwood Hotel & Serviced Residence',
        'location': 'Sukomanunggal, Surabaya',
        'latitude': -7.2856,
        'longitude': 112.6921,
        'description':
            'Modern hotel and serviced apartments with stylish interiors and complete facilities in West Surabaya.',
        'pricePerNight': 750000.0,
        'rating': 4.3,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'The Alana Hotel & Convention Center',
        'location': 'Dukuh Pakis, Surabaya',
        'latitude': -7.2902,
        'longitude': 112.7031,
        'description':
            'Modern hotel with extensive meeting facilities, a swimming pool, and comfortable rooms.',
        'pricePerNight': 820000.0,
        'rating': 4.4,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Midtown Hotel Surabaya',
        'location': 'Dukuh Pakis, Surabaya',
        'latitude': -7.2903,
        'longitude': 112.7066,
        'description':
            'Contemporary hotel with comfortable rooms and good facilities in West Surabaya.',
        'pricePerNight': 500000.0,
        'rating': 4.0,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },
      {
        'name': 'V3 Hotel Surabaya',
        'location': 'Pakal, Surabaya',
        'latitude': -7.2453,
        'longitude': 112.6309,
        'description':
            'Modern hotel with comfortable rooms and basic amenities in northwest Surabaya.',
        'pricePerNight': 380000.0,
        'rating': 3.7,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },

      // South Surabaya Hotels
      {
        'name': 'Novotel Samator Surabaya Timur',
        'location': 'Mulyorejo, Surabaya',
        'latitude': -7.2989,
        'longitude': 112.7797,
        'description':
            'Modern hotel with spacious rooms, a swimming pool, and excellent facilities in East Surabaya.',
        'pricePerNight': 800000.0,
        'rating': 4.4,
        'imageUrl':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      },
      {
        'name': 'Fave Hotel Rungkut',
        'location': 'Rungkut, Surabaya',
        'latitude': -7.3266,
        'longitude': 112.7587,
        'description':
            'Affordable hotel with clean rooms and good service near Rungkut industrial area.',
        'pricePerNight': 390000.0,
        'rating': 3.8,
        'imageUrl': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
      },
      {
        'name': 'Ibis Surabaya City Center',
        'location': 'Tegalsari, Surabaya',
        'latitude': -7.2744,
        'longitude': 112.7403,
        'description':
            'Modern economy hotel with comfortable rooms and essential amenities in central Surabaya.',
        'pricePerNight': 480000.0,
        'rating': 3.9,
        'imageUrl':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      },
      {
        'name': 'Cleo Hotel Jemursari',
        'location': 'Tenggilis Mejoyo, Surabaya',
        'latitude': -7.3242,
        'longitude': 112.7544,
        'description':
            'Modern hotel with comfortable rooms and good facilities in South Surabaya.',
        'pricePerNight': 450000.0,
        'rating': 3.9,
        'imageUrl': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
      },
      {
        'name': 'Pop! Hotel Gubeng',
        'location': 'Gubeng, Surabaya',
        'latitude': -7.2801,
        'longitude': 112.7491,
        'description':
            'Colorful budget hotel with clean rooms and basic amenities in East Surabaya.',
        'pricePerNight': 285000.0,
        'rating': 3.6,
        'imageUrl':
            'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      },

      // North Surabaya Hotels
      {
        'name': 'Hotel Tunjungan Surabaya',
        'location': 'Genteng, Surabaya',
        'latitude': -7.2553,
        'longitude': 112.7375,
        'description':
            'Landmark hotel with a classic ambiance, comfortable rooms, and complete facilities in downtown Surabaya.',
        'pricePerNight': 700000.0,
        'rating': 4.2,
        'imageUrl':
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791',
      },
    ];

    for (var hotel in hotelData) {
      final hotelId = await db.insert(_tableHotel, hotel);
      hotelIds.add(hotelId);
    }

    // Insert hotel facilities
    final facilities = [
      'WiFi',
      'Swimming Pool',
      'Gym',
      'Spa',
      'Restaurant',
      'Bar',
      'Room Service',
      'Parking',
      'Airport Shuttle',
      'Laundry',
      'Meeting Rooms',
      'Breakfast',
      'Kids Club',
      'Beach Access'
    ];

    final facilityIcons = [
      'wifi',
      'pool',
      'fitness',
      'spa',
      'restaurant',
      'local_bar',
      'room_service',
      'local_parking',
      'airport_shuttle',
      'local_laundry_service',
      'meeting_room',
      'free_breakfast',
      'child_care',
      'beach_access'
    ];

    for (var hotelId in hotelIds) {
      // Add 3-5 random facilities for each hotel
      final facilityCount = 3 + (hotelId % 3); // 3, 4, or 5 facilities
      final shuffledIndexes = List.generate(facilities.length, (i) => i)
        ..shuffle();

      for (var i = 0; i < facilityCount; i++) {
        final idx = shuffledIndexes[i];
        await db.insert(_tableHotelFacility, {
          'hotelId': hotelId,
          'facilityName': facilities[idx],
          'facilityIcon': facilityIcons[idx],
        });
      }
    }

    // Insert payment cards
    final card1Id = await db.insert(_tablePaymentCard, {
      'userId': user1Id,
      'cardNumber': '4111111111111111',
      'cardHolderName': 'John Doe',
      'expiryDate': '12/25',
      'cvv': '123',
      'cardType': 'visa',
      'isDefault': 1,
      'currentBalance': 10000000.0,
    });

    final card2Id = await db.insert(_tablePaymentCard, {
      'userId': user2Id,
      'cardNumber': '5555555555554444',
      'cardHolderName': 'Jane Smith',
      'expiryDate': '10/26',
      'cvv': '456',
      'cardType': 'mastercard',
      'isDefault': 1,
      'currentBalance': 8500000.0,
    });

    // Insert second card for user1
    await db.insert(_tablePaymentCard, {
      'userId': user1Id,
      'cardNumber': '3782822463100005',
      'cardHolderName': 'John Doe',
      'expiryDate': '09/26',
      'cvv': '789',
      'cardType': 'amex',
      'isDefault': 0,
      'currentBalance': 15000000.0,
    });

    // Insert dummy bookings
    await db.insert(_tableBooking, {
      'userId': user1Id,
      'hotelId': hotelIds[0],
      'checkInDate': '2023-05-15',
      'checkOutDate': '2023-05-18',
      'guests': 2,
      'roomType': 'Deluxe',
      'totalPrice': 3600000.0,
      'cleaningFee': 150000.0,
      'serviceFee': 100000.0,
      'adminFee': 50000.0,
      'status': 'completed',
      'paymentMethodId': card1Id,
      'promoCode': null,
    });

    await db.insert(_tableBooking, {
      'userId': user1Id,
      'hotelId': hotelIds[2],
      'checkInDate': '2023-06-10',
      'checkOutDate': '2023-06-12',
      'guests': 1,
      'roomType': 'Standard',
      'totalPrice': 1900000.0,
      'cleaningFee': 100000.0,
      'serviceFee': 75000.0,
      'adminFee': 25000.0,
      'status': 'confirmed',
      'paymentMethodId': card1Id,
      'promoCode': 'SUMMER10',
    });

    await db.insert(_tableBooking, {
      'userId': user2Id,
      'hotelId': hotelIds[1],
      'checkInDate': '2023-07-20',
      'checkOutDate': '2023-07-25',
      'guests': 3,
      'roomType': 'Suite',
      'totalPrice': 9000000.0,
      'cleaningFee': 200000.0,
      'serviceFee': 150000.0,
      'adminFee': 75000.0,
      'status': 'confirmed',
      'paymentMethodId': card2Id,
      'promoCode': null,
    });

    await db.insert(_tableBooking, {
      'userId': user1Id,
      'hotelId': hotelIds[4],
      'checkInDate': '2023-08-01',
      'checkOutDate': '2023-08-03',
      'guests': 2,
      'roomType': 'Deluxe',
      'totalPrice': 1500000.0,
      'cleaningFee': 75000.0,
      'serviceFee': 50000.0,
      'adminFee': 25000.0,
      'status': 'pending',
      'paymentMethodId': null,
      'promoCode': null,
    });

    // Insert promo codes
    await db.insert(_tablePromo, {
      'code': 'SUMMER10',
      'description': 'Get 10% off on summer bookings',
      'discountPercentage': 10,
      'cashbackPercentage': null,
      'validUntil': '2023-08-31',
      'isActive': 1,
    });

    await db.insert(_tablePromo, {
      'code': 'NEWUSER20',
      'description': 'New user special - 20% off your first booking',
      'discountPercentage': 20,
      'cashbackPercentage': null,
      'validUntil': '2023-12-31',
      'isActive': 1,
    });

    await db.insert(_tablePromo, {
      'code': 'CASH5',
      'description': '5% cashback on your booking',
      'discountPercentage': null,
      'cashbackPercentage': 5,
      'validUntil': '2023-09-30',
      'isActive': 1,
    });

    // Insert messages between users
    await db.insert(_tableMessage, {
      'senderId': user1Id,
      'receiverId': user2Id,
      'messageText': 'Hi Jane, how are you?',
      'isRead': 1,
      'sentAt': '2023-04-15 10:30:00',
    });

    await db.insert(_tableMessage, {
      'senderId': user2Id,
      'receiverId': user1Id,
      'messageText': 'Hello John! I\'m good, thanks. How about you?',
      'isRead': 1,
      'sentAt': '2023-04-15 10:35:00',
    });

    await db.insert(_tableMessage, {
      'senderId': user1Id,
      'receiverId': user2Id,
      'messageText':
          'I\'m doing well! I was wondering if you had any hotel recommendations for Jakarta?',
      'isRead': 1,
      'sentAt': '2023-04-15 10:40:00',
    });

    await db.insert(_tableMessage, {
      'senderId': user2Id,
      'receiverId': user1Id,
      'messageText':
          'Yes, I recently stayed at Grand Hyatt and it was amazing! Great service and location.',
      'isRead': 1,
      'sentAt': '2023-04-15 10:45:00',
    });

    await db.insert(_tableMessage, {
      'senderId': user1Id,
      'receiverId': user2Id,
      'messageText':
          'That sounds perfect! I\'ll check it out. Thanks for the recommendation.',
      'isRead': 0,
      'sentAt': '2023-04-15 10:50:00',
    });
  }

  // Get full booking with hotel and payment details
  Future<Map<String, dynamic>?> getFullBookingById(int bookingId) async {
    final db = await database;
    final bookingMaps = await db.rawQuery('''
      SELECT 
        b.*,
        h.name as hotelName,
        h.location as hotelLocation,
        h.imageUrl as hotelImage,
        p.cardNumber as paymentCardNumber,
        p.cardType as paymentCardType
      FROM $_tableBooking b
      JOIN $_tableHotel h ON b.hotelId = h.id
      LEFT JOIN $_tablePaymentCard p ON b.paymentMethodId = p.id
      WHERE b.id = ?
    ''', [bookingId]);

    if (bookingMaps.isEmpty) return null;
    return bookingMaps.first;
  }

//   // Search hotels by name or location
//   Future<List<Hotel>> searchHotels(String query) async {
//     final db = await database;
//     final hotelMaps = await db.query(
//       _tableHotel,
//       where: 'name LIKE ? OR location LIKE ?',
//       whereArgs: ['%$query%', '%$query%'],
//     );

//     return Future.wait(hotelMaps.map((hotelMap) async {
//       final hotelId = hotelMap['id'] as int;
//       final facilities = await getFacilitiesByHotelId(hotelId);

//       // Add facilities to the hotel map before creating the Hotel object
//       final completeHotelMap = Map<String, dynamic>.from(hotelMap);
//       completeHotelMap['facilities'] = facilities;

//       return Hotel.fromMap(completeHotelMap);
//     }).toList());
//   }

//   // Filter hotels by price range
//   Future<List<Hotel>> filterHotelsByPriceRange(
//       double minPrice, double maxPrice) async {
//     final db = await database;
//     final hotelMaps = await db.query(
//       _tableHotel,
//       where: 'pricePerNight BETWEEN ? AND ?',
//       whereArgs: [minPrice, maxPrice],
//     );

//     return Future.wait(hotelMaps.map((hotelMap) async {
//       final hotelId = hotelMap['id'] as int;
//       final facilities = await getFacilitiesByHotelId(hotelId);

//       // Add facilities to the hotel map before creating the Hotel object
//       final completeHotelMap = Map<String, dynamic>.from(hotelMap);
//       completeHotelMap['facilities'] = facilities;

//       return Hotel.fromMap(completeHotelMap);
//     }).toList());
//   }

// // Filter hotels by rating
//   Future<List<Hotel>> filterHotelsByRating(double minRating) async {
//     final db = await database;
//     final hotelMaps = await db.query(
//       _tableHotel,
//       where: 'rating >= ?',
//       whereArgs: [minRating],
//     );

//     return Future.wait(hotelMaps.map((hotelMap) async {
//       final hotelId = hotelMap['id'] as int;
//       final facilities = await getFacilitiesByHotelId(hotelId);

//       // Add facilities to the hotel map before creating the Hotel object
//       final completeHotelMap = Map<String, dynamic>.from(hotelMap);
//       completeHotelMap['facilities'] = facilities;

//       return Hotel.fromMap(completeHotelMap);
//     }).toList());
//   }

// // Filter hotels by facilities
//   Future<List<Hotel>> filterHotelsByFacility(String facilityName) async {
//     final db = await database;
//     final hotelMaps = await db.rawQuery('''
//     SELECT h.* FROM $_tableHotel h
//     JOIN $_tableHotelFacility f ON h.id = f.hotelId
//     WHERE f.facilityName = ?
//     GROUP BY h.id
//   ''', [facilityName]);

//     return Future.wait(hotelMaps.map((hotelMap) async {
//       final hotelId = hotelMap['id'] as int;
//       final facilities = await getFacilitiesByHotelId(hotelId);

//       // Add facilities to the hotel map before creating the Hotel object
//       final completeHotelMap = Map<String, dynamic>.from(hotelMap);
//       completeHotelMap['facilities'] = facilities;

//       return Hotel.fromMap(completeHotelMap);
//     }).toList());
//   }

// // Check if a promo code is valid
//   Future<Map<String, dynamic>?> validatePromoCode(String code) async {
//     final db = await database;
//     final promoMaps = await db.query(
//       _tablePromo,
//       where:
//           'code = ? AND isActive = 1 AND (validUntil IS NULL OR validUntil >= date("now"))',
//       whereArgs: [code],
//     );

//     if (promoMaps.isEmpty) return null;
//     return promoMaps.first;
//   }

// // Get hotels by location
//   Future<List<Hotel>> getHotelsByLocation(String location) async {
//     final db = await database;
//     final hotelMaps = await db.query(
//       _tableHotel,
//       where: 'location LIKE ?',
//       whereArgs: ['%$location%'],
//     );

//     return Future.wait(hotelMaps.map((hotelMap) async {
//       final hotelId = hotelMap['id'] as int;
//       final facilities = await getFacilitiesByHotelId(hotelId);

//       // Add facilities to the hotel map before creating the Hotel object
//       final completeHotelMap = Map<String, dynamic>.from(hotelMap);
//       completeHotelMap['facilities'] = facilities;

//       return Hotel.fromMap(completeHotelMap);
//     }).toList());
//   }

// // Get unread message count for a user
//   Future<int> getUnreadMessageCount(int userId) async {
//     final db = await database;
//     final result = await db.rawQuery('''
//     SELECT COUNT(*) as count FROM $_tableMessage
//     WHERE receiverId = ? AND isRead = 0
//   ''', [userId]);

//     return Sqflite.firstIntValue(result) ?? 0;
//   }

// Close database connection
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

Future<void> deleteLocalDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'stayzio.db');

  // Hapus file database
  await deleteDatabase(path);
  print('Database deleted successfully.');
}
