module.exports = {
  extends: 'airbnb-typescript-prettier',
  rules: {
    'no-underscore-dangle': ['error', { allow: ['_id', '_doc'] }],
  },
};
