# 📧 Enhanced Email Templates with User Personalization

## 🎯 **Overview**

The email templates have been enhanced to include:
- **User Name Personalization** - "Hello [User's Name]" instead of generic greetings
- **Professional Formatting** - Consistent with your provided template
- **Multiple Template Types** - Verification, Password Reset (OTP), and Password Reset (Link)
- **Support Contact** - Includes support@pawsewa.com for user assistance

## 📝 **Available Email Templates**

### **1. Email Verification Template**
```html
Hello [User's Name],

Thank you for joining PawSewa. To complete your account setup, 
please use the verification code below:

[OTP CODE]

This code will expire in 10 minutes.

If you didn't request this code, please ignore this email.

Thank you for using PawSewa.

Best regards,
The PawSewa Team

If you have any questions, feel free to contact our support team at support@pawsewa.com
```

### **2. Password Reset Template (OTP)**
```html
Hello [User's Name],

We received a request to reset the password for your account at PawSewa.

If you made this request, you can reset your password using the code below:

[OTP CODE]

This code will expire in 10 minutes.

If you did not request a password reset, please disregard this email. 
Your password will remain unchanged.

Thank you for using PawSewa.

Best regards,
The PawSewa Team

If you have any questions, feel free to contact our support team at support@pawsewa.com
```

### **3. Password Reset Template (Link)**
```html
Hello [User's Name],

We received a request to reset the password for your account at PawSewa.

If you made this request, you can reset your password by clicking the link below:

[Reset Password Button/Link]

This link will expire in 24 hours.

If you did not request a password reset, please disregard this email. 
Your password will remain unchanged.

Thank you for using PawSewa.

Best regards,
The PawSewa Team

If you have any questions, feel free to contact our support team at support@pawsewa.com
```

## 🔧 **Backend API Usage**

### **Send Verification OTP with User Name**
```bash
curl -X POST http://localhost:3000/api/otp/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d '{
    "email": "user@example.com",
    "purpose": "verification",
    "userName": "John Doe"
  }'
```

### **Send Password Reset OTP with User Name**
```bash
curl -X POST http://localhost:3000/api/otp/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d '{
    "email": "user@example.com",
    "purpose": "password_reset",
    "userName": "John Doe"
  }'
```

### **Send Password Reset Link (Firebase Style)**
```bash
curl -X POST http://localhost:3000/api/otp/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d '{
    "email": "user@example.com",
    "purpose": "password_reset_link",
    "userName": "John Doe"
  }'
```

## 📱 **Flutter Integration Examples**

### **Signup with Personalized Verification**
```dart
// In your signup screen
void _submitSignup() async {
  try {
    // Create Firebase user first
    final userCredential = await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    
    // Send personalized verification OTP
    final otpResponse = await OtpService.sendVerificationOtp(
      _emailController.text.trim(),
      userName: _nameController.text.trim(), // User's full name
    );
    
    if (otpResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomOtpVerificationScreen(
            email: _emailController.text.trim(),
            purpose: 'verification',
            userName: _nameController.text.trim(),
          ),
        ),
      );
    }
  } catch (e) {
    // Handle error
  }
}
```

### **Password Reset with User Name**
```dart
// In your forgot password screen
void _sendPasswordReset() async {
  try {
    // Get user name from Firebase or your database
    final userName = await getUserName(_emailController.text.trim());
    
    final otpResponse = await OtpService.sendPasswordResetOtp(
      _emailController.text.trim(),
      userName: userName ?? 'User',
    );
    
    if (otpResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomOtpVerificationScreen(
            email: _emailController.text.trim(),
            purpose: 'password_reset',
            userName: userName,
          ),
        ),
      );
    }
  } catch (e) {
    // Handle error
  }
}

Future<String?> getUserName(String email) async {
  // Get user name from Firebase user profile or your database
  final user = FirebaseAuth.instance.currentUser;
  return user?.displayName;
}
```

### **Enhanced AuthService Integration**
```dart
// Update your hybrid auth service
Future<SignupResult> signUpWithCustomOtp({
  required String email,
  required String password,
  required String fullName,
}) async {
  try {
    // Step 1: Create Firebase user
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Step 2: Update display name
    await userCredential.user?.updateDisplayName(fullName);
    
    // Step 3: Send personalized OTP
    final otpResponse = await OtpService.sendVerificationOtp(
      email, 
      userName: fullName, // Pass the user's name
    );
    
    if (otpResponse.success) {
      return SignupResult(
        success: true,
        user: userCredential.user,
        message: 'Account created! Please check your email for verification.',
        requiresOtpVerification: true,
      );
    } else {
      // If OTP sending fails, delete the Firebase user
      await userCredential.user?.delete();
      return SignupResult(
        success: false,
        error: 'Failed to send verification email: ${otpResponse.error}',
      );
    }
  } catch (e) {
    return SignupResult(
      success: false,
      error: 'Signup failed: $e',
    );
  }
}
```

## 🎨 **Email Template Customization**

### **Brand Colors**
- Primary: `#703418` (PawSewa brown)
- Background: `#f9f9f9` (Light gray)
- Card: `white` with shadow
- Success: `#4CAF50` (Green)
- Warning: `#FF9800` (Orange)
- Error: `#F44336` (Red)

### **Typography**
- Headers: `Arial, sans-serif`
- Body: `16px` line height `1.6`
- Code: `monospace` with letter spacing
- Small text: `12px` for footer

### **Layout**
- Max width: `600px` (mobile-friendly)
- Padding: `20px` outer, `30px` inner
- Border radius: `10px` for cards
- Box shadow: `0 2px 10px rgba(0,0,0,0.1)`

## 🔒 **Security Features**

### **Email Content Security**
- Clear security warnings
- Expiry time prominently displayed
- Instructions for unwanted emails
- Support contact for security concerns

### **Template Validation**
- User name sanitization
- HTML entity encoding
- XSS prevention
- Email format validation

## 📊 **Email Analytics**

### **Track Email Performance**
```javascript
// In your email service
const result = await this.transporter.sendMail(mailOptions);

// Log email metrics
console.log(`📧 Email sent: ${purpose} to ${email}`);
console.log(`📊 Message ID: ${result.messageId}`);
console.log(`👤 User: ${userName}`);
console.log(`⏰ Expires: ${expiryTime}`);

// Store in database for analytics
await db.collection('email_logs').add({
  email,
  purpose,
  userName,
  messageId: result.messageId,
  sentAt: new Date(),
  expiresAt: expiryTime
});
```

### **Monitor Delivery Rates**
- Track sent vs delivered emails
- Monitor bounce rates
- Check spam folder placement
- Measure open rates (if tracking pixels added)

## ✅ **Testing Checklist**

- [ ] Verification emails include user name
- [ ] Password reset emails include user name
- [ ] All templates render correctly in email clients
- [ ] Links work properly (for reset link template)
- [ ] Expiry times are accurate
- [ ] Support email link works
- [ ] Mobile responsive design
- [ ] Spam score is low
- [ ] Brand consistency maintained

## 🚀 **Production Deployment**

### **Environment Variables**
```env
# Email branding
FROM_EMAIL=noreply@pawsewa.com
FROM_NAME=PawSewa Team
SUPPORT_EMAIL=support@pawsewa.com

# Template settings
OTP_EXPIRY_MINUTES=10
RESET_LINK_EXPIRY_HOURS=24
```

### **DNS Configuration**
Ensure your domain has proper:
- SPF record for email authentication
- DKIM signature for email integrity
- DMARC policy for email security

Your enhanced email templates are now ready to provide a professional, personalized experience for your PawSewa users! 🐾✨