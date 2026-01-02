const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Default error
  let error = {
    success: false,
    error: 'Internal Server Error',
    message: 'Something went wrong on the server'
  };

  // Validation error
  if (err.name === 'ValidationError') {
    error.error = 'Validation Error';
    error.message = err.message;
    return res.status(400).json(error);
  }

  // JWT error
  if (err.name === 'JsonWebTokenError') {
    error.error = 'Invalid Token';
    error.message = 'Please provide a valid token';
    return res.status(401).json(error);
  }

  // Rate limit error
  if (err.status === 429) {
    error.error = 'Too Many Requests';
    error.message = 'Rate limit exceeded. Please try again later.';
    return res.status(429).json(error);
  }

  // Custom error
  if (err.statusCode) {
    error.error = err.message;
    error.message = err.details || err.message;
    return res.status(err.statusCode).json(error);
  }

  res.status(500).json(error);
};

module.exports = {
  errorHandler
};