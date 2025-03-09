import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(){
  runApp(const GoogleMaps());
}

class GoogleMaps extends StatelessWidget {
  const GoogleMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  late GoogleMapController _controller;
  final Set<Marker> _marker = {
    Marker(
      markerId: MarkerId("Home"),
      position: LatLng(22.946566757786588, 91.16165372051611),
      infoWindow: InfoWindow(title: "Home", onTap: (){}),
      onTap: (){},
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      draggable: true,
    ),
    Marker(
      markerId: MarkerId("Office"),
      position: LatLng(22.948054910197655, 91.16014160680672),
      infoWindow: InfoWindow(title: "Office", onTap: (){}),
      onTap: (){},
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      draggable: true,
    ),
  };

  final Set<Polyline> _polyLine = {
    Polyline(
      polylineId: PolylineId("new-home"),
      points: [
        LatLng(22.946566757786588, 91.16165372051611),
        LatLng(22.948054910197655, 91.16014160680672),
        LatLng(22.9468038739919, 91.16007389947389),
      ],
      color: Colors.pink,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      width: 8,

    )
  };

  final Set<Circle> _circle = {
    Circle(
      circleId: CircleId("new-circle"),
      center: LatLng(22.946566757786588, 91.16165372051611),
      radius: 100,
      fillColor: Colors.red.withValues(alpha: 0.5),
      strokeColor: Colors.green,
      strokeWidth: 5,
    )
  };

  Position? _position;
  Future<void> _getCurrentLocation()async{
    if(await _checkPersioonStatus()){
      if(await _isLocationEnable()){
        // _position = await Geolocator.getCurrentPosition(
        //   locationSettings: LocationSettings(
        //     accuracy: LocationAccuracy.best,
        //     distanceFilter: 5,
        //   )
        // );
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 2,
          )
        ).listen((pos){
          _position = pos;
          _myLocation();
        });

        setState(() {});
      }else{
        _requestLocationEnable();
      }
    }else{
      _requestPermission();
    }
  }
  Future<bool> _checkPersioonStatus()async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse)return true;
    return false;
  }

  Future<bool> _requestPermission()async{
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse)return true;
    return false;
  }

  Future<bool> _isLocationEnable()async{
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _requestLocationEnable()async{
    await Geolocator.openLocationSettings();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Google maps and Geolocator", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: LatLng(22.948054910197655, 91.16014160680672),
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller = controller;
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        markers: _marker,
        polylines: _polyLine,
        circles: _circle,

      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(onPressed: _getCurrentLocation, child: Icon(Icons.location_on_outlined),),
          SizedBox(width: 16,),
          FloatingActionButton(onPressed: _myLocation, child: Icon(Icons.my_location),),
        ],
      ),
    );
  }
  void _addNewMarker(){
    _marker.add(Marker(markerId: MarkerId("new"),
    position: LatLng(22.946566757786588, 91.16165372051611)
    ));
    setState(() {});
  }

  void _myLocation(){
    _getCurrentLocation();
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_position!.latitude, _position!.longitude),
      zoom: 17,
    ),));
    _marker.add(Marker(markerId: MarkerId("my-location"),
      position: LatLng(_position!.latitude, _position!.longitude),
      infoWindow: InfoWindow(title: "My Current Location ${_position!.latitude}, ${_position!.longitude}", onTap: (){}),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      draggable: true,

    ));

    _polyLine.clear(); // Clear old polyline to refresh it
    _polyLine.add(Polyline(
      polylineId: PolylineId("tracking"),
      color: Colors.blue, // Polyline color
      width: 5, // Polyline thickness
      points: _polylineCoordinates, // Use the list of locations
    ));

    _polylineCoordinates.add(LatLng(_position!.latitude, _position!.longitude));

    setState(() {});
  }
  final List<LatLng> _polylineCoordinates = [];
}


