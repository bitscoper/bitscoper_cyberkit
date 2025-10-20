/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:bitscoper_cyberkit/main.dart';
import 'package:flutter/material.dart';
import 'package:cvss_vulnerability_scoring/cvss_vulnerability_scoring.dart';

class CVSSCalculatorPage extends StatefulWidget {
  const CVSSCalculatorPage({super.key});

  @override
  CVSSCalculatorPageState createState() => CVSSCalculatorPageState();
}

class CVSSCalculatorPageState extends State<CVSSCalculatorPage> {
  @override
  void initState() {
    super.initState();

    _calculateCVSS();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AttackVector _attackVector = AttackVector.adjacentNetwork;
  AttackComplexity _attackComplexity = AttackComplexity.low;
  PrivilegesRequired _privilegesRequired = PrivilegesRequired.high;
  UserInteraction _userInteraction = UserInteraction.none;
  Scope _scope = Scope.changed;
  ConfidentialityImpact _confidentialityImpact = ConfidentialityImpact.high;
  IntegrityImpact _integrityImpact = IntegrityImpact.low;
  AvailabilityImpact _availabilityImpact = AvailabilityImpact.none;

  double _baseScore = 0.0;
  QualitativeSeverityRating _severityRating = QualitativeSeverityRating.none;
  String _vectorString = '';

  void _calculateCVSS() {
    try {
      final CVSSv31 cvss = CVSSv31(
        attackVector: _attackVector,
        attackComplexity: _attackComplexity,
        privilegesRequired: _privilegesRequired,
        userInteraction: _userInteraction,
        scope: _scope,
        confidentialityImpact: _confidentialityImpact,
        integrityImpact: _integrityImpact,
        availabilityImpact: _availabilityImpact,
      );

      setState(() {
        _baseScore = cvss.calculateBaseScore();
        _severityRating = cvss.baseSeverityRating;
        _vectorString = cvss.toString();
      });
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
    } finally {}
  }

  String _formatEnumName(Object enumValue) {
    try {
      return enumValue
          .toString()
          .split('.')
          .last
          .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'),
            (Match match) => '${match[1]} ${match[2]}',
          )
          .replaceFirstMapped(
            RegExp(r'^.'),
            (Match match) => match[0]!.toUpperCase(),
          );
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );
      return error.toString();
    }
  }

  String _getSeverityText() {
    try {
      final String enumName = _severityRating.toString();
      final String valueName = enumName.split('.').last;

      return valueName[0].toUpperCase() + valueName.substring(1).toLowerCase();
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      return error.toString();
    } finally {}
  }

  Color _getSeverityColor() {
    try {
      switch (_severityRating) {
        case QualitativeSeverityRating.critical:
          return Colors.red;
        case QualitativeSeverityRating.high:
          return Colors.orange;
        case QualitativeSeverityRating.medium:
          return Colors.yellow;
        case QualitativeSeverityRating.low:
          return Colors.green;
        case QualitativeSeverityRating.none:
          return Colors.black;
      }
    } catch (error) {
      showMessageDialog(
        AppLocalizations.of(navigatorKey.currentContext!)!.error,
        error.toString(),
      );

      return Colors.transparent;
    } finally {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(
          navigatorKey.currentContext!,
        )!.cvss_calculator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                AppLocalizations.of(
                  navigatorKey.currentContext!,
                )!.common_vulnerability_scoring_system_v3_1_base_score,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<AttackVector>(
                    initialValue: _attackVector,
                    onChanged: (AttackVector? value) {
                      setState(() {
                        _attackVector = value!;
                        _calculateCVSS();
                      });
                    },
                    items: AttackVector.values.map((AttackVector vector) {
                      return DropdownMenuItem<AttackVector>(
                        value: vector,
                        child: Text(_formatEnumName(vector)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.attack_vector,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AttackComplexity>(
                    initialValue: _attackComplexity,
                    onChanged: (AttackComplexity? value) {
                      setState(() {
                        _attackComplexity = value!;
                        _calculateCVSS();
                      });
                    },
                    items: AttackComplexity.values.map((
                      AttackComplexity complexity,
                    ) {
                      return DropdownMenuItem<AttackComplexity>(
                        value: complexity,
                        child: Text(_formatEnumName(complexity)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.attack_complexity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PrivilegesRequired>(
                    initialValue: _privilegesRequired,
                    onChanged: (PrivilegesRequired? value) {
                      setState(() {
                        _privilegesRequired = value!;
                        _calculateCVSS();
                      });
                    },
                    items: PrivilegesRequired.values.map((
                      PrivilegesRequired privileges,
                    ) {
                      return DropdownMenuItem<PrivilegesRequired>(
                        value: privileges,
                        child: Text(_formatEnumName(privileges)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.privileges_required,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<UserInteraction>(
                    initialValue: _userInteraction,
                    onChanged: (UserInteraction? value) {
                      setState(() {
                        _userInteraction = value!;
                        _calculateCVSS();
                      });
                    },
                    items: UserInteraction.values
                        .where(
                          (UserInteraction interaction) =>
                              interaction != UserInteraction.passive &&
                              interaction != UserInteraction.active,
                        )
                        .map((UserInteraction interaction) {
                          return DropdownMenuItem<UserInteraction>(
                            value: interaction,
                            child: Text(_formatEnumName(interaction)),
                          );
                        })
                        .toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.user_interaction,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Scope>(
                    initialValue: _scope,
                    onChanged: (Scope? value) {
                      setState(() {
                        _scope = value!;
                        _calculateCVSS();
                      });
                    },
                    items: Scope.values.map((Scope scope) {
                      return DropdownMenuItem<Scope>(
                        value: scope,
                        child: Text(_formatEnumName(scope)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.scope,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ConfidentialityImpact>(
                    initialValue: _confidentialityImpact,
                    onChanged: (ConfidentialityImpact? value) {
                      setState(() {
                        _confidentialityImpact = value!;
                        _calculateCVSS();
                      });
                    },
                    items: ConfidentialityImpact.values
                        .where(
                          (ConfidentialityImpact impact) =>
                              impact != ConfidentialityImpact.partial &&
                              impact != ConfidentialityImpact.complete,
                        )
                        .map((ConfidentialityImpact impact) {
                          return DropdownMenuItem<ConfidentialityImpact>(
                            value: impact,
                            child: Text(_formatEnumName(impact)),
                          );
                        })
                        .toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.confidentiality_impact,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<IntegrityImpact>(
                    initialValue: _integrityImpact,
                    onChanged: (IntegrityImpact? value) {
                      setState(() {
                        _integrityImpact = value!;
                        _calculateCVSS();
                      });
                    },
                    items: IntegrityImpact.values
                        .where(
                          (IntegrityImpact impact) =>
                              impact != IntegrityImpact.partial &&
                              impact != IntegrityImpact.complete,
                        )
                        .map((IntegrityImpact impact) {
                          return DropdownMenuItem<IntegrityImpact>(
                            value: impact,
                            child: Text(_formatEnumName(impact)),
                          );
                        })
                        .toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.integrity_impact,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AvailabilityImpact>(
                    initialValue: _availabilityImpact,
                    onChanged: (AvailabilityImpact? value) {
                      setState(() {
                        _availabilityImpact = value!;
                        _calculateCVSS();
                      });
                    },
                    items: AvailabilityImpact.values
                        .where(
                          (AvailabilityImpact impact) =>
                              impact != AvailabilityImpact.partial &&
                              impact != AvailabilityImpact.complete,
                        )
                        .map((AvailabilityImpact impact) {
                          return DropdownMenuItem<AvailabilityImpact>(
                            value: impact,
                            child: Text(_formatEnumName(impact)),
                          );
                        })
                        .toList(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        navigatorKey.currentContext!,
                      )!.availability_impact,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getSeverityColor().withValues(
                                alpha: 0.10,
                              ),
                              border: Border.all(
                                color: _getSeverityColor(),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _baseScore.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getSeverityColor(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Chip(
                            label: Text(
                              _getSeverityText(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: SelectableText(_vectorString)),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 16),
                                onPressed: () {
                                  copyToClipboard(
                                    AppLocalizations.of(
                                      navigatorKey.currentContext!,
                                    )!.vector_string,
                                    _vectorString,
                                  );
                                },
                                tooltip: AppLocalizations.of(
                                  navigatorKey.currentContext!,
                                )!.copy_to_clipboard,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
