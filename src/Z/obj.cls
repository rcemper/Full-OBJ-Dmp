/// Extended Object Dump
/// including output to %Stream
Class Z.obj
{
/// <pre>    
/// fill result into a prepared Stream
/// I:  outputStream = target for the result
///     sourceObject = object to be dumped
///     fullDump = 0 : show only properties with content
///              = 1 : show also empty a and private properties
///    drilldownLimit = 0  no drilldown
///                   = 1..n  max. levelof drilldown
///                   < 0   unlimitted drilldown
/// </pre>   
ClassMethod dumpToStream(
	outputStream As %Stream.Object = "",
	sourceObject As %RegisteredObject = "",
	fullDump As %Boolean = 0,
	drilldownLimit As %Integer = -1) As %Status
{
    New %tempStream
    set %tempStream=##class(%Stream.TmpCharacter).%New()
    do ..dump(sourceObject,fullDump,drilldownLimit)
    set sc=outputStream.CopyFrom(%tempStream)
    quit sc
}
/// <pre>    
/// WRITE result to current device
/// I:  sourceObject = object to be dumped
///     fullDump = 0 : show only properties with content
///              = 1 : show also empty and private properties
///    drilldownLimit = 0  no drilldown
///                   = 1..n  max. level of drilldown
///                   < 0   unlimitted drilldown
/// </pre>   
ClassMethod dumpToDevice(
	sourceObject As %RegisteredObject = "",
	fullDump As %Boolean = 0,
	drilldownLimit As %Integer = -1)
{
    New %tempStream
    set %tempStream=##class(%Stream.TmpCharacter).%New()
    do ..dump(sourceObject,fullDump,drilldownLimit)
    set maxProperty=0
    do %tempStream.Rewind()
    while '%tempStream.AtEnd  {
        set length=$length($piece(%tempStream.ReadLine(),":"))
        if length>maxProperty set maxProperty=length
        }
    do %tempStream.Rewind()
    set maxProperty=maxProperty+2
    while '%tempStream.AtEnd  {
        set line=%tempStream.ReadLine()
            ,property=$p(line,":")
            ,$p(line,":",1)=$e(property_$tr($j("",maxProperty)," ","."),1,maxProperty)
        write line,!
    }    
   quit $$$OK
}
/// <pre>    
/// fill result into a temorary Stream
/// I:  sourceObject = object to be dumped
///     outputStream = target for the result
///     fullDump = 0 : show only properties with content
///              = 1 : show also empty and private properties
///    drilldownLimit = 0  no drilldown
///                   = 1..n  max. levelof drilldown
///                   < 0   unlimitted drilldown
///    displayName = property name shown
///    classname   = class name for display 
/// </pre>   
ClassMethod dump(
	sourceObject As %RegisteredObject = "",
	fullDump As %Boolean = 0,
	drilldownLimit As %Integer = -1,
	displayName = "",
	className = "") [ Internal, Private ]
{
#dim %tempStream as %Stream.TmpCharacter    
    if $g(%tempStream),%tempStream.%IsA("%Stream.Object")
    else  set %tempStream=##class(%Stream.TmpCharacter).%New()
    if 'drilldownLimit do ..show(displayName,sourceObject) quit
    if '$isobject(sourceObject) do ..show(displayName,sourceObject) quit
    set class=##class(%Dictionary.CompiledClass).%OpenId(sourceObject.%ClassName(1),0)
    if class.Name=className do ..show(displayName,"reverse Reference ---> "_sourceObject) quit
    set displayName=displayName_$extract(".",displayName]"") 
    set:className="" className=class.Name
        
    for i=1:1:class.Properties.Count() {
        set property=class.Properties.GetAt(i)
        set propertyName=property.Name
            ,collectionType=property.Collection
        if property.Private {
            do:fullDump ..show("("_propertyName_")","<private>") 
            continue   
            }    
        if property.MultiDimensional {
            do:$data(@("sourceObject."_propertyName)) ..multiDim($name(@("sourceObject."_propertyName)),propertyName) 
            continue
            } 
        set value=$zobjproperty(sourceObject,propertyName)
        if property.Relationship,"parent,one"[property.Cardinality {
            do ..dump(value,0,1,propertyName)  ; drilldown= 1 prevents endless reference
            continue 
            }
        if collectionType="" {
            do:value]""!fullDump ..dump(value,fullDump,drilldownLimit-1,displayName_propertyName,className) 
            continue 
            }
        if collectionType="list" {
            do:'value.Count()&fullDump ..dump("",0,drilldownLimit-1,displayName_propertyName_"()",) 
            for j=1:1:value.Count() {
                do ..dump(value.GetAt(j),fullDump,drilldownLimit-1,displayName_propertyName_"("_j_")",className)
            }
        }
        if collectionType="array" { 
            do:value.Next("")=""&fullDump ..dump("",0,drilldownLimit-1,displayName_propertyName_"()",) 
            set j="" 
            for  {
                set j=value.Next(j) quit:j=""  
                do ..dump(value.GetAt(j),fullDump,drilldownLimit-1,displayName_propertyName_"("_j_")")
            }
        }
    }
}

/// <pre>
/// compose property: value pair and collect in stream
/// make controls visible
/// make $LB() readable
/// I: property =  name for display
///    value = value of property
/// </pre>
ClassMethod show(
	property As %String = "",
	value As %String = "",
	drilldownLimit As %Integer = -1) As %String [ Internal, Private ]
{
#dim %tempStream as %Stream.TmpCharacter
        if value]"",$listvalid(value) 
                { 
                    do ..lbDump(value,property,drilldownLimit) 
                    set value="`$lb()`"
                } 
       else  {
             if value?.e1c.e 
                {
                for i=$length(value):-1:1 {
                    if $extract(value,i)?1c set $extract(value,i)="`$c("_$ascii(value,i)_")`" 
                    }
                }  
            }
        
        do %tempStream.WriteLine(property_": "_value) quit
    quit
}

/// <pre>
/// make a Dump of $LB()
/// I:  list = the $lb() to be dumped
///     displayName = Property name
///     drillddowLimit
/// </pre>
ClassMethod lbDump(
	list As %List = "",
	displayName As %String = "$lb()",
	drilldownLimit As %Integer = -1) [ Internal, Private ]
{
    set:drilldownLimit drilldownLimit=drilldownLimit-1
    set itemName=displayName_"."
    if '$listvalid(list) do ..show(displayName,list) quit
    for itemId=1:1:$listlength(list) {
        if '$listdata(list,itemId) {
            do ..show(itemName_itemId,"<NULL>") 
            continue 
            }
        set itemValue=$list(list,itemId)
        if itemValue=""||'$listvalid(itemValue) {
            do ..show(itemName_itemId,itemValue) 
            continue  
            } 
        if drilldownLimit {
            do ..lbDump(itemValue,itemName_itemId,drilldownLimit-1)  
            }
        else  {
            do ..show(itemName_itemId,$select($listvalid(itemValue):"$lb("_$listtostring(itemValue)_")",1:itemValue))  
            }
    }
    quit
}
/// <pre>
/// drill into multidimensional property
/// I: sourceProperty = property to be analyzed
///    propertyName   = name of sourceProperty
/// </pre>
ClassMethod multiDim(
	sourceProperty As %String,
	propertyName As %String) [ Internal, Private ]
{
    if $data(@sourceProperty)#10 do ..show(propertyName,@sourceProperty)
    set subscr=""
    for  {
        set subscr=$order(@sourceProperty@(subscr)) quit:subscr=""  
        do ..multiDim($name(@sourceProperty@(subscr)),$name(@propertyName@(subscr)))
    }
  quit
}
}
