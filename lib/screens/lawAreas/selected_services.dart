import 'package:advices/models/service.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/shared_widgets/base_app_bar.dart';
import 'package:advices/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../shared_widgets/BottomBar.dart';

class SelectedServices extends StatefulWidget {
  final int areaId;
  const SelectedServices({Key? key, required this.areaId}) : super(key: key);

  @override
  State<SelectedServices> createState() => _SelectedServicesState();
}

class _SelectedServicesState extends State<SelectedServices>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: CircularNotchedRectangle(),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor,
            stops: [-1, 2],
          ),
        ),
        child: _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<Service>>(
      stream: DatabaseService.getAllServicesByArea(widget.areaId),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) return Text("loading data ...");
        if (snapshot.hasData) {
          final services = snapshot.data!;
          return Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 10),
              child: MediaQuery.of(context).size.width < 750.0
                  ? ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 50.0,
                      ),
                      children: services.map(_card).toList())
                  : GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount:
                          (MediaQuery.of(context).size.width < 1150.0 ? 3 : 5),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      children: services.map(_card).toList(),
                    ));
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
      }),
    );
  }

  Widget _card(Service service) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Lawyers(service: service.id)),
      ),
      child: Card(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  backgroundImage: NetworkImage(
                    service.imageUrl.length > 20
                        ? service.imageUrl
                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
                  ),
                ),
              ),
              title: Text(service.name.toString()),
              subtitle: Text("Description about this service and what types of issues it contains "),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
