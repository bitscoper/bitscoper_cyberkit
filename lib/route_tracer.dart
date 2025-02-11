/* By Abdullah As-Sadeed */

// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as localizations;
// import 'package:flutter_traceroute/flutter_traceroute.dart';
// import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';

class RouteTracerPage extends StatelessWidget {
  const RouteTracerPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.AppLocalizations.of(context)!.route_tracer,
        ),
        centerTitle: true,
      ),
      body: const RouteTracerBody(),
    );
  }
}

class RouteTracerBody extends StatefulWidget {
  const RouteTracerBody({super.key});

  @override
  RouteTracerBodyState createState() => RouteTracerBodyState();
}

class RouteTracerBodyState extends State<RouteTracerBody> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          localizations.AppLocalizations.of(context)!.route_tracer_apology,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// class RouteTracerBodyState extends State<RouteTracerBody> {
//   final _formKey = GlobalKey<FormState>();
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
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: AppLocalizations.of(context)!.a_host_or_ip_address,
//                     hintText: 'bitscoper.dev',
//                   ),
//                   maxLines: 1,
//                   showCursor: true,
//                   onChanged: (value) {
//                     host = value.trim();
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a host or IP address!';
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
//                   height: 16,
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
//                       child: Text(AppLocalizations.of(context)!.stop,),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 16,
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
//                   height: 16,
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
