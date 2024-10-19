/// @description (Old DnD) - if variable evauation
/// @param val1  value to check against
/// @param val2  value2 to check against
/// @param type	type of check (1=='<', 2=='>', 3=='<=', 4=='>='anything else is ==)
function action_if_variable(val1, val2, type) {
	var ret = false;
	switch( type )
	{
		case 1:	ret = (val1 < val2); break;	
		case 2:	ret = (val1 > val2); break;	
		case 3:	ret = (val1 <= val2); break;	
		case 4:	ret = (val1 >= val2); break;	
		default:ret = (val1 == val2); break;	
	}
	return ret;


}
