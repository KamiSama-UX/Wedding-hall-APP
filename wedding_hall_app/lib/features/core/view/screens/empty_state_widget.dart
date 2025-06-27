// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:lottie/lottie.dart';


// class EmptyStateWidget extends StatelessWidget {
//   final String message;
//   const EmptyStateWidget({
//     super.key,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(
//             Assets.lottie.emptyBox,
//             width: 200,
//             height: 200,
//             fit: BoxFit.cover,
//           ),
//           Gap(20.0.h),
//           const Text(
//             'Oops!',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueGrey,
//             ),
//           ),
//           Gap(10.0.h),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
