const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://zugpozkuhpyatuwhycyp.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1Z3Bvemt1aHB5YXR1d2h5Y3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY3MTQyNDAsImV4cCI6MjEwMjI5MDI0MH0.0YJLRebSb04gBo3Nvj16x3KYGEEAvD1T4HGkjm2WmUY';

const supabase = createClient(supabaseUrl, supabaseKey);

async function run() {
  const email = 'pandeyarpit8395@gmail.com';
  console.log(`Searching for student profile with email: ${email}...`);
  
  const { data: profile, error: findError } = await supabase
    .from('profiles')
    .select('*')
    .eq('email', email)
    .maybeSingle();

  if (findError) {
    console.error('Error finding profile:', findError);
    return;
  }

  if (!profile) {
    console.log(`Profile for ${email} not found. Creating a test profile row...`);
    const { data: newProfile, error: insertError } = await supabase
      .from('profiles')
      .insert({
        id: 'c8cbdfd2-972c-47bc-96be-8c50d4fdb999', // temporary UUID for testing
        email: email,
        full_name: 'Arpit Pandey',
        team_name: 'Transformer',
        survey_completed: true
      })
      .select()
      .single();
    
    if (insertError) {
      console.error('Error creating profile:', insertError);
    } else {
      console.log('Successfully created profile:', newProfile);
    }
    return;
  }

  console.log('Found profile:', profile);
  console.log('Updating profile to assign team: Transformer...');

  const { data: updatedProfile, error: updateError } = await supabase
    .from('profiles')
    .update({
      team_name: 'Transformer',
      survey_completed: true
    })
    .eq('email', email)
    .select()
    .single();

  if (updateError) {
    console.error('Error assigning team:', updateError);
  } else {
    console.log('Successfully assigned team. Updated profile:', updatedProfile);
  }
}

run();
