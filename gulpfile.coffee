{src, dest, watch} = require 'gulp'
del = require 'del'
pug = require 'gulp-pug'
htmlbeautify = require 'gulp-html-beautify'
plumber = require 'gulp-plumber'
notify = require　'gulp-notify'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'

clean = ->
  del ['./dist/**', '!./dist']

html = ->
  src './src/**/*.pug'
  .pipe plumber　{ errorHandler: notify.onError　"Error: <%= error.message %>" }
  .pipe pug()
  .pipe htmlbeautify()
  .pipe dest './dist/'

css = -> 
  src './src/sass/*.sass'
  .pipe plumber　{ errorHandler: notify.onError　"Error: <%= error.message %>" }
  .pipe sass({includePaths:['node_modules/bootstrap/scss']})
  .pipe autoprefixer()　   # ベンダープレフィックスの付与
  .pipe sass { outputStyle: 'expanded' }
  # .pipe sass { ououtputStyle: 'compact' }
  .pipe dest './dist/css/'

exports.default = ->
  watch './src/', (cb) ->
    clean()
    html()
    css()
    cb()