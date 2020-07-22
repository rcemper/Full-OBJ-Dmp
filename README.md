 ~~~
 This is a coding example working on IRIS 2020.1 and on Caché 2018.1.3 
 It will not be kept in sync with new versions      
 It is also NOT serviced by InterSystems Support !   
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
