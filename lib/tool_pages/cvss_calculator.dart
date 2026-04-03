/* By Abdullah As-Sadeed */

import 'package:bitscoper_cyberkit/commons/application_toolbar.dart';
import 'package:bitscoper_cyberkit/commons/copy_to_clipboard.dart';
import 'package:bitscoper_cyberkit/commons/message_dialog.dart';
import 'package:bitscoper_cyberkit/l10n/app_localizations.dart';
import 'package:cvss_vulnerability_scoring/cvss_vulnerability_scoring.dart';
import 'package:flutter/material.dart';

class CVSSCalculatorPage extends StatefulWidget {
  const CVSSCalculatorPage({super.key});

  @override
  CVSSCalculatorPageState createState() => CVSSCalculatorPageState();
}

class CVSSCalculatorPageState extends State<CVSSCalculatorPage> {
  @override
  void initState() {
    super.initState();

    _calculateCVSS(context);
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

  Widget _subTitle(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(
          context,
        )!.common_vulnerability_scoring_system_v3_1_base_score,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  void _calculateCVSS(BuildContext context) {
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
        _severityRating = cvss.baseSeverityRating();
        _vectorString = cvss.toString();
      });
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
    } finally {}
  }

  String _formatEnumName(BuildContext context, Object enumValue) {
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
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(context)!.error,
        error.toString(),
      );
      return error.toString();
    }
  }

  String _getSeverityText(BuildContext context) {
    try {
      final String valueName = _severityRating.toString().split('.').last;

      return valueName[0].toUpperCase() + valueName.substring(1).toLowerCase();
    } catch (error) {
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return error.toString();
    } finally {}
  }

  Color _getSeverityColor(BuildContext context) {
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
      debugPrint(error.toString());

      showMessageDialog(
        AppLocalizations.of(context)!.error,
        error.toString(),
      );

      return Colors.transparent;
    } finally {}
  }

  void _onAttackVectorChanged(AttackVector? value) {
    setState(() {
      _attackVector = value!;
      _calculateCVSS(context);
    });
  }

  void _onAttackComplexityChanged(AttackComplexity? value) {
    setState(() {
      _attackComplexity = value!;
      _calculateCVSS(context);
    });
  }

  void _onPrevilegeRequirementChanged(PrivilegesRequired? value) {
    setState(() {
      _privilegesRequired = value!;
      _calculateCVSS(context);
    });
  }

  void _onUserInteractionValueChanged(UserInteraction? value) {
    setState(() {
      _userInteraction = value!;
      _calculateCVSS(context);
    });
  }

  void _onScopeChanged(Scope? value) {
    setState(() {
      _scope = value!;
      _calculateCVSS(context);
    });
  }

  void _onConfidentialityImpactChanged(ConfidentialityImpact? value) {
    setState(() {
      _confidentialityImpact = value!;
      _calculateCVSS(context);
    });
  }

  void _onIntigrityImpactChanged(IntegrityImpact? value) {
    setState(() {
      _integrityImpact = value!;
      _calculateCVSS(context);
    });
  }

  void _onAvailabilityImpactChanged(AvailabilityImpact? value) {
    setState(() {
      _availabilityImpact = value!;
      _calculateCVSS(context);
    });
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButtonFormField<AttackVector>(
            initialValue: _attackVector,
            onChanged: _onAttackVectorChanged,
            items: AttackVector.values.map((AttackVector vector) {
              return DropdownMenuItem<AttackVector>(
                value: vector,
                child: Text(_formatEnumName(context, vector)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.attack_vector,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AttackComplexity>(
            initialValue: _attackComplexity,
            onChanged: _onAttackComplexityChanged,
            items: AttackComplexity.values.map((AttackComplexity complexity) {
              return DropdownMenuItem<AttackComplexity>(
                value: complexity,
                child: Text(_formatEnumName(context, complexity)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.attack_complexity,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<PrivilegesRequired>(
            initialValue: _privilegesRequired,
            onChanged: _onPrevilegeRequirementChanged,
            items: PrivilegesRequired.values.map((
              PrivilegesRequired privileges,
            ) {
              return DropdownMenuItem<PrivilegesRequired>(
                value: privileges,
                child: Text(_formatEnumName(context, privileges)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.privileges_required,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<UserInteraction>(
            initialValue: _userInteraction,
            onChanged: _onUserInteractionValueChanged,
            items: UserInteraction.values.map((UserInteraction interaction) {
              return DropdownMenuItem<UserInteraction>(
                value: interaction,
                child: Text(_formatEnumName(context, interaction)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.user_interaction,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Scope>(
            initialValue: _scope,
            onChanged: _onScopeChanged,
            items: Scope.values.map((Scope scope) {
              return DropdownMenuItem<Scope>(
                value: scope,
                child: Text(_formatEnumName(context, scope)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.scope,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ConfidentialityImpact>(
            initialValue: _confidentialityImpact,
            onChanged: _onConfidentialityImpactChanged,
            items: ConfidentialityImpact.values.map((
              ConfidentialityImpact impact,
            ) {
              return DropdownMenuItem<ConfidentialityImpact>(
                value: impact,
                child: Text(_formatEnumName(context, impact)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.confidentiality_impact,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<IntegrityImpact>(
            initialValue: _integrityImpact,
            onChanged: _onIntigrityImpactChanged,
            items: IntegrityImpact.values.map((IntegrityImpact impact) {
              return DropdownMenuItem<IntegrityImpact>(
                value: impact,
                child: Text(_formatEnumName(context, impact)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.integrity_impact,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AvailabilityImpact>(
            initialValue: _availabilityImpact,
            onChanged: _onAvailabilityImpactChanged,
            items: AvailabilityImpact.values.map((AvailabilityImpact impact) {
              return DropdownMenuItem<AvailabilityImpact>(
                value: impact,
                child: Text(_formatEnumName(context, impact)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(
                context,
              )!.availability_impact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getSeverityColor(context).withValues(alpha: 0.10),
                border: Border.all(color: _getSeverityColor(context), width: 2),
              ),
              child: Text(
                _baseScore.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getSeverityColor(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(
                _getSeverityText(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: SelectableText(_vectorString)),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  onPressed: () {
                    try {
                      copyToClipboard(
                        AppLocalizations.of(
                          context,
                        )!.vector_string,
                        _vectorString,
                      );
                    } catch (error) {
                      debugPrint(error.toString());

                      showMessageDialog(
                        AppLocalizations.of(
                          context,
                        )!.error,
                        error.toString(),
                      );
                    } finally {}
                  },
                  tooltip: AppLocalizations.of(
                    context,
                  )!.copy_to_clipboard,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolBar(
        title: AppLocalizations.of(context)!.cvss_calculator,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _subTitle(context),
            const SizedBox(height: 32.0),
            _form(context),
            const SizedBox(height: 32.0),
            _resultCard(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
