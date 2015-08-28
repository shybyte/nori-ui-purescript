var gulp = require('gulp'),
    shell = require('gulp-shell'),
    browserSync = require('browser-sync')

gulp.task('compile', shell.task([
  'pulp browserify --to app.js'
]))

gulp.task('watch', function () {
  browserSync({
    open: false,
    port: 3020,
    ui: {
      port: 3021
    },
    server: {
      baseDir: [".", "public"],
    }
  });
  gulp.watch('src/**/*.purs', ['compile', browserSync.reload]);
  gulp.watch(['public/styles/*.css', 'public/*.html'], browserSync.reload);
});

gulp.task('default', ['compile','watch']);