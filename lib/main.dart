import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'desktop/desktop_home.dart';
import 'desktop/resource_settings.dart';

const gold = Color(0xffD4AF7A);
Future<void> main() async { WidgetsFlutterBinding.ensureInitialized(); await Hive.initFlutter(); await Hive.openBox('pocketdex_notes'); await ResourceSettings.instance.init(); runApp(const XtrMApp()); }
class XtrMApp extends StatelessWidget { const XtrMApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(title:'XTR-M',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true, brightness:Brightness.dark, scaffoldBackgroundColor:const Color(0xff0A0A0A), colorScheme:const ColorScheme.dark(primary:gold,secondary:gold,surface:Color(0xff141414),onSurface:Colors.white), textTheme:ThemeData.dark().textTheme.apply(bodyColor:Colors.white,displayColor:Colors.white), appBarTheme:const AppBarTheme(backgroundColor:Color(0xff0A0A0A),foregroundColor:Colors.white)),home:const SplashScreen()); } 
class SplashScreen extends StatefulWidget {const SplashScreen({super.key});@override State<SplashScreen> createState()=>_SplashScreenState();}
class _SplashScreenState extends State<SplashScreen>{@override void initState(){super.initState();Future.delayed(const Duration(seconds:2),(){if(mounted)Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const DesktopHome()));});}@override Widget build(BuildContext context)=>const Scaffold(backgroundColor:Color(0xff000000),body:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Image.asset('assets/icon/logo.png',width:112,height:112),SizedBox(height:22),Text('X T R - M',style:TextStyle(color:Colors.white,fontSize:15,fontWeight:FontWeight.w300,letterSpacing:3)),SizedBox(height:18),Icon(Icons.circle,color:gold,size:7)])));}
