import '../../../../../config/helpers/hex_color.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../domain/enums/reservation_status.dart';

HexColor bannerColor(ReservationStatus orderStatus) {
  AppColors appColors = AppColors();
  switch (orderStatus) {
    case ReservationStatus.confirmed:
      return appColors.doneOrderBannerColor;
    case ReservationStatus.declined:
      return appColors.failureBannerColor;
    case ReservationStatus.canceled:
      return appColors.failureBannerColor;
    case ReservationStatus.pending:
      return appColors.preparingAndPendingBannerColor;
  }
}
