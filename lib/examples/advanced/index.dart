import 'dart:io';

import 'package:advices/examples/advanced/audio_mixing/audio_mixing.dart';
import 'package:advices/examples/advanced/channel_media_relay/channel_media_relay.dart';
import 'package:advices/examples/advanced/custom_capture_audio/custom_capture_audio.dart';
import 'package:advices/examples/advanced/device_manager/device_manager.dart';
import 'package:advices/examples/advanced/enable_virtualbackground/enable_virtualbackground.dart';
import 'package:advices/examples/advanced/join_multiple_channel/join_multiple_channel.dart';
import 'package:advices/examples/advanced/media_recorder/media_recorder.dart';
import 'package:advices/examples/advanced/rtmp_streaming/rtmp_streaming.dart';
import 'package:advices/examples/advanced/screen_sharing/screen_sharing.dart';
import 'package:advices/examples/advanced/set_encryption/set_encryption.dart';
import 'package:advices/examples/advanced/set_video_encoder_configuration/set_video_encoder_configuration.dart';
import 'package:advices/examples/advanced/stream_message/stream_message.dart';
import 'package:advices/examples/advanced/voice_changer/voice_changer.dart';
import 'package:flutter/foundation.dart';

/// Data source for advanced examples
final advanced = [
  {'name': 'Advanced'},
  {'name': 'AudioMixing', 'widget': const AudioMixing()},
  {'name': 'ChannelMediaRelay', 'widget': const ChannelMediaRelay()},
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
    {'name': 'CustomCaptureAudio', 'widget': const CustomCaptureAudio()},
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS))
    {'name': 'DeviceManager', 'widget': const DeviceManager()},
  {'name': 'JoinMultipleChannel', 'widget': const JoinMultipleChannel()},
  {'name': 'RtmpStreaming', 'widget': const RtmpStreaming()},
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS))
    {'name': 'ScreenSharing', 'widget': const ScreenSharing()},
  {'name': 'SetEncryption', 'widget': SetEncryption()},
  {
    'name': 'SetVideoEncoderConfiguration',
    'widget': const SetVideoEncoderConfiguration()
  },
  {'name': 'StreamMessage', 'widget': const StreamMessage()},
  {'name': 'VoiceChanger', 'widget': const VoiceChanger()},
  {
    'name': 'EnableVirtualBackground',
    'widget': const EnableVirtualBackground()
  },
  {'name': 'MediaRecorder', 'widget': const MediaRecorder()},

];
