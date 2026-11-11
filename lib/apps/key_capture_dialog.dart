import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyCaptureDialog extends StatefulWidget {const KeyCaptureDialog({super.key});@override State<KeyCaptureDialog> createState()=>_KeyCaptureDialogState();}
class _KeyCaptureDialogState extends State<KeyCaptureDialog>{String keyName='';@override Widget build(BuildContext context)=>CallbackShortcuts(bindings:{for(final k in LogicalKeyboardKey.knownLogicalKeys)SingleActivator(k):(){setState(()=>keyName=k.keyLabel);Navigator.pop(context,k.keyLabel);}},child:Focus(autofocus:true, child:AlertDialog(title:const Text('Press a keyboard key'),content:Text(keyName.isEmpty?'Waiting for key…':keyName),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel'))])));}
