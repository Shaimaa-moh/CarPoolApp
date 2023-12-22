import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {

  late GoogleMapController mapController;
  static const _initialPosition =LatLng(12.92,77.02);
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget> [
      GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(12.92,77.02), zoom: 10.0),

         ),
        ],

      ),
    );
  }
}
