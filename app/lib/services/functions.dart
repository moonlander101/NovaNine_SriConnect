import 'package:lanka_connect/main.dart';

class SupabaseFunctions {
  static Future<void> getTimeSlots(int serviceId) async {
    // /service-booking/slots
    final res = await supabase.functions.invoke(
      '/service-booking/slots',
      body: {'service_id': serviceId},
    );
    final data = res.data;
    print('Time slots for service $serviceId: $data');
  }
}
