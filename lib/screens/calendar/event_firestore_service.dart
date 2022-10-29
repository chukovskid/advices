import '../../App/contexts/callEventsContext.dart';
import '../../App/models/event.dart';
import '../../App/services/database.dart';

CallEventsContext eventDBS = CallEventsContext("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());