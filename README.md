 ~~~
 This is a coding example working on IRIS 2020.1 and on Caché 2018.1.3 
 It will not be kept in sync with new versions      
~~~ 
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

[Demo Server SMP](https://obj-dump.demo.community.intersystems.com/csp/sys/UtilHome.csp)   
[Demo Server WebTerminal](https://obj-dump.demo.community.intersystems.com/terminal/)    
        
**Code Quality**   
<img width="85%" src="https://openexchange.intersystems.com/mp/img/packages/1764/screenshots/8oyru9ltkwkagumlgfnfi75qto.jpg">
