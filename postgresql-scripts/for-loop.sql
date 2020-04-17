CREATE OR REPLACE FUNCTION for_loop_example()
	RETURNS VOID
	LANGUAGE plpgsql
AS $function$
	DECLARE
		elem int; int_arr int[] := '{1,2,3,4,5}';
	BEGIN
		foreach elem in array int_arr
		loop
			raise notice 'elem: %', elem;
		end loop;		
	END;
$function$;

select for_loop_example();