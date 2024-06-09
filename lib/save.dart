import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
 
// ignore: camel_case_types
class savebook{
 
  static List<book> books =[];
  static final _random = Random();
  //  tạo chức năng thêm danh sách
  static Future<void> addbook(String name, String actor, String category, String companypublishing, 
  String daypublishing, String price,String description, String? imagepath, String imageName) async{
    final db = FirebaseFirestore.instance;
    final id = (_random.nextInt(100000+1)).toString();
    await db.collection('books').doc(id).set({
      'id': id,
      'name':name,
      'actor':actor,
      'category': category,
      'companypublishing':companypublishing,
      'daypublishing':daypublishing,
      'price': price,
      'description':description,
      'imagepath':imagepath,
      'imagename':imageName,
    });
    books = await getbook();
  }
    //  tạo chức năng sửa danh sách
  static Future<void> updateBook(String id, String newName,String newactor, String newCategory, String newcompanypublishing, 
  String newdaypublishing , String newprice ,String newdescription , String? newImagePath, String? newImageName) async {
    final db = FirebaseFirestore.instance;
    Map<String, dynamic> updateData = {
      'name': newName,
      'actor':newactor,
      'category': newCategory,
      'companypublishing':newcompanypublishing,
      'daypublishing':newdaypublishing,
      'price': newprice,
      'description':newdescription,
    };

    // Nếu có đường dẫn ảnh mới, cập nhật nó
    if (newImagePath != null) {
      updateData['imagepath'] = newImagePath;
    }

    // Nếu có tên ảnh mới, cập nhật nó
    if (newImageName != null) {
      updateData['imagename'] = newImageName;
    }

    await db.collection('books').doc(id).update(updateData);
  }
  //  tạo chức năng xóa danh sách
  static Future<void> deletedata(String id) async{
    final db = FirebaseFirestore.instance;
    await db.collection('books').doc(id).delete();
  }

  // khởi tạo danh sách dùng để xem và tìm kiếm
  static Future<List<book>> getbook() async{
    final db = FirebaseFirestore.instance;
    final results = await db.collection('books').get();
    // ignore: unnecessary_null_comparison
    if (results != null) {
      return results.docs.map((item) => book.fromMap(item.data())).toList();
    }else{
      return [];
    }
  }
}
// Tạo các lớp và các trường dữ liệu
// ignore: camel_case_types
class book {
  final String id;
  final String name;
  final String actor;
  final String category;
  final String companypublishing;
  final String daypublishing;
  final String price;
  final String description;
  final String? imagepath;
  final String? imagename;
  book({
    required this.id,
    required this.name,
    required this.actor,
    required this.category,
    required this.companypublishing,
    required this.daypublishing,
    required this.price,
    required this.description,
    this.imagepath,
    this.imagename,
  });

  factory book.fromMap(Map<String, dynamic> map) {
    return book(
      id: map['id'] as String,
      name: map['name'] as String,
      actor: map['actor'] as String,
      category: map['category'] as String,
      companypublishing: map['companypublishing'] as String,
      daypublishing: map['daypublishing'] as String,
      price: map['price'] as String,
      description: map['description'] as String,
      imagepath: map['imagepath'] != null ? map['imagepath'] as String : null,
      imagename: map['imagename'] != null ? map['imagename'] as String : null,
    );
  }
}
class Users {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> checkFirstTimeUser() async {
    // Kiểm tra xem người dùng hiện tại đã có trong bộ sưu tập 'users' hay chưa
    final userDoc = await firestore.collection('users').doc(auth.currentUser!.uid).get();
    if (!userDoc.exists) {
      // Nếu không, kiểm tra xem có bất kỳ người dùng nào khác đã đăng nhập trước đó hay không
      final users = await firestore.collection('users').get();
      if (users.docs.isEmpty) {
        // Nếu không, đặt người dùng hiện tại là admin và gán ID 0 cho họ
        await firestore.collection('users').doc(auth.currentUser!.uid).set({
          'role': 'admin',
          'id': 0, // Gán ID 0 cho người dùng
        });
      } else {
        // Nếu có, đặt người dùng hiện tại là user và gán ID cho họ dựa trên số lượng tài liệu hiện có
        int id = users.docs.length; // Số lượng tài liệu hiện có sẽ là ID của người dùng mới
        await firestore.collection('users').doc(auth.currentUser!.uid).set({
          'role': 'user',
          'id': id, // Gán ID cho người dùng
        });
      }
    }
    // Nếu người dùng hiện tại đã có trong bộ sưu tập 'users', không làm gì cả
  }
}
