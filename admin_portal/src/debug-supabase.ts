import { supabaseAdmin } from './lib/supabase'

async function debugSupabaseConnection() {
  console.log('🔍 Debugging Supabase Connection...')
  
  // Check environment variables
  console.log('📋 Environment Variables:')
  console.log('URL:', import.meta.env.VITE_SUPABASE_URL)
  console.log('Service Key (first 20 chars):', import.meta.env.VITE_SUPABASE_SERVICE_KEY?.substring(0, 20) + '...')
  
  // Test basic connection
  try {
    console.log('\n🔗 Testing basic connection...')
    const { data, error } = await supabaseAdmin
      .from('time_slot')
      .select('count(*)', { count: 'exact', head: true })
    
    if (error) {
      console.error('❌ Connection test failed:', error)
      console.error('Error details:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
    } else {
      console.log('✅ Basic connection successful!')
      console.log('📊 Table accessible, count result:', data)
    }
  } catch (err) {
    console.error('❌ Connection test threw error:', err)
  }
  
  // Test simple query
  try {
    console.log('\n📝 Testing simple query...')
    const { data, error } = await supabaseAdmin
      .from('time_slot')
      .select('timeslot_id')
      .limit(1)
    
    if (error) {
      console.error('❌ Simple query failed:', error)
    } else {
      console.log('✅ Simple query successful!')
      console.log('📋 Sample data:', data)
    }
  } catch (err) {
    console.error('❌ Simple query threw error:', err)
  }
  
  // Test complex query (like in your working code)
  try {
    console.log('\n🔄 Testing complex query...')
    const { data, error } = await supabaseAdmin
      .from('time_slot')
      .select(`
        *,
        service (
          service_id,
          title,
          description,
          department_id,
          created_at,
          updated_at
        )
      `)
      .limit(5)
    
    if (error) {
      console.error('❌ Complex query failed:', error)
      console.error('Error details:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
    } else {
      console.log('✅ Complex query successful!')
      console.log('📊 Data count:', data?.length || 0)
      if (data && data.length > 0) {
        console.log('📋 Sample record:', data[0])
      }
    }
  } catch (err) {
    console.error('❌ Complex query threw error:', err)
  }
}

// Run the debug function
debugSupabaseConnection().catch(console.error)

export { debugSupabaseConnection }
