import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                    crossAxisSpacing: 10, mainAxisSpacing: 10,
                childAspectRatio: 2/3,
                ),
                itemBuilder: (context, index){
                return Card(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.docs[index]['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    Image.network(snapshot.data!.docs[index]['image_url']),
                    Text("Rating : ${snapshot.data!.docs[index]['rating']}")
                  ],
                ));
                });
          }
          return const Center(child: Text("No Data"),);
        }
      ),
    );
  }
}
