import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'save.dart';
import 'bg.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const  MySignInPage(),
    );
  }
}
class MySignInPage extends StatefulWidget {
  const MySignInPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySignInPageState createState() => _MySignInPageState();
}

class _MySignInPageState extends State<MySignInPage> {
  final auth = FirebaseAuth.instance;
  final providers = [EmailAuthProvider()];
  final users = Users(); // Khởi tạo đối tượng Users

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: auth.currentUser == null ? "/sign-in" : "/TheList",
      routes: {
        "/sign-in": (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                await users.checkFirstTimeUser(); // Gọi phương thức checkFirstTimeUser
                // ignore: use_build_context_synchronously
                Navigator.restorablePushNamed(context, "/TheList");
              })
            ],
          );
        },
        "/TheList": (context) {
          return const TheList();
        }
      },
    );
  }
}

class TheList extends StatefulWidget {
  const TheList({super.key});

  @override
  State<TheList> createState() => _TheListState();
}

class _TheListState extends State<TheList> {
  late Future<List<book>> theList;
  String search = '';
  String filter = 'all';
  final auth = FirebaseAuth.instance;
  String? userRole;
  int? userId; // Khai báo biến userId

  @override
  void initState() {
    super.initState();
    theList = savebook.getbook(); // Giả định rằng bạn có hàm này để lấy dữ liệu sách
  }

  void setFilter(String newFilter) {
    setState(() {
      filter = newFilter;
      search = ''; // Reset search khi thay đổi tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
        Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
        if (data != null) {
          userRole = data['role'];
          userId = data['id']; // Truy cập vào ID của người dùng
        }
      }


        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: userRole == 'admin' ? const Text('Sách Tri Thức (Admin)', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)) : const Text('Sách Tri Thức', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),
              backgroundColor: const Color.fromARGB(255, 1, 5, 5),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Color.fromARGB(255, 249, 250, 250)),
              toolbarHeight: 90,
              flexibleSpace: Container(
                decoration:const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color.fromARGB(255, 252, 253, 252), width: 1))
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                   if (userRole == 'admin') ...[
                      IconButton(onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const resgisterbook()));
                      }, icon:const Icon(Icons.app_registration)),
                    ],

                    IconButton(onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const TheList()));
                    },icon: const Icon(Icons.refresh, size: 25,)),

                    IconButton(
                      icon:const Icon(Icons.logout, size: 25,),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.restorablePushNamed(context, "/sign-in");
                      },
                    ),
                  ],
                )
              ],
              bottom: PreferredSize(
                preferredSize:const Size.fromHeight(60),
                child: TabBar(
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        setFilter('all');
                        break;
                      case 1:
                        setFilter('science');
                        break;
                      case 2:
                        setFilter('novel');
                        break;
                    }
                  },
                  tabs: [
                    // ignore: sized_box_for_whitespace
                    Tab(child: Container(width: 120, child: const Align(alignment: Alignment.center, child: Text('all')))),
                    // ignore: sized_box_for_whitespace
                    Tab(child: Container(width: 120, child:const Align(alignment: Alignment.center, child: Text('science')))),
                    // ignore: sized_box_for_whitespace
                    Tab(child: Container(width: 120, child:const Align(alignment: Alignment.center, child: Text('novel')))),
                  ],
                  labelPadding:const EdgeInsets.all(3),
                  labelColor:const Color.fromARGB(255, 240, 40, 40),
                  unselectedLabelColor:const Color.fromARGB(255, 255, 252, 252),
                  indicator: BoxDecoration(
                    border:  Border.all(width: 2, color:const Color.fromARGB(255, 253, 253, 253)),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
            ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration:const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pic1.jpg'),
                  fit: BoxFit.cover
                  )
              ),
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              child: Column(
                 children: [
            Padding(
              padding:const EdgeInsets.all(20),
              
              child: TextField(
                style: const TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
                onChanged: (value) {
                  setState(() {
                    search = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm',
                  fillColor: Colors.white54,
                  filled: true,
                  prefixIcon:const Icon(Icons.search, color: Colors.black),
                  labelStyle:const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<book>>(
                future: theList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('ERROR: ${snapshot.error}');
                  } else {
                    final books = snapshot.data!
                        // ignore: avoid_types_as_parameter_names
                        .where((book) =>
                            (filter == 'all' || book.category == filter) &&
                            (search.isEmpty || book.name.toLowerCase().contains(search) ||  book.id.toLowerCase().contains(search))                      
                            )
                        .toList();
                          return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return ListTile(
                                  title: Container(
                                    padding:const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black, width: 2)
                                    ),
                                    child: Row(
                                        children: [
                                        book.imagepath != null
                                        ? Image.network(book.imagepath!, width: 100, height: 100)
                                        : Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey,
                                            alignment: Alignment.center,
                                            child:const Text('null', style: TextStyle(color: Colors.black)),
                                          ),
                                        const SizedBox(width: 15), // Khoảng cách giữa ảnh và text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              
                                              Text('Books: ${book.name}', style:const TextStyle(color: Color.fromARGB(255, 218, 5, 5), fontSize: 24, fontWeight: FontWeight.bold)),
                                              Text('Actor: ${book.actor}', style:const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 onLongPress: userRole == 'admin' ? () {
                                        _menu(context, book);
                                  } : null,
                                   onTap:() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => viewfull(books: book)));
                                      },                                                                           
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        );
      },
    );
  }
   void _menu(BuildContext context, book selectedBook) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title:const Text('Chọn hành động', style: TextStyle(fontSize: 30),),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context); // Đóng menu dialog
              _showEditDialog(selectedBook); // Mở hộp thoại chỉnh sửa
            },
            child: const Text('Chỉnh sửa', style: TextStyle(fontSize: 25),),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context); // Đóng menu dialog
              _deletes(context, selectedBook); // Mở hộp thoại xác nhận xóa
            },
            child: const Text('Xóa', style: TextStyle(fontSize: 25),),
          ),
           SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context); // Đóng menu dialog
            },
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}
  void _showEditDialog(book selectedBook) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Chỉnh sửa sách'),
          content:const Text('Bạn có muốn chỉnh sửa thông tin cho sách này không?'),
          actions: <Widget>[
            TextButton(
              child:const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookUpdatePage(bookId: selectedBook.id),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  void _deletes(BuildContext context, book book){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title:const Text('XÓA'),
          content: Text('bạn có chắc muốn xóa danh sách của cuốn sách: ${book.name}'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child:const Text('đóng')),
            TextButton(onPressed: ()async{
              await savebook.deletedata(book.id);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              setState(() {
                theList = savebook.getbook();
              });
              // Thêm thông báo xóa thành công bằng AlertDialog
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:const Text('Thông báo'),
                    content: Text('Đã xóa thành công sách có quyển sách tên: ${book.name}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child:const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }, child:const Text('xóa'))
          ],
        );
      });
    }
}

// ignore: camel_case_types
class viewfull extends StatelessWidget {
    final book books;
    viewfull({required this.books});


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${books.name}", style:const TextStyle(color: Colors.blueAccent, fontSize: 24),),
        iconTheme:const IconThemeData(color: Colors.white),
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: 1))
          ),
        ),
        actions: [
           IconButton(onPressed: (){
            Navigator.push(context,
             (MaterialPageRoute(builder: (context)=>const TheList())));
          }, icon:const Icon(Icons.home, size: 30,))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pic2.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: double.infinity, // Đặt chiều dài vô hạn
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 1)
            ),
            child: ListView(
              children: [
                books.imagepath != null
                    ? Image.network(books.imagepath!, width: 650, height: 450)
                     : Container(
                        width: 650,
                        height: 450,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child:const Text('null', style: TextStyle(color: Colors.white)),
                  ),
                const SizedBox(width: 50), // Khoảng cách giữa ảnh và text
                Expanded(
                  child: Padding( // Thêm widget này
                    padding:const EdgeInsets.all(20), 
                     
                    child: Column(       
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Tên Sách: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.name, style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        )
                      ),
                        const SizedBox(height: 5,),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Tác giả: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.actor, style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        )
                      ),
                        const SizedBox(height: 5,),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Thể Loại: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.category, style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        )
                      ),
                        const SizedBox(height: 5,),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Xuất Bản: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.daypublishing, style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        )
                      ),
                        const SizedBox(height: 5,),
                      Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Nhà Xuất Bản: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.companypublishing, style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        )
                      ),
                        const SizedBox(height: 5,),
                        Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 20),
                          child:RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(text: 'Gía Tham Khảo: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                                TextSpan(text: books.price, style: const TextStyle(color: Colors.white, fontSize: 22)),
                              ],
                            ),
                          )
                        ),
                        const SizedBox(height: 5,),
                      const Divider (
                          color: Colors.white,
                          height: 50,
                        ),
                       Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: 'Mô Tả: ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                              TextSpan(text: books.description, style: const TextStyle(color: Colors.white, fontSize: 20)),
                            ],
                          ),
                        )
                       ),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
