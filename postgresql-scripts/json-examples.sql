CREATE OR REPLACE FUNCTION iterate_over_json_array_example(input_json JSON)
	RETURNS VOID
	LANGUAGE plpgsql
AS $function$
DECLARE
	list_json JSON := (input_json->>'list')::json;
	each_json json;
	
	list_int JSON := (input_json->>'list_int')::json;
	each_int INT;
BEGIN
	RAISE NOTICE 'list_json: %', list_json;
	FOR each_json IN SELECT * FROM json_array_elements(list_json)
	LOOP
		RAISE NOTICE 'Element: %', each_json->>'name';
	END LOOP;
	
	FOR each_int IN SELECT * FROM json_array_elements(list_int)
	LOOP
		RAISE NOTICE 'Int Element: %', each_int;
	END LOOP;
END;
$function$;

select iterate_over_json_array_example(
	'{"list": [{"name": "adam"} , {"name": "yufang"}], "list_int": [1,2,3]}');

