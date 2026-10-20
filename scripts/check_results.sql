-- Fail if the expected learning outcomes differ from the saved results.
DO $$ BEGIN
    IF (SELECT COUNT(*) FROM week01.students) <> 3 THEN RAISE EXCEPTION 'Week 1 row count'; END IF;
    IF (SELECT COUNT(*) FROM week03.students) <> 2 THEN RAISE EXCEPTION 'Week 3 row count'; END IF;
    IF (SELECT name FROM week04.students WHERE name='Timur') IS DISTINCT FROM 'Timur' THEN RAISE EXCEPTION 'Week 4 filter'; END IF;
    IF (SELECT array_agg(name ORDER BY name) FROM week04.students) <> ARRAY['Alymbek','Beka','Timur']::varchar[] THEN RAISE EXCEPTION 'Week 4 sorting'; END IF;
    IF (SELECT COUNT(*) FROM week05.database_events WHERE verified) <> 3 THEN RAISE EXCEPTION 'Week 5 lifecycle'; END IF;
    IF (SELECT COUNT(*) FROM week06.constraint_checks WHERE result='PASS') <> 3 THEN RAISE EXCEPTION 'Week 6 constraints'; END IF;
    IF (SELECT COUNT(*) FROM week07.key_checks WHERE result='PASS') <> 4 THEN RAISE EXCEPTION 'Week 7 keys'; END IF;
    IF (SELECT COUNT(*) FROM week08.relationship_checks WHERE result='PASS') <> 8 THEN RAISE EXCEPTION 'Week 8 relationships'; END IF;
    IF (SELECT COUNT(*) FROM week08.students) <> 3 THEN RAISE EXCEPTION 'Week 8 preserved students'; END IF;
    RAISE NOTICE 'All eight lab result checks passed';
END $$;
