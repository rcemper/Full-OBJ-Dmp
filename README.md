## Full-OBJ-Dump
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2FFull-OBJ-Dump&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2FFull-OBJ-Dump) 

During testing your code you are are often confronted with the need to examine  
the actual content of an object. Either using ZWRITE or $system.OBJ.Dump()  
you get a picture of simple properties as "--- attribute values ---"   
while "--- swizzled references ---" are more confusing than informative    
and with "--- calculated references ---" you are just left in the lurch.  
  
This small helper class allows you to dump an object to terminal or  
e.g in background to some stream for later review.     
By default you see just properties with content,  
.   DO ##class(Z.obj).dumpToDevice(obj)  
or if explicitly requested all properties.  
.    DO ##class(Z.obj).dumpToDevice(obj,1)  

Similar is the output to stream     
.   DO ##class(Z.obj).dumpToStream(.outstream,obj)  

[Article in DC](https://community.intersystems.com/post/more-usefull-object-dump)     

[Demo Server SMP](https://full-obj-dump.demo.community.intersystems.com/csp/sys/UtilHome.csp)   
[Demo Server WebTerminal](https://full-obj-dump.demo.community.intersystems.com/terminal/)    
        
**Code Quality**   
<img width="85%" src="https://openexchange.intersystems.com/mp/img/packages/1764/screenshots/8oyru9ltkwkagumlgfnfi75qto.jpg">
