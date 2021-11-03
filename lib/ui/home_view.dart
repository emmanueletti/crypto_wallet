import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './add_view.dart';
import '../net/api_functions.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoinCurrentPriceInUSD = 0.0;
  double ethereumCurrentPriceInUSD = 0.0;
  double tetherCurrentPriceInUSD = 0.0;

  void getValues() async {
    bitcoinCurrentPriceInUSD = await getPrice('bitcoin');
    ethereumCurrentPriceInUSD = await getPrice('ethereum');
    tetherCurrentPriceInUSD = await getPrice('tether');
    // set state call to trigger re-rendering
    setState(() {});
  }

  // Similiar to "compopnentDidMount" in React
  @override
  void initState() {
    // using a function getValues to call code b/c can't call async functions
    // directly within initState
    getValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double getValue(String id, double amount) {
      // would be good to use enums here to manage constant values
      if (id == 'bitcoin') {
        return amount * bitcoinCurrentPriceInUSD;
      }
      if (id == 'ethereum') {
        return amount * bitcoinCurrentPriceInUSD;
      }
      if (id == 'tether') {
        return amount * bitcoinCurrentPriceInUSD;
      }
      print('no id match found');
      return 0.0;
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        // research what a StreamBuild is
        child: StreamBuilder(
          // what is happening here?
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Coins')
              .snapshots(),
          // what is builder doing?
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Coin Name: ${document.id}'),
                      Text(
                          'Amount Owned: ${getValue(document.id, (document.data() as Map)['amount']).toStringAsFixed(2)}'),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddView()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
