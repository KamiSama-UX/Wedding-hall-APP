import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_service.dart';
import 'package:wedding_hall_app/features/home/halls/domain/entity/hall_services_availability.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/make_reservation_request_body.dart';

class ReservationUiCubit extends Cubit<int> {
  @override
  Future<void> close() {
    dateController.dispose();
    pageController.dispose();
    pageController.dispose();
    return super.close();
  }

  final HallServicesAvailability hallServicesAvailability;
  late PageController pageController;
  late TextEditingController dateController;
  late TextEditingController noteController;
  late TextEditingController guestController;
  late GlobalKey<FormState> key;
  int currentIndex = 0;

  ReservationUiCubit(this.hallServicesAvailability) : super(1) {
    dateController = TextEditingController();
    guestController = TextEditingController();
    noteController = TextEditingController();
    key = GlobalKey<FormState>();
    pageController = PageController();

    selectedServices.addAll({
      hallServicesAvailability.hallServices.first: true,
    });
  }

  // if null not given value yet ...
  DateTime? selectedDate;
  Map<HallService, bool> selectedServices = {};

  // time is always 18:00, in the future it'll be a selected time
  String time = "18:00";

  MakeReservationRequestBody? onNextTap() {
    if (currentIndex == 0) {
      if (key.currentState!.validate()) {
        pageController.nextPage(
          duration: Duration(microseconds: 500),
          curve: Curves.bounceInOut,
        );
        currentIndex++;
        return null;
      }
    } else {
      List<int> selectedHallServicesIds = [];
      List<HallService> selectedHallsServices = [];
      selectedServices.forEach((key, value) {
        if (value) {
          selectedHallsServices.add(key);
          selectedHallServicesIds.add(key.id);
        }
      });
      return MakeReservationRequestBody(
        hallId: hallServicesAvailability.hall.id, 
        guestCount: int.parse(guestController.text),
        eventDate: dateController.text,
        evenTime: time,
        serviceIds: selectedHallServicesIds,
      );
    }
    return null;
  }
}
