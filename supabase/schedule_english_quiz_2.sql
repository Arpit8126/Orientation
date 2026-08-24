-- SQL Query to schedule the English Grammar & Error Correction Quiz - Set 2
DELETE FROM public.quizzes WHERE title = 'English Grammar & Error Correction - Set 2';

INSERT INTO public.quizzes (
  title, 
  description, 
  creator_id, 
  is_teacher_quiz, 
  scope, 
  university_id, 
  difficulty, 
  required_inputs, 
  questions, 
  start_time, 
  end_time, 
  time_limit
) VALUES (
  'English Grammar & Error Correction - Set 2',
  'Set 2 of the English Grammar & Error Correction challenge containing 10 curated questions testing action verbs, double negatives, definite articles, parallelism, prepositions, and causative verbs.',
  '82d33ae3-f8f3-4ce6-bcf9-49acb05e9c55'::uuid,
  false,
  'all',
  'bed777fc-ed74-45b8-be38-1fd87e5d222d'::uuid,
  'easy',
  '["Full Name"]'::jsonb,
  '[{"question_text":"He was looking impatient (A) / at the unwanted visitor (B) / who showed (C) / no signs of leaving the room. (D)","options":["A","B","C","D"],"correct_option_index":0,"option_explanations":["In this context, \"looking\" acts as an action verb meaning to direct one''s gaze. Action verbs must be modified by an adverb rather than an adjective. Therefore, \"impatient\" should be changed to the adverb \"impatiently\".","","",""]},{"question_text":"After going (A) / to my room I sat down (B) / contentedly sometimes reading (C) / but most of the time not doing nothing. (D)","options":["A","B","C","D"],"correct_option_index":3,"option_explanations":["","","","This sentence contains a double negative (\"not doing nothing\"). To make it grammatically correct, the negative pronoun \"nothing\" must be replaced with the assertive pronoun \"anything\" to read \"...not doing anything.\""]},{"question_text":"We should drink (A) / several glasses of the water (B) / daily (C) / if we want to remain healthy. (D)","options":["A","B","C","D"],"correct_option_index":1,"option_explanations":["","The definite article \"the\" is used to refer to a specific item. Because this sentence refers to water as a general substance, \"the\" should be omitted. The correct phrase is simply \"several glasses of water\".","",""]},{"question_text":"The soldier said firmly (A) / that he would rather starve (B) / than stealing (C) / to get what he needed. (D)","options":["A","B","C","D"],"correct_option_index":2,"option_explanations":["","","The construction \"would rather... than...\" requires structural parallelism. Because the bare infinitive (base form) verb \"starve\" follows \"would rather\", the bare infinitive \"steal\" must follow \"than\" instead of the gerund \"stealing\".",""]},{"question_text":"These vegetables which are grown (A) / here are (B) / cheap in (C) / cost and rich of vitamins. (D)","options":["A","B","C","D"],"correct_option_index":3,"option_explanations":["","","","The adjective \"rich\" pairs with the fixed preposition \"in\" when indicating an abundance of a specific quality. Therefore, \"rich of vitamins\" must be corrected to \"rich in vitamins\"."]},{"question_text":"The orphanages in (A) / the thickly populated cities in India they are (B) / founded by (C) / generous donors. (D)","options":["A","B","C","D"],"correct_option_index":1,"option_explanations":["","The pronoun \"they\" in part B is completely redundant because the subject of the sentence, \"The orphanages\", has already been explicitly stated. Removing \"they\" corrects the sentence structure.","",""]},{"question_text":"I object to (A) / war not because it drains (B) / economy but that (C) / it seems inhuman. (D)","options":["A","B","C","D"],"correct_option_index":2,"option_explanations":["","","The sentence establishes a parallel explanation using the structure \"not because... but...\". To maintain perfect balance, \"but that\" should be replaced with \"but because\".",""]},{"question_text":"Whom (A) / do you plan to invite (B) / to your party besides (C) / Mr. Rao and I? (D)","options":["A","B","C","D"],"correct_option_index":3,"option_explanations":["","","","The word \"besides\" functions as a preposition here. Prepositions require objective case pronouns rather than subjective ones. Therefore, the subjective pronoun \"I\" must be replaced with the objective pronoun \"me\" (\"besides Mr. Rao and me\")."]},{"question_text":"Between you and I (A) / he probably (B) / won''t come at all. (C) / No Error. (D)","options":["A","B","C","D"],"correct_option_index":0,"option_explanations":["The word \"Between\" is a preposition, and objects of prepositions must always be in the objective case. While \"you\" can be both a subject and an object, \"I\" is strictly a subject pronoun. It must be replaced with the objective pronoun \"me\" (\"Between you and me\").","","",""]},{"question_text":"Riots, however, did not cease (A) / to depress him (B) / and make him turn to non–violence. (C) / No Error. (D)","options":["A","B","C","D"],"correct_option_index":2,"option_explanations":["","","The causative verb \"make\" is a regular active-voice verb that is followed by a bare infinitive (the base verb without \"to\"). Therefore, \"to turn\" must be changed to simply \"turn\" (\"make him turn to non-violence\"). Note: The original text had \"make him to turn\", which has been corrected here.",""]}]'::jsonb,
  '2026-07-14T11:00:00+05:30'::timestamptz,
  '2026-07-14T11:05:00+05:30'::timestamptz,
  5
);
