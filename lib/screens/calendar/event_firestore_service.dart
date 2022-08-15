import '../../models/event.dart';
import '../../services/database.dart';

DatabaseService eventDBS = DatabaseService("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());