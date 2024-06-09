import 'package:flutter/material.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'save.dart';

// ignore: camel_case_types
class resgisterbook extends StatefulWidget {
  const resgisterbook({super.key});

  @override
  State<resgisterbook> createState() => _resgisterbookState();
}

// ignore: camel_case_types
class _resgisterbookState extends State<resgisterbook> {
   
  final _namect = TextEditingController();
  final _actct = TextEditingController();
  final _categoryct = TextEditingController();
  final _companypublishingct = TextEditingController();
  final _daypublishingct = TextEditingController();
  final _descriptionct = TextEditingController();
  final _pricect = TextEditingController();
  // ignore: non_constant_identifier_names
  String book_id = '';
  String ? _imagePath;
  late String _imageName;

  void reset(){
    _namect.clear();
    _actct.clear();
    _categoryct.clear();
    _companypublishingct.clear();
    _daypublishingct.clear();
      _descriptionct.clear();
    _pricect.clear();
   
  }
  void adds () async{
 
    try {
      await savebook.addbook(
        _namect.text, 
        _actct.text, 
        _categoryct.text, 
        _companypublishingct.text, 
        _daypublishingct.text, 
        _pricect.text,
        _descriptionct.text,
        _imagePath,
        _imageName,
      );
      final books = await savebook.getbook();
      book_id = books.last.id;

      // Hiển thị thông báo thành công
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm sách thành công!'), backgroundColor: Colors.green,)
      );

  
    } catch (e) {
      // Hiển thị thông báo lỗi
       // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Có lỗi xảy ra khi thêm sách.'),  backgroundColor: Colors.red)
      );
 
    }
  }
 

  Future<void> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final String fileName = image.path.split('/').last;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('books/$fileName');
    UploadTask uploadTask = ref.putFile(File(image.path));
    await uploadTask.whenComplete(() => null);
    String imageUrl = await ref.getDownloadURL(); // Lấy đường dẫn tải xuống
    setState(() {
      _imagePath = imageUrl; // Lưu đường dẫn tải xuống vào biến _imagePath
      _imageName = fileName; // Lưu tên file ảnh vào biến _imageName
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Đăng kí sách', style: TextStyle(color: Colors.red),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 1))
      ),
     ),
     actions: <Widget>[
      IconButton(onPressed: reset, icon: const Icon(Icons.refresh, size: 25,)),
      IconButton(onPressed: (){
            Navigator.push(context,
             (MaterialPageRoute(builder: (context)=>const TheList())));
          }, icon: const Icon(Icons.home, size: 30,))
     ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration:const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pic7.jpg'),
                  fit: BoxFit.cover
                  )
              ),
          ),
          Container(
            padding:const EdgeInsets.all(15),
            margin:const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(136, 0, 0, 0),
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                   const SizedBox(height: 20),
                    TextFormField(
                      controller: _namect,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập tên sách',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                         border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),

                    const SizedBox(height: 20),
                      TextFormField(
                      controller: _actct,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập tên tác giả',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                         border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),

                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      controller: _categoryct,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập thể loại',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      controller: _companypublishingct,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập nhà sản xuất',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      controller: _daypublishingct,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập ngày xuất bản',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                        TextFormField(
                      controller: _pricect,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập giá sách',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                        TextFormField(
                      controller: _descriptionct,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                        labelText: 'nhập mô tả sách',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                      ),
                    ),
                   const SizedBox(height: 20),
                    ElevatedButton  (onPressed: pickImage, 
                    // ignore: sort_child_properties_last
                    child:  Text (_imagePath == null ? 'chọn ảnh':'ảnh đã chọn', style: const TextStyle(color: Color.fromARGB(255, 255, 254, 254)),),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      side: MaterialStatePropertyAll(BorderSide(color: Colors.white))
                    ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: adds,
                           style:const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.black),
                          side: MaterialStatePropertyAll(BorderSide(color: Colors.white))
                          ),
                        
                        child:const Text('Đăng Kí', style: TextStyle(color:Colors.red),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class BookUpdatePage extends StatefulWidget {
  final String bookId; // ID của sách cần cập nhật

  const BookUpdatePage({Key? key, required this.bookId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookUpdatePageState createState() => _BookUpdatePageState();
}

class _BookUpdatePageState extends State<BookUpdatePage> {
   
  final _namect = TextEditingController();
  final _actct = TextEditingController();
  final _categoryct = TextEditingController();
  final _companypublishingct = TextEditingController();
  final _daypublishingct = TextEditingController();
  final _descriptionct = TextEditingController();
  final _pricect = TextEditingController();
 
  String? _imagePath;
  String? _imageName;

  @override
  void dispose() {
    _namect.dispose();
    _actct.dispose();
    _categoryct.dispose();
    _companypublishingct.dispose();
    _daypublishingct.dispose();
    _descriptionct.dispose();
    _pricect.dispose();

    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
        _imageName = image.name;
      });
    }
  }

 Future<void> updateBookInfo() async {
  String? imageUrl;
  if (_imagePath != null) {
    final File imageFile = File(_imagePath!);
    final String fileName = _imageName ?? 'book_image_${widget.bookId}';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('books/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    imageUrl = await ref.getDownloadURL();
  }

  try {
    // Gọi phương thức updateBook từ lớp savedata
    await savebook.updateBook(
      widget.bookId,
      _namect.text,
      _actct.text,
      _categoryct.text,
      _companypublishingct.text,
      _daypublishingct.text,
      _pricect.text,
      _descriptionct.text,
      imageUrl,
      _imageName
    );

    // Hiển thị thông báo cập nhật thành công
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thành công'), backgroundColor: Colors.green,));
  } catch (e) {
    // Hiển thị thông báo sửa không thành công
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật không thành công: $e'), backgroundColor: Colors.red,));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Cập nhật thông tin sách', style: TextStyle(color: Color.fromARGB(255, 245, 126, 47)),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color.fromARGB(255, 247, 83, 18), width: 1))
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,
             (MaterialPageRoute(builder: (context)=>const TheList())));
          }, icon: const Icon(Icons.home, size: 30,))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
             decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pic6.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          Container(
            padding:const EdgeInsets.all(15),
            margin:const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(15)
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                const SizedBox(height: 15,),
                  TextField(
                    controller: _namect,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Cập Nhật Tên sách',
                       labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                    const SizedBox(height: 20,),
                  TextField(
                    controller: _actct,
                    style:const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Cập Nhật tác giả',
                       labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),

                      ),
                     ),
                    const SizedBox(height: 20,),
                    TextField(
                    controller: _categoryct,
                    style:const TextStyle(color: Colors.white),
                    decoration:const InputDecoration(labelText: 'Cập Nhật thể loại',
                     labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                   const  SizedBox(height: 20,),
                  TextField(
                    controller: _companypublishingct,
                    style:const TextStyle(color: Colors.white),
                    decoration:const InputDecoration(labelText: 'Cập Nhật nhà xuất bản',
                     labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                    const SizedBox(height: 20,),
                    TextField(
                    controller: _daypublishingct,
                    style:const TextStyle(color: Colors.white),
                    decoration:const InputDecoration(labelText: 'Cập Nhật năm suất bản',
                     labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                  ),
                    const SizedBox(height: 20,),
                  TextField(
                    controller: _pricect,
                    style:const TextStyle(color: Colors.white),
                    decoration:const InputDecoration(labelText: 'Cập Nhật giá',
                     labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),),
                  ),
                    const SizedBox(height: 20,),
                    TextField(
                    controller: _descriptionct,
                    style:const TextStyle(color: Colors.white),
                    decoration:const InputDecoration(labelText: 'Cập Nhật mô tả',
                     labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),),
                  ),
                  const SizedBox(height: 20),
                  _imagePath != null
                      ? Image.file(File(_imagePath!), height: 100)
                      : const Text('Chưa chọn ảnh', style: TextStyle(color: Colors.white),),
                 const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      side: MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 2))
                    ),
                    child: const Text('Chọn ảnh', style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: updateBookInfo,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        side: MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 2))
                    ),
                    child: const Text('Cập nhật thông tin sách',style: TextStyle(color: Colors.orange),),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}