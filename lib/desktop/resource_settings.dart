import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
// XTR-M retains existing Hive box names for installed user data.

class ResourceSettings extends ChangeNotifier {
 static const defaults=<String,dynamic>{'lowRam':15.0,'criticalRam':8.0,'lowStorage':10.0,'criticalStorage':5.0,'highCpu':85.0,'batterySaver':20.0,'criticalBattery':10.0,'maxWindowsLite':3,'maxWindowsNormal':6,'autoMinimize':true,'autoLite':true,'autoBatterySaver':true,'sleepTime':'5min','refreshRate':'2s','profile':'Balanced','liteMode':false};
 static ResourceSettings? _instance;
 static ResourceSettings get instance=>_instance??=ResourceSettings._();
 ResourceSettings._();
 Box get box=>Hive.box('resource_settings');
 Object? get(String key)=>box.get(key,defaultValue:defaults[key]);
 Future<void> init()async{if(!Hive.isBoxOpen('resource_settings'))await Hive.openBox('resource_settings');for(final e in defaults.entries){if(!box.containsKey(e.key))await box.put(e.key,e.value);}}
 Future<void> set(String key,Object value,{bool custom=true})async{await box.put(key,value);if(custom&&key!='profile')await box.put('profile','Custom');notifyListeners();}
 Future<void> profile(String name)async{final Map<String,Object> v=switch(name){'Battery Saver'=>{'lowRam':25.0,'criticalRam':15.0,'lowStorage':25.0,'criticalStorage':15.0,'highCpu':75.0,'batterySaver':25.0,'criticalBattery':12.0,'maxWindowsLite':2,'maxWindowsNormal':2,'autoMinimize':true,'autoLite':true,'autoBatterySaver':true,'sleepTime':'1min','refreshRate':'5s','liteMode':true},'Performance'=>{'lowRam':8.0,'criticalRam':5.0,'lowStorage':8.0,'criticalStorage':4.0,'highCpu':95.0,'batterySaver':8.0,'criticalBattery':5.0,'maxWindowsLite':3,'maxWindowsNormal':8,'autoMinimize':true,'autoLite':true,'autoBatterySaver':true,'sleepTime':'Never','refreshRate':'1s','liteMode':false},_=>{'lowRam':15.0,'criticalRam':8.0,'lowStorage':10.0,'criticalStorage':5.0,'highCpu':85.0,'batterySaver':20.0,'criticalBattery':10.0,'maxWindowsLite':3,'maxWindowsNormal':6,'autoMinimize':true,'autoLite':true,'autoBatterySaver':true,'sleepTime':'5min','refreshRate':'2s','liteMode':false}};for(final e in v.entries){await box.put(e.key,e.value);}await box.put('profile',name);notifyListeners();}
 Future<void> reset()async{for(final e in defaults.entries){await box.put(e.key,e.value);}await box.put('profile','Balanced');notifyListeners();}
 int get refreshSeconds=>switch(get('refreshRate')){'1s'=>1,'5s'=>5,_=>2};
}
