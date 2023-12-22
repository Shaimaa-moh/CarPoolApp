import 'package:flutter/material.dart';

List DriverNames =[
  'Ali Mohamed','Mohamed Hassan','Youssef Sherif','Mohamed Ragab','Sherif Wael'

];
List DriverRates =[
  '4,5','5,0','3,5','4,0','5,0'
];

List DriverPrices =[
  'LE 100','LE 110','LE 150','LE 120','LE 120'
];
List DriverArrival =[
  '5 min.','3 min.','2 min.','10 min.','9 min.'
];
List DriverDistance =[
  '1.5 km','2 km','5 km.','10 km.','9 km.'
];
List DiverImages=[
  'https://i.insider.com/4fd0fb09eab8ea5c7f000001','https://ottiservices.com/wp-content/uploads/2018/02/taxi-driver-1170x780.jpeg','https://weare.1tap.io/wp-content/uploads/2017/07/1tap-drivers.jpg','https://i0.wp.com/farm9.staticflickr.com/8116/8679904293_30dc3c5822_o.jpg','https://img.buzzfeed.com/buzzfeed-static/static/2014-09/16/20/enhanced/webdr01/enhanced-19197-1410912650-9.jpg'

];
class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       leading: const BackButton(),
       backgroundColor: Colors.grey.shade900,
     ),
      body:ListView.builder(
        itemCount: DriverNames.length,
      itemBuilder: (context, index){
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: ListTile(title: Text('${DriverNames[index]}',
              ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${DriverRates[index]}'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ElevatedButton(onPressed: (){},

                            style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: const BorderSide(color: Colors.red),

                              ),
                            ) ,
                            child: const Text('Decline',style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),)
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(onPressed: (){
                          _showMyDialog(context);
                        },
                          style:ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: const BorderSide(color: Colors.blue),
                            )
                          ),
                            child: const Text('Accept', style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),)
                        ),
                      ],
                    )
                  ],
                ),
                leading:CircleAvatar(
                    backgroundImage: NetworkImage('${DiverImages[index]}'),
                    radius: 35,
                ),
                trailing: Column(
                  children: [
                    Text('${DriverPrices[index]}', style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                    ),

                    Text('${DriverArrival[index]}', style: const TextStyle(
                      fontSize: 15,
                    ),),

                  ],
                )
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}
Future<void> _showMyDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context)
  {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: const SingleChildScrollView(
        child: Text('Driver is arriving'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
  );
}

