import '../../App/models/event.dart';
import '../../App/services/database.dart';

DatabaseService eventDBS = DatabaseService("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());