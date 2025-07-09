const { body } = require('express-validator');

exports.validateCreateHall = [
  body('name')
    .trim()
    .escape() // removes HTML, escapes dangerous chars
    .notEmpty()
    .withMessage('Hall name is required'),

  body('location')
    .trim()
    .escape()
    .notEmpty()
    .withMessage('Location is required'),

  body('capacity')
    .toInt()
    .isInt({ min: 10 })
    .withMessage('Capacity must be a number'),

  body('description')
    .optional()
    .trim()
    .escape()
    .isLength({ max: 500 })
    .withMessage('Description too long')
];
