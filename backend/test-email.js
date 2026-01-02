require('dotenv').config();
const emailService = require('./services/emailService');

async function testEmailService() {
  console.log('🧪 Testing Email Service...\n');

  try {
    // Test connection
    console.log('1. Testing SMTP connection...');
    const isConnected = await emailService.testConnection();
    console.log(`   Connection status: ${isConnected ? '✅ Connected' : '❌ Failed'}\n`);

    if (!isConnected) {
      console.log('❌ Cannot proceed with email tests - connection failed');
      return;
    }

    // Test OTP generation and sending
    console.log('2. Testing OTP generation and email sending...');
    const testEmail = 'test@example.com'; // Replace with your test email
    
    console.log(`   Sending OTP to: ${testEmail}`);
    const result = await emailService.sendOtpEmail(testEmail, 'verification');
    console.log(`   ✅ Email sent successfully!`);
    console.log(`   Message ID: ${result.messageId}`);
    console.log(`   Expires at: ${result.expiryTime}\n`);

    // Test OTP verification (simulate)
    console.log('3. Testing OTP verification...');
    console.log('   Note: Check your email for the OTP and test verification manually');
    console.log('   Use the /api/otp/verify endpoint with the received OTP\n');

    console.log('✅ Email service test completed successfully!');
    console.log('\n📧 Check your email inbox for the test OTP email');

  } catch (error) {
    console.error('❌ Email service test failed:', error.message);
    console.error('Full error:', error);
  }
}

// Run the test
testEmailService();