SELECT 
  c.name,  
  w.wishes->>'first_choice' as primary_wish, 
  w.wishes->>'second_choice' as backup_wish,
  w.wishes->'colors'->>0 as favourite_color,
  jsonb_array_length((w.wishes -> 'colors')::jsonb) as color_count,
  CASE
    WHEN GREATEST(CAST(t1.difficulty_to_make AS INT), CAST(t2.difficulty_to_make AS INT)) = 1 THEN 'Simple Gift'
    WHEN GREATEST(CAST(t1.difficulty_to_make AS INT), CAST(t2.difficulty_to_make AS INT)) = 2 THEN 'Moderate Gift'
    ELSE 'Complex Gift'
  END AS gift_complexity,
  CASE 
    WHEN t1.category = 'outdoor' THEN 'Outside Workshop'
    WHEN t1.category = 'educational' THEN 'Learning Workshop'
    ELSE 'General Workshop'
  END AS workshop_assignment
FROM 
  wish_lists w
JOIN
  children c
ON 
  c.child_id = w.child_id
JOIN
  toy_catalogue t1
ON
  t1.toy_name = w.wishes->>'first_choice'
JOIN
  toy_catalogue t2
ON
  t2.toy_name = w.wishes->>'second_choice'
