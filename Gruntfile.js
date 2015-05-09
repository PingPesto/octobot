module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        jshint: {
            all: ['*.js', 'scripts/*.js']
        },
        coffeelint: {
            all: ['scripts/*.coffee']
        },
        exec: {
            hubot: 'bin/hubot -t',
            npm_purge: 'rm -rf node_modules/*',
            npm_clean: 'rm npm-debug*'
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-exec');

    /* Custom task to test hubot config */
    grunt.registerTask('default', ['jshint', 'coffeelint', 'exec']);
};
