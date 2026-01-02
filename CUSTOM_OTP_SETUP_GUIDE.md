# 📧 Custom OTP System Setup Guide

## 🎯 **Overview**

This guide will help you set up a custom OTP (One-Time Password) system using Nodemailer for your PawSewa Flutter app. This system provides:

- **Business Email Integration** - Send emails from your own domain
- **Custom Email Templates** - Professional, branded email designs
- **Better Deliverability** - Avoid spam folders with proper SMTP configuration
- **Full Control** - Complete control over OTP generation and verification
- **Enhanced Security** - Rate limiting, attempt tracking, and expiry management

## 🛠️ **Backend Setup**

### **Step 1: Install Dependencies**

```bash
cd backend
npm install
```

This installs:
- `nodemailer` - Email sending
- `otp-generator` - OTP generation
- `express` - Web server
- `cors` - Cross-origin requests
- `helmet` - Security headers
- `express-rate-limit` - Rate limiting
- `joi` - Input validation
- `dotenv` - Environment variables

### **Step 2: Configure Environment Variables**

1. **Copy the example environment file:**
```bash
cp .env.example .env
```

2. **Edit `.env` with your email provider settings:**

#### **For Gmail Business (G Suite/Google Workspace):**
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=noreply@yourcompany.com
SMTP_PASS=your-app-password

FROM_EMAIL=noreply@pawsewa.com
FROM_NAME=PawSewa Team
```

#### **For Custom SMTP Server:**
```env
SMTP_HOST=smtp.yourdomain.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=noreply@yourdomain.com
SMTP_PASS=your-smtp-password

FROM_EMAIL=noreply@pawsewa.com
FROM_NAME=PawSewa Team
```

#### **For SendGrid:**
```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=apikey
SMTP_PASS=your-sendgrid-api-key

FROM_EMAIL=noreply@pawsewa.com
FROM_NAME=PawSewa Team
```

#### **For Mailgun:**
```env
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=postmaster@mg.yourdomain.com
SMTP_PASS=your-mailgun-smtp-password

FROM_EMAIL=noreply@pawsewa.com
FROM_NAME=PawSewa Team
```

3. **Configure other settings:**
```env
PORT=3000
NODE_ENV=production
API_KEY=your-super-secret-api-key-here
OTP_LENGTH=6
OTP_EXPIRY_MINUTES=10
MAX_OTP_REQUESTS_PER_HOUR=5
MAX_VERIFY_ATTEMPTS=3
```

### **Step 3: Test Email Configuration**

```bash
npm run test
```

This will:
- Test SMTP connection
- Send a test OTP email
- Verify email service is working

### **Step 4: Start the Server**

#### **Development:**
```bash
npm run dev
```

#### **Production:**
```bash
npm start
```

Server will run on `http://localhost:3000`

## 📱 **Flutter Integration**

### **Step 1: Update OTP Service Configuration**

Edit `lib/services/otp_service.dart`:

```dart
class OtpService {
  static const String _baseUrl = 'https://your-domain.com:3000/api/otp'; // Your server URL
  static const String _apiKey = 'your-api-key-here'; // Match your .env API_KEY
  
  // ... rest of the code
}
```

### **Step 2: Add HTTP Dependency**

Your `pubspec.yaml` already includes `http: ^1.2.0`, so you're ready to go!

### **Step 3: Integration Examples**

#### **Email Verification After Signup:**
```dart
// After Firebase signup
try {
  await authService.signUp(email: email, password: password);
  
  // Send custom OTP instead of Firebase verification
  final otpResponse = await OtpService.sendVerificationOtp(email);
  
  if (otpResponse.success) {
    // Navigate to custom OTP verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomOtpVerificationScreen(
          email: email,
          purpose: 'verification',
        ),
      ),
    );
  }
} catch (e) {
  // Handle error
}
```

#### **Password Reset with Custom OTP:**
```dart
// Instead of Firebase password reset
try {
  final otpResponse = await OtpService.sendPasswordResetOtp(email);
  
  if (otpResponse.success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomOtpVerificationScreen(
          email: email,
          purpose: 'password_reset',
        ),
      ),
    );
  }
} catch (e) {
  // Handle error
}
```

## 🌐 **Email Deliverability Setup**

### **Step 1: DNS Configuration**

#### **SPF Record:**
Add this TXT record to your domain DNS:
```
v=spf1 include:_spf.google.com ~all
```
(Replace with your email provider's SPF record)

#### **DKIM Record:**
Your email provider will give you a DKIM key to add to DNS.

#### **DMARC Record:**
```
v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com
```

### **Step 2: Reverse DNS**
Ensure your server's IP has proper reverse DNS setup.

### **Step 3: Email Content Best Practices**

✅ **Good Practices:**
- Professional subject lines
- Clear, relevant content
- Proper HTML structure
- Unsubscribe links (for marketing emails)
- Consistent sender information

❌ **Avoid:**
- ALL CAPS text
- Excessive exclamation marks
- Spam trigger words
- Misleading subject lines

## 🧪 **Testing Guide**

### **Step 1: Test Backend Endpoints**

#### **Health Check:**
```bash
curl http://localhost:3000/health
```

#### **Test Connection:**
```bash
curl -X GET http://localhost:3000/api/otp/test-connection \
  -H "X-API-Key: your-api-key"
```

#### **Send Test OTP:**
```bash
curl -X POST http://localhost:3000/api/otp/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d '{"email": "test@example.com", "purpose": "verification"}'
```

#### **Verify OTP:**
```bash
curl -X POST http://localhost:3000/api/otp/verify \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d '{"email": "test@example.com", "otp": "123456"}'
```

### **Step 2: Flutter App Testing**

1. **Update server URL** in `otp_service.dart`
2. **Test OTP sending** from signup screen
3. **Test OTP verification** with received code
4. **Test resend functionality**
5. **Test error handling** with invalid codes

### **Step 3: Postman Testing**

Import the provided Postman collection and test all endpoints.

## 🚀 **Production Deployment**

### **Step 1: Server Deployment**

#### **Using PM2 (Recommended):**
```bash
npm install -g pm2
pm2 start server.js --name "pawsewa-otp"
pm2 startup
pm2 save
```

#### **Using Docker:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### **Step 2: SSL Certificate**
Set up SSL certificate for HTTPS (required for production).

### **Step 3: Environment Security**
- Use strong API keys
- Enable firewall rules
- Set up monitoring and logging
- Regular security updates

## 📊 **Monitoring & Analytics**

### **Server Logs:**
```bash
pm2 logs pawsewa-otp
```

### **Email Delivery Monitoring:**
- Track delivery rates
- Monitor bounce rates
- Check spam folder placement
- Monitor server performance

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **SMTP Connection Failed:**
- Check SMTP credentials
- Verify firewall settings
- Test with email provider's test tools

#### **Emails Going to Spam:**
- Check SPF/DKIM/DMARC records
- Review email content
- Monitor sender reputation

#### **High Latency:**
- Optimize server resources
- Use connection pooling
- Implement caching

#### **Rate Limiting Issues:**
- Adjust rate limits in `.env`
- Implement user-specific limits
- Add retry mechanisms

## ✅ **Success Checklist**

- [ ] Backend server running successfully
- [ ] SMTP connection working
- [ ] Test emails delivered to inbox (not spam)
- [ ] Flutter app can send OTP requests
- [ ] OTP verification working
- [ ] Rate limiting functioning
- [ ] Error handling working
- [ ] DNS records configured
- [ ] SSL certificate installed
- [ ] Monitoring set up

## 🎉 **Benefits Achieved**

✅ **Professional Email Delivery** - Emails from your business domain
✅ **Better Deliverability** - Proper SMTP configuration reduces spam
✅ **Custom Branding** - Branded email templates with your logo
✅ **Enhanced Security** - Rate limiting and attempt tracking
✅ **Full Control** - Complete control over OTP process
✅ **Scalability** - Can handle high volume of emails
✅ **Analytics** - Track email delivery and verification rates

Your custom OTP system is now ready for production use! 🚀