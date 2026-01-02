const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator');

class EmailService {
  constructor() {
    this.transporter = this.createTransporter();
    this.otpStorage = new Map(); // In production, use Redis or database
  }

  createTransporter() {
    return nodemailer.createTransporter({
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT) || 587,
      secure: process.env.SMTP_SECURE === 'true',
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
      // Additional settings for better deliverability
      tls: {
        rejectUnauthorized: false
      },
      connectionTimeout: 60000,
      greetingTimeout: 30000,
      socketTimeout: 60000,
    });
  }

  generateOtp() {
    return otpGenerator.generate(parseInt(process.env.OTP_LENGTH) || 6, {
      digits: true,
      upperCaseAlphabets: false,
      lowerCaseAlphabets: false,
      specialChars: false,
    });
  }

  async sendOtpEmail(email, purpose = 'verification', userName = null) {
    try {
      const otp = this.generateOtp();
      const expiryTime = new Date(Date.now() + (parseInt(process.env.OTP_EXPIRY_MINUTES) || 10) * 60000);
      
      // Store OTP with expiry (in production, use Redis)
      this.otpStorage.set(email, {
        otp,
        expiryTime,
        purpose,
        attempts: 0,
        userName: userName || 'User'
      });

      const emailTemplate = this.getEmailTemplate(otp, purpose, userName || 'User');
      
      const mailOptions = {
        from: {
          name: process.env.FROM_NAME || 'PawSewa Team',
          address: process.env.FROM_EMAIL || process.env.SMTP_USER
        },
        to: email,
        subject: emailTemplate.subject,
        text: emailTemplate.text,
        html: emailTemplate.html,
        // Headers to improve deliverability
        headers: {
          'X-Priority': '1',
          'X-MSMail-Priority': 'High',
          'Importance': 'high'
        }
      };

      const result = await this.transporter.sendMail(mailOptions);
      
      console.log(`✅ OTP email sent to ${email}:`, result.messageId);
      
      return {
        success: true,
        messageId: result.messageId,
        expiryTime: expiryTime.toISOString()
      };
    } catch (error) {
      console.error('❌ Error sending OTP email:', error);
      throw new Error(`Failed to send OTP email: ${error.message}`);
    }
  }

  async verifyOtp(email, enteredOtp) {
    try {
      const storedData = this.otpStorage.get(email);
      
      if (!storedData) {
        return {
          success: false,
          error: 'OTP not found or expired. Please request a new one.'
        };
      }

      // Check if OTP has expired
      if (new Date() > storedData.expiryTime) {
        this.otpStorage.delete(email);
        return {
          success: false,
          error: 'OTP has expired. Please request a new one.'
        };
      }

      // Check attempt limit
      if (storedData.attempts >= (parseInt(process.env.MAX_VERIFY_ATTEMPTS) || 3)) {
        this.otpStorage.delete(email);
        return {
          success: false,
          error: 'Too many failed attempts. Please request a new OTP.'
        };
      }

      // Verify OTP
      if (storedData.otp === enteredOtp) {
        this.otpStorage.delete(email);
        return {
          success: true,
          message: 'OTP verified successfully'
        };
      } else {
        // Increment attempt count
        storedData.attempts += 1;
        this.otpStorage.set(email, storedData);
        
        return {
          success: false,
          error: `Invalid OTP. ${(parseInt(process.env.MAX_VERIFY_ATTEMPTS) || 3) - storedData.attempts} attempts remaining.`
        };
      }
    } catch (error) {
      console.error('❌ Error verifying OTP:', error);
      throw new Error(`Failed to verify OTP: ${error.message}`);
    }
  }

  getEmailTemplate(otp, purpose, userName = 'User') {
    const templates = {
      verification: {
        subject: '🔐 Your PawSewa Verification Code',
        text: `Hello ${userName},\n\nYour verification code for PawSewa is: ${otp}\n\nThis code will expire in ${process.env.OTP_EXPIRY_MINUTES || 10} minutes.\n\nIf you didn't request this code, please ignore this email.\n\nBest regards,\nThe PawSewa Team\n\nIf you have any questions, feel free to contact our support team at support@pawsewa.com`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
            <div style="background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
              <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #703418; margin: 0; font-size: 28px;">🐾 PawSewa</h1>
                <p style="color: #666; margin: 5px 0 0 0;">Premium Pet Care</p>
              </div>
              
              <h2 style="color: #333; text-align: center; margin-bottom: 20px;">Email Verification</h2>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Hello <strong>${userName}</strong>,
              </p>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Thank you for joining PawSewa. To complete your account setup, please use the verification code below:
              </p>
              
              <div style="background-color: #f8f4f0; border: 2px dashed #703418; border-radius: 8px; padding: 20px; text-align: center; margin: 25px 0;">
                <h1 style="color: #703418; font-size: 32px; margin: 0; letter-spacing: 5px; font-family: monospace;">${otp}</h1>
              </div>
              
              <p style="color: #666; font-size: 14px; text-align: center; margin: 20px 0;">
                This code will expire in <strong>${process.env.OTP_EXPIRY_MINUTES || 10} minutes</strong>
              </p>
              
              <div style="background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 20px 0;">
                <p style="color: #856404; margin: 0; font-size: 14px;">
                  <strong>Security Note:</strong> If you didn't request this verification code, please ignore this email. Never share your verification code with anyone.
                </p>
              </div>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Thank you for using <strong>PawSewa</strong>.
              </p>
              
              <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: #999; font-size: 12px; margin: 0;">
                  Best regards,<br>
                  <strong style="color: #703418;">The PawSewa Team</strong>
                </p>
                <p style="color: #999; font-size: 11px; margin: 10px 0 0 0;">
                  If you have any questions, feel free to contact our support team at <a href="mailto:support@pawsewa.com" style="color: #703418;">support@pawsewa.com</a>
                </p>
              </div>
            </div>
          </div>
        `
      },
      password_reset: {
        subject: '🔒 Reset Your PawSewa Password',
        text: `Hello ${userName},\n\nWe received a request to reset the password for your account at PawSewa.\n\nYour password reset code is: ${otp}\n\nThis code will expire in ${process.env.OTP_EXPIRY_MINUTES || 10} minutes.\n\nIf you did not request a password reset, please disregard this email. Your password will remain unchanged.\n\nThank you for using PawSewa.\n\nBest regards,\nThe PawSewa Team\n\nIf you have any questions, feel free to contact our support team at support@pawsewa.com`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
            <div style="background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
              <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #703418; margin: 0; font-size: 28px;">🐾 PawSewa</h1>
                <p style="color: #666; margin: 5px 0 0 0;">Premium Pet Care</p>
              </div>
              
              <h2 style="color: #333; text-align: center; margin-bottom: 20px;">Password Reset Request</h2>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Hello <strong>${userName}</strong>,
              </p>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                We received a request to reset the password for your account at <strong>PawSewa</strong>.
              </p>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                If you made this request, you can reset your password using the code below:
              </p>
              
              <div style="background-color: #f8f4f0; border: 2px dashed #703418; border-radius: 8px; padding: 20px; text-align: center; margin: 25px 0;">
                <h1 style="color: #703418; font-size: 32px; margin: 0; letter-spacing: 5px; font-family: monospace;">${otp}</h1>
              </div>
              
              <p style="color: #666; font-size: 14px; text-align: center; margin: 20px 0;">
                This code will expire in <strong>${process.env.OTP_EXPIRY_MINUTES || 10} minutes</strong>
              </p>
              
              <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; border-radius: 5px; padding: 15px; margin: 20px 0;">
                <p style="color: #721c24; margin: 0; font-size: 14px;">
                  <strong>Security Alert:</strong> If you did not request a password reset, please disregard this email. Your password will remain unchanged.
                </p>
              </div>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Thank you for using <strong>PawSewa</strong>.
              </p>
              
              <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: #999; font-size: 12px; margin: 0;">
                  Best regards,<br>
                  <strong style="color: #703418;">The PawSewa Team</strong>
                </p>
                <p style="color: #999; font-size: 11px; margin: 10px 0 0 0;">
                  If you have any questions, feel free to contact our support team at <a href="mailto:support@pawsewa.com" style="color: #703418;">support@pawsewa.com</a>
                </p>
              </div>
            </div>
          </div>
        `
      },
      password_reset_link: {
        subject: '🔒 Reset Your PawSewa Password',
        text: `Hello ${userName},\n\nWe received a request to reset the password for your account at PawSewa.\n\nIf you made this request, you can reset your password by clicking the link below:\n\nReset Password: https://pawsewa-25997.firebaseapp.com/__/auth/action?mode=resetPassword&oobCode=${otp}&apiKey=AIzaSyAXXtiBkFoUoBHBhGzT3ZXmHpJXK-qLzk8&lang=en\n\nThis link will expire in 24 hours.\n\nIf you did not request a password reset, please disregard this email. Your password will remain unchanged.\n\nThank you for using PawSewa.\n\nBest regards,\nThe PawSewa Team\n\nIf you have any questions, feel free to contact our support team at support@pawsewa.com`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9;">
            <div style="background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
              <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #703418; margin: 0; font-size: 28px;">🐾 PawSewa</h1>
                <p style="color: #666; margin: 5px 0 0 0;">Premium Pet Care</p>
              </div>
              
              <h2 style="color: #333; text-align: center; margin-bottom: 20px;">Password Reset Request</h2>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Hello <strong>${userName}</strong>,
              </p>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                We received a request to reset the password for your account at <strong>PawSewa</strong>.
              </p>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                If you made this request, you can reset your password by clicking the link below:
              </p>
              
              <div style="text-align: center; margin: 30px 0;">
                <a href="https://pawsewa-25997.firebaseapp.com/__/auth/action?mode=resetPassword&oobCode=${otp}&apiKey=AIzaSyAXXtiBkFoUoBHBhGzT3ZXmHpJXK-qLzk8&lang=en" 
                   target="_blank" 
                   style="display: inline-block; background-color: #703418; color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; font-size: 16px;">
                  <strong>Reset Password</strong>
                </a>
              </div>
              
              <p style="color: #666; font-size: 14px; text-align: center; margin: 20px 0;">
                This link will expire in <strong>24 hours</strong>.
              </p>
              
              <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; border-radius: 5px; padding: 15px; margin: 20px 0;">
                <p style="color: #721c24; margin: 0; font-size: 14px;">
                  <strong>Security Alert:</strong> If you did not request a password reset, please disregard this email. Your password will remain unchanged.
                </p>
              </div>
              
              <p style="color: #555; font-size: 16px; line-height: 1.6;">
                Thank you for using <strong>PawSewa</strong>.
              </p>
              
              <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                <p style="color: #999; font-size: 12px; margin: 0;">
                  Best regards,<br>
                  <strong style="color: #703418;">The PawSewa Team</strong>
                </p>
                <p style="color: #999; font-size: 11px; margin: 10px 0 0 0;">
                  If you have any questions, feel free to contact our support team at <a href="mailto:support@pawsewa.com" style="color: #703418;">support@pawsewa.com</a>
                </p>
              </div>
            </div>
          </div>
        `
      }
    };

    return templates[purpose] || templates.verification;
  }

  async testConnection() {
    try {
      await this.transporter.verify();
      console.log('✅ Email service connection verified');
      return true;
    } catch (error) {
      console.error('❌ Email service connection failed:', error);
      return false;
    }
  }
}

module.exports = new EmailService();