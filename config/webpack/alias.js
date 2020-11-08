const path = require('path')

module.exports = {
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery',
      '@src': path.resolve(__dirname, '../../app/javascript/src')
    }
  }
}
