import 'package:flutter/material.dart';
import 'package:flutter_multiple_tracks/screens/sound_blend_home.dart';
import 'dart:ffi';

class FFIBridge {
  static bool initialize() {
    // nativeApiLib = (DynamicLibrary.open('libapi.so')); // android and linux only
    // for ios, use:
    nativeApiLib = DynamicLibrary.process();
    final _add = nativeApiLib
        .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('add');
    add = _add.asFunction<int Function(int, int)>();
    // final _cap = nativeApiLib.lookup<
    //     NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>('capitalize');
    // _capitalize = _cap.asFunction<Pointer<Utf8> Function(Pointer<Utf8>)>();
    return true;
  }

  static late DynamicLibrary nativeApiLib;
  static late Function add;
  // static late Function _capitalize;
  // static String capitalize(String str) {
  //   final _str = str.toNativeUtf8();
  //   Pointer<Utf8> res = _capitalize(_str);
  //   calloc.free(_str);
  //   return res.toDartString();
  // }
}

void main() {
  // FFIBridge.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // final int val = FFIBridge.add(2, 3);
    return MaterialApp(
      title: 'Sound Blend',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: const SoundBlendHome(),
      // home: Text(val.toString()),
    );
  }
}
