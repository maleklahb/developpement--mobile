
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,

      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            salt TEXT NOT NULL
          )
        ''');
      },

      // Mise à jour si la base version 1 existe déjà
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE users ADD COLUMN first_name TEXT NOT NULL DEFAULT ''",
          );

          await db.execute(
            "ALTER TABLE users ADD COLUMN last_name TEXT NOT NULL DEFAULT ''",
          );
        }
      },
    );
  }

  String _generateSalt() {
    final random = Random.secure();

    return List.generate(
      16,
      (_) => random.nextInt(256)
          .toRadixString(16)
          .padLeft(2, '0'),
    ).join();
  }

  String _hashPassword(String password, String salt) {
    return sha256
        .convert(utf8.encode('$salt$password'))
        .toString();
  }

  // INSCRIPTION
  Future<int> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final db = await database;

    final salt = _generateSalt();
    final passwordHash = _hashPassword(password, salt);

    return await db.insert('users', {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim().toLowerCase(),
      'password_hash': passwordHash,
      'salt': salt,
    });
  }

  // CONNEXION
  Future<bool> loginUser(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );

    if (result.isEmpty) return false;

    final user = result.first;

    final salt = user['salt'] as String;
    final storedHash = user['password_hash'] as String;

    final enteredHash = _hashPassword(password, salt);

    return enteredHash == storedHash;
  }
}
