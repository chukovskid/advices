import 'package:advices/models/service.dart';
import 'package:advices/screens/lawAreas/gridBadge.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:advices/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../services/database.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class Laws extends StatefulWidget {
  const Laws({Key? key}) : super(key: key);

  @override
  State<Laws> createState() => _LawsState();
}

class _LawsState extends State<Laws>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  bool openExpats = false;
  bool openContracts = false;
  bool openCompanies = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    controller.repeat(reverse: true);
    super.initState();
    // WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    // WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: darkGreenColor,
        //   // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        //   elevation: 0.0,
        //   actions: <Widget>[
        //     FlatButton.icon(
        //       textColor: Color.fromARGB(255, 70, 52, 52),
        //       icon: Icon(Icons.person_outline_sharp),
        //       label: Text(''),
        //       onPressed: _navigateToAuth,
        //     ),
        //   ],
        // ),
        body: MediaQuery.of(context).size.width < 850.0
            ? _mobileView()
            : _webView());
  }

  Widget _webView() {
    return PointerInterceptor(
      intercepting: true,
      child: Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
              stops: [-1, 2],
            ),
          ),
          child: Column(
            children: [
              // Container(
              //     alignment: Alignment.topLeft,
              //     child: Text(
              //       "  First get the advice then pay the advice",
              //       style: TextStyle(fontSize: 25, fontFamily: 'Hindi'),
              //     )),
              //     SizedBox(height: 30,),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(child: _cardsList(2)),
                    Flexible(child: _cardsList(3)),
                    Flexible(child: _cardsList(4)),
                    // Flexible(
                    //   flex: 2,
                    //   child: Container(
                    //     color: Color.fromRGBO(3, 34, 41, 1),
                    //     child: Center(
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                     color: Color.fromRGBO(185, 195, 115, 1))),
                    //             child: SizedBox(
                    //               height: 400,
                    //               width: 500,
                    //             ))),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _mobileView() {
    return Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkGreenColor,
              darkGreenColor,
            ],
            stops: [-1, 2],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openExpats
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Expats",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openExpats = !openExpats;
                        })
                      }),
              // Container( height:openExpats ? 250 : 10, child: openExpats ? _buildGrid() : SizedBox()),
              Container(height: 200, child: _cardsList(2)),
              // SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openContracts
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Contracts",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openContracts = !openContracts;
                        })
                      }),
              // Flexible(child: openContracts ? _cardsList() : SizedBox()),
              Container(height: 200, child: _cardsList(3)),

              // SizedBox(height: 10),
              ListTile(
                  leading: Icon(
                    openCompanies
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 207, 223, 226),
                  ),
                  title: Text(
                    "Companies",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 207, 223, 226)),
                  ),
                  subtitle: const Text(''),
                  onTap: () => {
                        setState(() {
                          openCompanies = !openCompanies;
                        })
                      }),
              // Flexible(child: openCompanies ? _cardsList() : SizedBox()),
              Container(height: 200, child: _cardsList(4)),
            ],
          ),
        ));
  }

  Widget _cardsList(int area) {
    return StreamBuilder<Iterable<Service>>(
      stream: DatabaseService.getAllServicesByArea(area),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
        if (snapshot.hasData) {
          final laws = snapshot.data!;
          return MediaQuery.of(context).size.width < 850.0
              ? GridView.count(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: laws.map(_gridCard).toList())
              : Column(
                  children: [
                    Flexible(
                      child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          children: laws.map(_card).toList()),
                    ),
                  ],
                );
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
    const icon = "account_balance_outlined";
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PointerInterceptor(
            child: ListTile(
              leading:
                  // Image.network(
                  //   'data:image/png;base64,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',
                  // ),
                  //  Icon(IconData(61668, fontFamily: 'MaterialIcons')),

                  CircleAvatar(
                radius: 18,
                child: ClipOval(
                  child: Image.network(
                    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGgAAABxCAYAAAA5xebyAAAAAXNSR0IArs4c6QAACjNJREFUeF7tnX9MldcZx5+Gxc51i0atLjQy7SqmZHSytY22joX2GohYdIVJh9UOWpwWZbkGKkppy6+Kg0JEr6IoRCJOHIRKxUFKh7Ou2thOWxYana1NTclK1a3ZOlcjcfm+3Xv33sv9cc5733vf8773nMR/5Dnvec7zuc855z3v85xz261bt26RLMJa4DYJSFg2imISkNh8JCDB+UhAEpDoFhBcPzkHSUCCW0Bw9aQHSUCCW0Bw9aQHSUCCW0Bw9aQHSUCCW0Bw9YJ60Mhnn9PNsTGaOnkS3fGtiVzd+fLf1+nqP77gqmMH4W/ePoGmT51iSFf8AvrsyjVatqaIPvjwY6Whu2feRYcaqyl+VlzQhs8On6dNdTvp9NmhoLJ2FYidcSdlpqbQ+lXLQ4LlF9Dq0pfp8LEBD/vhV3F0bz0zpCMDJ+hw7+s0MnrFrhyC9mvSd75Ne6o2UWrygqCyvgT8AlryjJNOvvveuDqA1N5QQQ8kJjA1iOERkGr3HqBLl0eY6thN6BsxMbS/9kVKT1nI3TW/gKpcLVS394DPByYlxNNge5MyN7V1H1OGsqELH9LNm2N0d1wszZ+XSEsdycqwqBbI1jUfoPaePm4lrVRh9Orf6asbN8apjPl78MAuip8dfIrQVg64SCipdVHTwS6PxubP+wF1ubYqC4bimkZq7njVr/2SEuZSfvYyWp7uIPyKoqH856sbdPKdc1S1s4XODV/w6PLjqSnUUlPGZYagqzgtJC2c8sZmamj9rbux2Ol3UmlBLuEXdPztd+nkO+/R2NiY8nd4XOMLRZQ49x4u5awsjBVser7TA9KUyZPoo8Furm4FBYSnAdK54fNuz9nV3qms0rzL2hWZtKWoQPlvrALhXfj3xT//pXhQpXMNQSZaygcXL9GCnz/t0d33ew9SXOx3mU3ABAhPwxwCI3f1/4GeLqny24AWEoQAZ315HfW8cUKpk5ORqnhTNAx5n4z8je5Lz/Gw1dHmelp4/zzjAeGJ/SdO0YoNLyiwApXSZ/OoOP9JD5GDPX20vuIVZdhb6vgp7at53vaQIgpo+OIlWvTUOsLYylK2FD1La1dkeYieOjtEWQUl9OX167R8sYP2VG9meZRlZSIKCF6Tt7HSPVSxWC0YpBcL88mZ+wuWR1lSJqKA1HnICEhHBv5ITxWXK0Pc6207CMtxO5aIAzISkrqVNGdWHJ3q3GfL+cgUQEZBwjL8RxkrlfkIS3M7Lr9NA2QUpO1th6msoUnZ7cX7Abbpz7w/TOXbm4Uc8RLj76EtxV+/57EUUwEZAQnbInc9nK4svXdXbabsdIfygpuQlu3ehWAxRKRkFv74h3R0bwNzc6YDMgJSduFm6n/ztMeyG56Ft3DRypzZcVyrTiEAhQoJnXCsWkexM6bR8fYm0ZiEpI8wgEKFhJfgTbUuOrK7LiSDiFZZKEB6IWHLJzP1EWWHgjfmQTQg3voIB0gPJLysAhL25+xWhAGEr6/YslE9gHdbyK6QhAGE+AVAUb+0Sk/6eiwQChACTLRfXCUkAQEBioT0/5lUOA9SVfP+ahjqnIQV3tI1xTR69Zrp64i+lm2EoESWYhlARgx3Fy59QkvyN5gOiSemwFKA7ALJ1oCMgMQytIgiYzkPUg0X6pwkCoBgelgWkF5PQnaF46EHg9lFmL9bGpAeSNip6NpRQ/OTEoWBEEgRywOyOyRbAOKFFBMTQy3/21xFkDpPlGak3c42gFghaeFsqnPRrvYu8hV7F2kQ/tqzFaBgkHzBUQ0jKiTbAfIHSQtHjQTy/tVqIeELLWLI1fQXozzq/sR7ufJ7bAnIG5IWjr+0F9Tx/qaE6NW8kipDIVkyqgfG8c5n5U2x8PULx8ssok+RSomvrYifg/cEKoCEttVleFt3LxVWvGKUA5EE5MeU/oY1X+I4zwHx3tr8WMMIcT7ItkOc1g7Nh7qpeOt2LtPMmTVTCeEyOwglKgBpc4p4KKWnPEzt9ZU8VQyXjQpAsJpeSGYH5UcNIL2QsGj4fes25kM3jHahqAIE4yHzAe83PJ++kVF96nf7TJmPog4QIKHTmQUb6a8fX2b+wec8lko7KzYyyxslGJWAYDyk9uc4y+hPPs4S8mfcNw/tifhBGrYE5H2ugNbgOFYGx3upuw1l9U20y+uoGn+AMhzJ1Fb7kvvPvF6oVrRtVA/rsDE56ZGAoqt+tpjqS53unNbewZPK+QvXAhwcqN0uUh/O8/KrVcj2QSPBQAUDhPqPPvQAdTS+7IaEUyHzSirp9Lm/jHu8Fg6y95ATi10GnAQZ78ji3quLekDBAAb6e0vna4RDnjBHoXjDWZLvpLTkBcqZQZEotpyDQjUcPAPJYF39g+4vr/AcwMHKDwnLw/0dEUn7l4AC0ASUGdOmKEnJKhxVvNNVE5HoIAmIwd1w6CCGPu3HOz0H6zE0NU5EAmK0Goa9gz39ytmpOLrz9gkT6MJAJ+HA13AWCUiHdRGEf2ZoWNmf4z0/lLc5CYjXYhGWl4AibHDe5mwHCC+caXm/5rVDROWjeqsHS+K5izxPaYyo9Rkai/qdhMTFYp/A2N/aaM8USIYfp+1EbDcH2Y2QBCQ4UQlIAmKzQDhCf9laFltKepDYfMQ5qyctt9Dja6YRwfOC255JvbB7EAIr3njrDJMydhY6tK1a+RLLW8IKCLu+Dz7+S16dbCfPm3KiNUBYAdU07aea3fttZ3DeDoUyXIcVkPe8wtsxO8gj5XGgzaW7K2EF9L3kDHd0jG4NLV6x6Jkn6fmCPN29CCsglvg03ZpbpKKr/DlakZGmW9uwApIeRPSbjYW0+ollhgIa7utg3g1Hw37vsMM10cff/rNu5exQcW1OJtdlGt59RroMbi1Tyx0TJ9Knb/VymcYvoMKKOuUS22gu935/tnK3kd7ivRKePTOWzvb4vjzYXxt+ARmdwq63k2bX07vMxs0uuB9pZPRzdxcQU46jq3mKX0CIJUtIzfZ57TFPA1aXxVK7r7WRO1QY12zjwHdt2Vn+HOVwLjoC3qOKGGfW/Burgwikf27WY9RQ6mTuInZhfvLEao8fN4a3M937uUEHBIQsgaSMlQFzb5i1trggrhUFpEBnL6iXz1e7WpT0Fm3RO1QGvYlYvbHR4vY1RH0kJCPLLzM1xWOpjHO9O44N0I62w/TR5U/HtbVu5XKq2qAv5SUoILTmrG6g1s7XDOmkXR6Cw81nTJ2i7Lb4gqL2M+PRZGrZWsY9tKn1mQBBGCmDLzU2c2ek2QWInn5gWER2eSj3ljMDgoJD5y8qqYY8KfB6Omb1OkgSq3T+irLTF4XcFS5AaA0TIdI48BLrKyc0ZI0s/IDY6dMoNytD2R4yKrWFG5DWflipjF65Nm7FYmEb61YdXhOOdJaQAOnujazIbAEJiNlU5ghKQObYnblVCYjZVOYISkDm2J25VQmI2VTmCEpA5tiduVUJiNlU5ghKQObYnblVCYjZVOYISkDm2J251f8CUFKwJnbsj9oAAAAASUVORK5CYII=',
                  ),
                ),
              ),
              //  const Icon(
              //   Icons.account_balance_outlined,
              //   color: Color.fromARGB(255, 207, 223, 226),
              // ),
              title: Text(
                service.name.toString(),
                style: TextStyle(
                    fontSize: 17, color: Color.fromRGBO(3, 34, 41, 1)),
              ),
              subtitle: const Text(''),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Lawyers(service: service.id)),
              ),
            ),
          ),
          const SizedBox(
              // height: 10,
              )
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Container(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[100],
            child: const Text("He'd have you all unravel at the"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[200],
            child: const Text('Heed not the rabble'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[300],
            child: const Text('Sound of screams but the'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[400],
            child: const Text('Who scream'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[500],
            child: const Text('Revolution is coming...'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[600],
            child: const Text('Revolution, they...'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[600],
            child: const Text('Revolution, they...'),
          ),
        ],
      ),
    );
  }

  Widget _gridCard(Service law) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
      child: GridBadge(
        radius: 10,
        borderWidth: 1,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
      ),

      //  CircleAvatar(
      //       radius: 10,
      //       backgroundColor: Colors.indigo,
      //       child: CircleAvatar(
      //         radius: 10 ,
      //         backgroundColor: Colors.black,
      //         child: CircleAvatar(
      //           // radius: 10 - 2 * borderWidth,
      //           backgroundImage: NetworkImage("https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bGVuc3xlbnwwfHwwfHw%3D&w=1000&q=80"),
      //         ),
      //       ),

      // child: const Text("He'd have you all unravel at the"),
    );
  }
}
