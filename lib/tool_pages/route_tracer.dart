/* By Abdullah As-Sadeed */

import 'dart:async';
import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter_traceroute/flutter_traceroute_platform_interface.dart';
import 'package:flutter_traceroute/flutter_traceroute.dart';
import 'package:flutter/material.dart';

class RouteTracerPage extends StatefulWidget {
  const RouteTracerPage({super.key});

  @override
  RouteTracerPageState createState() => RouteTracerPageState();
}

class RouteTracerPageState extends State<RouteTracerPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _hostEditingController = TextEditingController();

  final FlutterTraceroute _routeTracer = FlutterTraceroute();
  StreamSubscription? _traceSubscription;

  bool _isTracing = false;
  List<TracerouteStep> _traceResults = [];

  String? _hostFieldValidator(String? value) {
    if ((value == null) || value.isEmpty) {
      return AppLocalizations.of(
        navigatorKey.currentContext!,
      )!.enter_a_host_or_ip_address;
    } else {
      return null;
    }
  }

  void _trace() {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isTracing = true;
          _traceResults = [];
        });

        final TracerouteArgs arguments = TracerouteArgs(
          host: _hostEditingController.text.trim(),
          ttl: TracerouteArgs.ttlDefault,
        );

        _traceSubscription = _routeTracer.trace(arguments).listen((
          TracerouteStep event,
        ) {
          setState(() {
            _traceResults = List<TracerouteStep>.from(_traceResults)
              ..add(event);
          });
        });
      }
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  void _stop() {
    try {
      _routeTracer.stopTrace();
      _traceSubscription?.cancel();
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {
      setState(() {
        _isTracing = false;
      });
    }
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _hostEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(navigatorKey.currentContext!)!.a_host_or_ip_address,
              hintText: 'bitscoper.dev',
            ),
            maxLines: 1,
            showCursor: true,
            onChanged: (String value) {},
            validator: _hostFieldValidator,
            onFieldSubmitted: (String value) {
              _trace();
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isTracing ? null : _trace,
                child: Text(AppLocalizations.of(navigatorKey.currentContext!)!.trace),
              ),
              ElevatedButton(
                onPressed: _isTracing ? _stop : null,
                child: Text(AppLocalizations.of(navigatorKey.currentContext!)!.stop),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final result in _traceResults)
          Text(
            result.toString(),
            style: TextStyle(
              fontWeight: (result is TracerouteStepFinished)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.route_tracer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _form(),
            const SizedBox(height: 16.0),
            _resultColumn(),
            const SizedBox(height: 16.0),
            if (_isTracing) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostEditingController.dispose();
    _routeTracer.stopTrace();
    _traceSubscription?.cancel();

    super.dispose();
  }
}
