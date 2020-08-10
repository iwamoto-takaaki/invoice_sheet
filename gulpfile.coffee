{src, dest, watch, parallel} = require 'gulp'
del = require 'del'
pug = require 'gulp-pug'
htmlbeautify = require 'gulp-html-beautify'
plumber = require 'gulp-plumber'
notify = require　'gulp-notify'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
webserver = require 'gulp-webserver'

clean = ->
  del ['./dist/**', '!./dist']

html = ->
  src ['./src/**/*.pug', '!./src/includes/**/*.pug']
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

watcher = (cb) ->
  watch './src/', (cb) ->
    clean()
    html()
    css()
    cb()
  cb()

server = (cb) ->
  src './dist/'
  .pipe webserver {
    host: process.env.DEV_HOST || 'localhost',
    port: process.env.DEV_PORT || 8090,
    livereload: true
  }
  cb()

exports.default = parallel [watcher, server]