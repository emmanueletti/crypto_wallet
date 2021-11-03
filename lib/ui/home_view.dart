import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
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
    double getValue(String id, num amount) {
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
        decoration: const BoxDecoration(
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
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          'Coin Name: ${document.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '\$${getValue(document.id, (document.data() as Map)['amount']).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await removeCoin(document.id);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
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
