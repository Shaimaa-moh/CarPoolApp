
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasev2 {
  Database? mydatabase;

  Future<Database?> checkdata() async {
    if (mydatabase == null) {
      mydatabase = await creating();
      return mydatabase;
    } else {
      return mydatabase;
    }
  }

  int Version = 2;
  creating() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'mynewdatafile2.db');
    Database mydb =
    await openDatabase(mypath, version: Version, onCreate: (db, version) {
      db.execute('''CREATE TABLE IF NOT EXISTS 'FILE1'(
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'UserName' TEXT NOT NULL,
      'Email' TEXT NOT NULL,
      'Phone' TEXT NOT NULL)''');
    });
    return mydb;
  }

  isexist() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'mynewdatafile2.db');
    await databaseExists(mypath) ? print("it exists") : print("not exist");
  }

  reading(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawQuery(sql);
    return myesponse;
  }

  write(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawInsert(sql);
    return myesponse;
  }

  update(sql) async {
    print("updating");
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawUpdate(sql);
    print("done update");
    return myesponse;
  }

  delete(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawDelete(sql);
    return myesponse;
  }

}