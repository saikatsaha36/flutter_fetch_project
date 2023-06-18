import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostsApp extends StatefulWidget {
  const PostsApp({super.key});

  @override
  PostsAppState createState() => PostsAppState();
}

class PostsAppState extends State<PostsApp> {
  List<dynamic> posts = [];
  int currentPage = 0;
  int postsPerPage = 2;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> getPostsData() async {
    final apiUrl =
        'https://jsonplaceholder.typicode.com/posts?_start=$currentPage&_limit=$postsPerPage';

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        posts.addAll(data);
        currentPage += postsPerPage;
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch posts data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPostsData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPostsData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Posts')),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length + 1,
        itemBuilder: (ctx, index) {
          if (index == posts.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    getPostsData();
                  },
                  child: const Text('Load More'),
                ),
              ),
            );
          } else {
            final post = posts[index];
            return ListTile(
              leading: Text((index + 1).toString()),
              title: Text(post['title']),
              subtitle: Text(post['body']),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PostsApp(),
  ));
}





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Posts App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PostsPage(),
//     );
//   }
// }
//
// class PostsPage extends StatefulWidget {
//   @override
//   _PostsPageState createState() => _PostsPageState();
// }
//
// class _PostsPageState extends State<PostsPage> {
//   List<Post> _posts = [];
//   bool _isLoading = false;
//   int _currentPage = 1;
//   int _postsPerPage = 10;
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPosts();
//     _scrollController.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchPosts() async {
//     if (_isLoading) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     // final response = await http.get(
//     final apiUrl =
//       'https://jsonplaceholder.typicode.com/posts?_start=${(_currentPage - 1) * _postsPerPage}&_limit=$_postsPerPage';
//     // );
//
//
//
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = jsonDecode(response.body);
//       setState(() {
//         _posts.addAll(responseData.map((data) => Post.fromJson(data)).toList());
//         _isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to fetch posts');
//     }
//   }
//
//   void _scrollListener() {
//     if (_scrollController.offset >=
//         _scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       setState(() {
//         _currentPage++;
//       });
//       _fetchPosts();
//     }
//   }
//
//   Widget _buildLoader() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Posts'),
//       ),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _posts.length + 1,
//         itemBuilder: (BuildContext context, int index) {
//           if (index == _posts.length) {
//             return _buildLoader();
//           } else {
//             final post = _posts[index];
//             return ListTile(
//               title: Text(post.title),
//               subtitle: Text(post.body),
//               tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class Post {
//   final int id;
//   final String title;
//   final String body;
//
//   Post({required this.id, required this.title, required this.body});
//
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }
//
