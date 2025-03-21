class ZoomClassData {
  String uuid;
  int id;
  String hostId;
  String hostEmail;
  String topic;
  int type;
  String status;
  String startTime;
  int duration;
  String timezone;
  String createdAt;
  String startUrl;
  String joinUrl;
  String password;
  String h323Password;
  String pstnPassword;
  String encryptedPassword;
  ZoomSettings settings;
  bool preSchedule;

  ZoomClassData({
    required this.uuid,
    required this.id,
    required this.hostId,
    required this.hostEmail,
    required this.topic,
    required this.type,
    required this.status,
    required this.startTime,
    required this.duration,
    required this.timezone,
    required this.createdAt,
    required this.startUrl,
    required this.joinUrl,
    required this.password,
    required this.h323Password,
    required this.pstnPassword,
    required this.encryptedPassword,
    required this.settings,
    required this.preSchedule,
  });

  factory ZoomClassData.fromJson(Map<String, dynamic> json) {
    return ZoomClassData(
      uuid: json['uuid'],
      id: json['id'],
      hostId: json['host_id'],
      hostEmail: json['host_email'],
      topic: json['topic'],
      type: json['type'],
      status: json['status'],
      startTime: json['start_time'],
      duration: json['duration'],
      timezone: json['timezone'],
      createdAt: json['created_at'],
      startUrl: json['start_url'],
      joinUrl: json['join_url'],
      password: json['password'],
      h323Password: json['h323_password'],
      pstnPassword: json['pstn_password'],
      encryptedPassword: json['encrypted_password'],
      settings: ZoomSettings.fromJson(json['settings']),
      preSchedule: json['pre_schedule'],
    );
  }
}

class ZoomSettings {
  bool hostVideo;
  bool participantVideo;
  bool cnMeeting;
  bool inMeeting;
  bool joinBeforeHost;
  int jbhTime;
  bool muteUponEntry;
  bool watermark;
  bool usePmi;
  int approvalType;
  String audio;
  String autoRecording;
  bool enforceLogin;
  String enforceLoginDomains;
  String alternativeHosts;
  bool alternativeHostUpdatePolls;
  bool closeRegistration;
  bool showShareButton;
  bool allowMultipleDevices;
  bool registrantsConfirmationEmail;
  bool waitingRoom;
  bool requestPermissionToUnmuteParticipants;
  bool registrantsEmailNotification;
  bool meetingAuthentication;
  String encryptionType;
  bool enableApprovedOrDeniedCountriesOrRegions;
  bool enableBreakoutRoom;
  bool internalMeeting;
  bool enableContinuousMeetingChat;
  bool autoAddInvitedExternalUsers;
  String channelId;
  bool participantFocusedMeeting;
  bool pushChangeToCalendar;
  List<dynamic> resources;
  bool alternativeHostsEmailNotification;
  bool showJoinInfo;
  bool deviceTesting;
  bool focusMode;
  List<dynamic> meetingInvitees;
  bool enableDedicatedGroupChat;
  bool privateMeeting;
  bool emailNotification;
  bool hostSaveVideoOrder;
  bool enableSignLanguageInterpretation;
  bool emailInAttendeeReport;

  ZoomSettings({
    required this.hostVideo,
    required this.participantVideo,
    required this.cnMeeting,
    required this.inMeeting,
    required this.joinBeforeHost,
    required this.jbhTime,
    required this.muteUponEntry,
    required this.watermark,
    required this.usePmi,
    required this.approvalType,
    required this.audio,
    required this.autoRecording,
    required this.enforceLogin,
    required this.enforceLoginDomains,
    required this.alternativeHosts,
    required this.alternativeHostUpdatePolls,
    required this.closeRegistration,
    required this.showShareButton,
    required this.allowMultipleDevices,
    required this.registrantsConfirmationEmail,
    required this.waitingRoom,
    required this.requestPermissionToUnmuteParticipants,
    required this.registrantsEmailNotification,
    required this.meetingAuthentication,
    required this.encryptionType,
    required this.enableApprovedOrDeniedCountriesOrRegions,
    required this.enableBreakoutRoom,
    required this.internalMeeting,
    required this.enableContinuousMeetingChat,
    required this.autoAddInvitedExternalUsers,
    required this.channelId,
    required this.participantFocusedMeeting,
    required this.pushChangeToCalendar,
    required this.resources,
    required this.alternativeHostsEmailNotification,
    required this.showJoinInfo,
    required this.deviceTesting,
    required this.focusMode,
    required this.meetingInvitees,
    required this.enableDedicatedGroupChat,
    required this.privateMeeting,
    required this.emailNotification,
    required this.hostSaveVideoOrder,
    required this.enableSignLanguageInterpretation,
    required this.emailInAttendeeReport,
  });

  factory ZoomSettings.fromJson(Map<String, dynamic> json) {
    return ZoomSettings(
      hostVideo: json['host_video'],
      participantVideo: json['participant_video'],
      cnMeeting: json['cn_meeting'],
      inMeeting: json['in_meeting'],
      joinBeforeHost: json['join_before_host'],
      jbhTime: json['jbh_time'],
      muteUponEntry: json['mute_upon_entry'],
      watermark: json['watermark'],
      usePmi: json['use_pmi'],
      approvalType: json['approval_type'],
      audio: json['audio'],
      autoRecording: json['auto_recording'],
      enforceLogin: json['enforce_login'],
      enforceLoginDomains: json['enforce_login_domains'],
      alternativeHosts: json['alternative_hosts'],
      alternativeHostUpdatePolls: json['alternative_host_update_polls'],
      closeRegistration: json['close_registration'],
      showShareButton: json['show_share_button'],
      allowMultipleDevices: json['allow_multiple_devices'],
      registrantsConfirmationEmail: json['registrants_confirmation_email'],
      waitingRoom: json['waiting_room'],
      requestPermissionToUnmuteParticipants:
          json['request_permission_to_unmute_participants'],
      registrantsEmailNotification: json['registrants_email_notification'],
      meetingAuthentication: json['meeting_authentication'],
      encryptionType: json['encryption_type'],
      enableApprovedOrDeniedCountriesOrRegions:
          json['approved_or_denied_countries_or_regions']['enable'],
      enableBreakoutRoom: json['breakout_room']['enable'],
      internalMeeting: json['internal_meeting'],
      enableContinuousMeetingChat: json['continuous_meeting_chat']['enable'],
      autoAddInvitedExternalUsers: json['continuous_meeting_chat']
          ['auto_add_invited_external_users'],
      channelId: json['continuous_meeting_chat']['channel_id'] ?? '',
      participantFocusedMeeting: json['participant_focused_meeting'],
      pushChangeToCalendar: json['push_change_to_calendar'],
      resources: json['resources'],
      alternativeHostsEmailNotification:
          json['alternative_hosts_email_notification'],
      showJoinInfo: json['show_join_info'],
      deviceTesting: json['device_testing'],
      focusMode: json['focus_mode'],
      meetingInvitees: json['meeting_invitees'] ?? [],
      enableDedicatedGroupChat: json['enable_dedicated_group_chat'],
      privateMeeting: json['private_meeting'],
      emailNotification: json['email_notification'],
      hostSaveVideoOrder: json['host_save_video_order'],
      enableSignLanguageInterpretation: json['sign_language_interpretation']
          ['enable'],
      emailInAttendeeReport: json['email_in_attendee_report'],
    );
  }
}
