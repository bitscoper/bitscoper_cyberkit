/* By Abdullah As-Sadeed */

import "dart:core";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

Future<void> sendNotification({
  required final String title,
  required final String subtitle,
  required final String body,
  required final String payload,
}) async {
  final String iconPath = "assets/icon/icon.png";
  final String androidIconName = "icon_monochrome";
  final String linuxSoundTheme = "bell-window-system";
  final String linuxActionName = "default_linux_notification_action_name";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
        defaultIcon: AssetsLinuxIcon(iconPath), // TODO: Test
        defaultSound: ThemeLinuxSound(
          linuxSoundTheme,
        ), // https://0pointer.de/public/sound-naming-spec.html
        defaultActionName: linuxActionName,
      );

  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings(
        androidIconName, // TODO: Test
      );

  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: true,
        requestCriticalPermission: false,
        requestProvisionalPermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: false,
        defaultPresentBadge: true,
        defaultPresentBanner: true,
        defaultPresentList: true,
        defaultPresentSound: true,
      );

  final WindowsInitializationSettings windowsInitializationSettings =
      WindowsInitializationSettings(
        appUserModelId: "18862TeleChirkut.BitscoperCyberToolBox",
        appName: "Bitscoper Cyber Toolbox",
        iconPath: iconPath, // TODO: Test
        guid: "default_windows_notification_action_guid",
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    linux: initializationSettingsLinux,
    android: androidInitializationSettings,
    macOS: darwinInitializationSettings,
    iOS: darwinInitializationSettings,
    windows: windowsInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (
      NotificationResponse notificationResponse,
    ) async {
      final String? payload = notificationResponse.payload;

      if (notificationResponse.payload != null) {
        debugPrint(payload);
      }
    },
  );

  final LinuxNotificationDetails linuxNotificationDetails =
      LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.normal,
        icon: AssetsLinuxIcon(iconPath), // TODO: Test
        actionKeyAsIconName: false,
        defaultActionName: linuxActionName,
        sound: ThemeLinuxSound(linuxSoundTheme),
        suppressSound: false,
        timeout: const LinuxNotificationTimeout.systemDefault(),
        resident: false,
        transient: false,
      );

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        "default_android_notification_channel_identifier",
        "Default",
        channelDescription: "Default Notification Channel",
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
        channelShowBadge: true,
        groupAlertBehavior: GroupAlertBehavior.all,
        setAsGroupSummary: false,
        category: AndroidNotificationCategory.status,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: const DefaultStyleInformation(true, true),
        colorized: true,
        icon: androidIconName, // TODO: Test
        largeIcon: DrawableResourceAndroidBitmap(androidIconName), // TODO: Test
        subText: subtitle,
        showWhen: true,
        when: DateTime.now().millisecondsSinceEpoch,
        usesChronometer: false,
        ticker: body,
        visibility: NotificationVisibility.private,
        silent: false,
        onlyAlertOnce: false,
        playSound: true,
        audioAttributesUsage: AudioAttributesUsage.notification,
        enableVibration: true,
        enableLights: true,
        ongoing: false,
        showProgress: false,
        indeterminate: false,
        autoCancel: true,
        fullScreenIntent: false,
      );

  final DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
        threadIdentifier: "darwin_notification_thread_identifier",
        interruptionLevel: InterruptionLevel.active,
        presentAlert: false,
        presentBadge: true,
        badgeNumber: 1,
        presentBanner: true,
        presentList: true,
        presentSound: true,
        criticalSoundVolume: 1.0,
        subtitle: subtitle,
      );

  final WindowsNotificationDetails windowsNotificationDetails =
      WindowsNotificationDetails(
        header: WindowsHeader(
          id: "windows_notification_header_identifier",
          title: "Bitscoper Cyber Toolbox",
          arguments: payload,
          activation: WindowsHeaderActivation.foreground,
        ),
        subtitle: subtitle,
        timestamp: DateTime.now(),
        audio: WindowsNotificationAudio.preset(
          sound: WindowsNotificationSound.defaultSound,
          shouldLoop: false,
        ),
      );

  final NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxNotificationDetails,
    android: androidNotificationDetails,
    macOS: darwinNotificationDetails,
    iOS: darwinNotificationDetails,
    windows: windowsNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    (DateTime.now().millisecondsSinceEpoch / 1000).toInt(),
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}
