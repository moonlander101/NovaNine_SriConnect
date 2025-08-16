import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
};
serve(async (req)=>{
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: corsHeaders
    });
  }
  try {
    const supabase = createClient(Deno.env.get('SUPABASE_URL') ?? '', Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '', {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    });
    const url = new URL(req.url);
    const path = url.pathname.split('/').pop();
    switch(path){
      case 'send-otp':
        return await handleSendOtp(req, supabase);
      case 'verify-otp':
        return await handleVerifyOtp(req, supabase);
      case 'resend-otp':
        return await handleResendOtp(req, supabase);
      case 'register':
        return await handleRegister(req, supabase);
      case 'send-reset-otp':
        return await handleSendResetOtp(req, supabase);
      case 'verify-reset-otp':
        return await handleVerifyResetOtp(req, supabase);
      case 'reset-password':
        return await handleResetPassword(req, supabase);
      case 'profile':
        return await handleGetProfile(req, supabase);
      default:
        return new Response(JSON.stringify({
          error: 'Invalid endpoint'
        }), {
          status: 404,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json'
          }
        });
    }
  } catch (error) {
    console.error('Error:', error);
    return new Response(JSON.stringify({
      error: 'Internal server error',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
});
async function handleSendOtp(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number } = await req.json();
  if (!phone_number) {
    return new Response(JSON.stringify({
      error: 'Phone number is required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    // Format phone number for Sri Lankan numbers
    const formattedPhone = formatPhoneNumber(phone_number);
    // Send OTP using Supabase Auth
    const { data, error } = await supabase.auth.signInWithOtp({
      phone: formattedPhone,
      options: {
        shouldCreateUser: true
      }
    });
    if (error) {
      console.error('Supabase OTP error:', error);
      return new Response(JSON.stringify({
        error: 'Failed to send OTP',
        details: error.message
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      message: `OTP sent to ${formattedPhone}`,
      phone_number: formattedPhone
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Send OTP error:', error);
    return new Response(JSON.stringify({
      error: 'Failed to send OTP',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleVerifyOtp(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number, otp } = await req.json();
  if (!phone_number || !otp) {
    return new Response(JSON.stringify({
      error: 'Phone number and OTP are required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Verify OTP using Supabase Auth
    const { data, error } = await supabase.auth.verifyOtp({
      phone: formattedPhone,
      token: otp,
      type: 'sms'
    });
    if (error) {
      console.error('OTP verification error:', error);
      return new Response(JSON.stringify({
        error: 'Invalid OTP',
        details: error.message
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    if (!data.user) {
      return new Response(JSON.stringify({
        error: 'Authentication failed'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Get or create user profile
    const userProfile = await getOrCreateUserProfile(supabase, data.user.id, formattedPhone);
    if (!userProfile) {
      return new Response(JSON.stringify({
        error: 'Failed to create user profile'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Create custom JWT claims for role-based access
    const customClaims = {
      user_id: userProfile.user_id,
      role: userProfile.role,
      phone_no: userProfile.phone_no,
      full_name: userProfile.full_name
    };
    // Update user metadata with custom claims
    await supabase.auth.admin.updateUserById(data.user.id, {
      user_metadata: customClaims
    });
    return new Response(JSON.stringify({
      success: true,
      message: 'Authentication successful',
      access_token: data.session?.access_token,
      refresh_token: data.session?.refresh_token,
      user: userProfile,
      expires_at: data.session?.expires_at
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Verify OTP error:', error);
    return new Response(JSON.stringify({
      error: 'Authentication failed',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleResendOtp(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number } = await req.json();
  if (!phone_number) {
    return new Response(JSON.stringify({
      error: 'Phone number is required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Resend OTP using Supabase Auth
    const { data, error } = await supabase.auth.signInWithOtp({
      phone: formattedPhone,
      options: {
        shouldCreateUser: false
      }
    });
    if (error) {
      console.error('Resend OTP error:', error);
      return new Response(JSON.stringify({
        error: 'Failed to resend OTP',
        details: error.message
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      message: `OTP resent to ${formattedPhone}`
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Resend OTP error:', error);
    return new Response(JSON.stringify({
      error: 'Failed to resend OTP',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleGetProfile(req, supabase) {
  if (req.method !== 'GET') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    // Get user from JWT token
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({
        error: 'Authorization header required'
      }), {
        status: 401,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    const token = authHeader.replace('Bearer ', '');
    const { data: user, error } = await supabase.auth.getUser(token);
    if (error || !user) {
      return new Response(JSON.stringify({
        error: 'Invalid token'
      }), {
        status: 401,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Get user profile from database
    const { data: profile, error: profileError } = await supabase.from('app_user').select('user_id, full_name, phone_no, email, role, nic_no, created_at, updated_at').eq('phone_no', user.user.phone).single();
    if (profileError) {
      console.error('Profile fetch error:', profileError);
      return new Response(JSON.stringify({
        error: 'Failed to fetch profile'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      user: profile
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    return new Response(JSON.stringify({
      error: 'Failed to get profile',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleRegister(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number, full_name, email, nic_no, role = 'Citizen' } = await req.json();
  if (!phone_number || !full_name) {
    return new Response(JSON.stringify({
      error: 'Phone number and full name are required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Check if user already exists
    const { data: existingUser } = await supabase.from('app_user').select('user_id').eq('phone_no', formattedPhone).single();
    if (existingUser) {
      return new Response(JSON.stringify({
        success: false,
        error: 'User with this phone number already exists'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Create user profile first
    const { data: newUser, error: createError } = await supabase.from('app_user').insert({
      full_name,
      phone_no: formattedPhone,
      email: email || null,
      nic_no: nic_no || null,
      role
    }).select('user_id').single();
    if (createError) {
      console.error('User creation error:', createError);
      return new Response(JSON.stringify({
        success: false,
        error: 'Failed to create user profile'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Send OTP for phone verification
    const { data, error } = await supabase.auth.signInWithOtp({
      phone: formattedPhone,
      options: {
        shouldCreateUser: true
      }
    });
    if (error) {
      console.error('Registration OTP error:', error);
      return new Response(JSON.stringify({
        success: false,
        error: 'Failed to send verification OTP'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      message: 'Registration successful! OTP sent to your phone number.'
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    return new Response(JSON.stringify({
      success: false,
      error: 'Registration failed',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleSendResetOtp(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number } = await req.json();
  if (!phone_number) {
    return new Response(JSON.stringify({
      error: 'Phone number is required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Check if user exists
    const { data: user } = await supabase.from('app_user').select('user_id').eq('phone_no', formattedPhone).single();
    if (!user) {
      return new Response(JSON.stringify({
        success: false,
        error: 'No account found with this phone number'
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Send reset OTP
    const { data, error } = await supabase.auth.signInWithOtp({
      phone: formattedPhone,
      options: {
        shouldCreateUser: false
      }
    });
    if (error) {
      console.error('Reset OTP error:', error);
      return new Response(JSON.stringify({
        success: false,
        error: 'Failed to send reset OTP'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      message: 'Password reset OTP sent successfully'
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Send reset OTP error:', error);
    return new Response(JSON.stringify({
      success: false,
      error: 'Failed to send reset OTP',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleVerifyResetOtp(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number, otp } = await req.json();
  if (!phone_number || !otp) {
    return new Response(JSON.stringify({
      error: 'Phone number and OTP are required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Verify OTP with Supabase Auth
    const { data, error } = await supabase.auth.verifyOtp({
      phone: formattedPhone,
      token: otp,
      type: 'sms'
    });
    if (error) {
      console.error('Reset OTP verification error:', error);
      return new Response(JSON.stringify({
        success: false,
        error: 'Invalid or expired OTP'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Generate a reset token (simple timestamp-based token for demo)
    const resetToken = btoa(`${formattedPhone}:${Date.now()}:reset`);
    return new Response(JSON.stringify({
      success: true,
      message: 'OTP verified successfully',
      reset_token: resetToken
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Verify reset OTP error:', error);
    return new Response(JSON.stringify({
      success: false,
      error: 'OTP verification failed',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function handleResetPassword(req, supabase) {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({
      error: 'Method not allowed'
    }), {
      status: 405,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  const { phone_number, new_password, reset_token } = await req.json();
  if (!phone_number || !new_password || !reset_token) {
    return new Response(JSON.stringify({
      error: 'Phone number, new password, and reset token are required'
    }), {
      status: 400,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
  try {
    const formattedPhone = formatPhoneNumber(phone_number);
    // Verify reset token (decode and validate)
    let decodedToken;
    try {
      decodedToken = atob(reset_token);
      const [tokenPhone, timestamp, action] = decodedToken.split(':');
      if (tokenPhone !== formattedPhone || action !== 'reset') {
        throw new Error('Invalid token');
      }
      // Check if token is not older than 10 minutes
      const tokenTime = parseInt(timestamp);
      const now = Date.now();
      if (now - tokenTime > 10 * 60 * 1000) {
        throw new Error('Token expired');
      }
    } catch (error) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Invalid or expired reset token'
      }), {
        status: 400,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Get user's auth_user_id
    const { data: userAuth } = await supabase.from('user_auth').select(`
        auth_user_id,
        app_user:user_id (
          user_id,
          phone_no
        )
      `).eq('app_user.phone_no', formattedPhone).single();
    if (!userAuth) {
      return new Response(JSON.stringify({
        success: false,
        error: 'User not found'
      }), {
        status: 404,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    // Update password in Supabase Auth
    const { error: updateError } = await supabase.auth.admin.updateUserById(userAuth.auth_user_id, {
      password: new_password
    });
    if (updateError) {
      console.error('Password update error:', updateError);
      return new Response(JSON.stringify({
        success: false,
        error: 'Failed to update password'
      }), {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      });
    }
    return new Response(JSON.stringify({
      success: true,
      message: 'Password reset successfully'
    }), {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  } catch (error) {
    console.error('Reset password error:', error);
    return new Response(JSON.stringify({
      success: false,
      error: 'Password reset failed',
      details: error.message
    }), {
      status: 500,
      headers: {
        ...corsHeaders,
        'Content-Type': 'application/json'
      }
    });
  }
}
async function getOrCreateUserProfile(supabase, authUserId, phoneNumber) {
  try {
    // Check if user profile exists
    const { data: existingUser, error: fetchError } = await supabase.from('app_user').select('user_id, full_name, phone_no, email, role').eq('phone_no', phoneNumber).maybeSingle();
    if (existingUser) {
      // Update user_auth mapping if needed
      await supabase.from('user_auth').upsert({
        user_id: existingUser.user_id,
        auth_user_id: authUserId
      }, {
        onConflict: 'auth_user_id'
      });
      return existingUser;
    }
    // Create new user profile
    const { data: newUser, error: createError } = await supabase.from('app_user').insert({
      full_name: 'User',
      phone_no: phoneNumber,
      role: 'Citizen'
    }).select('user_id, full_name, phone_no, email, role').single();
    if (createError) {
      console.error('User creation error:', createError);
      return null;
    }
    // Create user_auth mapping
    await supabase.from('user_auth').insert({
      user_id: newUser.user_id,
      auth_user_id: authUserId
    });
    return newUser;
  } catch (error) {
    console.error('Get or create user profile error:', error);
    return null;
  }
}
function formatPhoneNumber(phoneNumber) {
  // Remove all non-digits
  let digits = phoneNumber.replace(/\D/g, '');
  // Handle Sri Lankan phone numbers
  if (!digits.startsWith('94')) {
    if (digits.startsWith('0')) {
      digits = '94' + digits.substring(1);
    } else {
      digits = '94' + digits;
    }
  }
  return '+' + digits;
}
