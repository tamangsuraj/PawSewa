const express = require('express');
const Joi = require('joi');
const emailService = require('../services/emailService');
const { authenticateApiKey } = require('../middleware/auth');

const router = express.Router();

// Validation schemas
const sendOtpSchema = Joi.object({
  email: Joi.string().email().required(),
  purpose: Joi.string().valid('verification', 'password_reset', 'password_reset_link').default('verification'),
  userName: Joi.string().optional().default('User')
});

const verifyOtpSchema = Joi.object({
  email: Joi.string().email().required(),
  otp: Joi.string().length(parseInt(process.env.OTP_LENGTH) || 6).required()
});

// Send OTP endpoint
router.post('/send', authenticateApiKey, async (req, res) => {
  try {
    // Validate request body
    const { error, value } = sendOtpSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details[0].message
      });
    }

    const { email, purpose, userName } = value;

    // Send OTP email
    const result = await emailService.sendOtpEmail(email, purpose, userName);

    res.status(200).json({
      success: true,
      message: 'OTP sent successfully',
      data: {
        email,
        purpose,
        expiryTime: result.expiryTime,
        messageId: result.messageId
      }
    });

  } catch (error) {
    console.error('Error in /send endpoint:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to send OTP',
      message: error.message
    });
  }
});

// Verify OTP endpoint
router.post('/verify', authenticateApiKey, async (req, res) => {
  try {
    // Validate request body
    const { error, value } = verifyOtpSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details[0].message
      });
    }

    const { email, otp } = value;

    // Verify OTP
    const result = await emailService.verifyOtp(email, otp);

    if (result.success) {
      res.status(200).json({
        success: true,
        message: result.message,
        data: {
          email,
          verified: true,
          timestamp: new Date().toISOString()
        }
      });
    } else {
      res.status(400).json({
        success: false,
        error: result.error,
        data: {
          email,
          verified: false
        }
      });
    }

  } catch (error) {
    console.error('Error in /verify endpoint:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to verify OTP',
      message: error.message
    });
  }
});

// Test email connection endpoint
router.get('/test-connection', authenticateApiKey, async (req, res) => {
  try {
    const isConnected = await emailService.testConnection();
    
    res.status(200).json({
      success: true,
      connected: isConnected,
      timestamp: new Date().toISOString(),
      config: {
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT,
        from: process.env.FROM_EMAIL
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Connection test failed',
      message: error.message
    });
  }
});

// Send test email endpoint
router.post('/test-email', authenticateApiKey, async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({
        success: false,
        error: 'Email address is required'
      });
    }

    const result = await emailService.sendOtpEmail(email, 'verification');
    
    res.status(200).json({
      success: true,
      message: 'Test email sent successfully',
      data: result
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to send test email',
      message: error.message
    });
  }
});

module.exports = router;