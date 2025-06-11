/* By Abdullah As-Sadeed */

// import 'dart:async';
// import 'package:bitscoper_cyber_toolbox/main.dart';
// import 'package:bitscoper_cyber_toolbox/message_dialog.dart';
// import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';
// import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'package:bitscoper_cyber_toolbox/application_toolbar.dart';
import 'package:bitscoper_cyber_toolbox/l10n/app_localizations.dart';
import 'package:bitscoper_cyber_toolbox/main.dart';
import 'package:flutter/material.dart';

class RouteTracerPage extends StatefulWidget {
  const RouteTracerPage({super.key});

  @override
  RouteTracerPageState createState() => RouteTracerPageState();
}

class RouteTracerPageState extends State<RouteTracerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(navigatorKey.currentContext!)!.route_tracer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            AppLocalizations.of(
              navigatorKey.currentContext!,
            )!.route_tracer_apology,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// class RouteTracerPageState extends State<RouteTracerPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late String host;

//   final FlutterTraceroute routeTracer = FlutterTraceroute();
//   StreamSubscription? traceSubscription;

//   bool isTracing = false;
//   List<TracerouteStep> traceResults = [];

//   void onTrace() {
//     setState(
//       () {
//         isTracing = true;
//         traceResults = [];
//       },
//     );

//     final arguments = TracerouteArgs(
//       host: host,
//     );

//     traceSubscription = routeTracer.trace(arguments).listen(
//       (event) {
//         setState(
//           () {
//             traceResults = List<TracerouteStep>.from(traceResults)..add(event);
//           },
//         );
//       },
//     );
//   }

//   void onStop() {
//     routeTracer.stopTrace();
//     traceSubscription?.cancel();

//     setState(
//       () {
//         isTracing = false;
//       },
//     );
//   }

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(32.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: AppLocalizations.of(navigatorKey.currentContext!)!.a_host_or_ip_address,
//                     hintText: 'bitscoper.dev',
//                   ),
//                   maxLines: 1,
//                   showCursor: true,
//                   onChanged: (value) {
//                     host = value.trim();
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return AppLocalizations.of(navigatorKey.currentContext!)!.enter_a_host_or_ip_address;
//                     }

//                     return null;
//                   },
//                   onFieldSubmitted: (value) {
//                     if (_formKey.currentState!.validate()) {
//                       onTrace();
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 16.0,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: isTracing
//                           ? null
//                           : () {
//                               if (_formKey.currentState!.validate()) {
//                                 onTrace();
//                               }
//                             },
//                       child: const Text('Trace'),
//                     ),
//                     ElevatedButton(
//                       onPressed: isTracing ? onStop : null,
//                       child: Text(AppLocalizations.of(navigatorKey.currentContext!)!.stop,),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 16.0,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               for (final result in traceResults)
//                 Text(
//                   result.toString(),
//                   style: TextStyle(
//                     fontWeight: result is TracerouteStepFinished
//                         ? FontWeight.bold
//                         : FontWeight.normal,
//                   ),
//                 ),
//               if (isTracing) ...[
//                 const SizedBox(
//                   height: 16.0,
//                 ),
//                 const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
