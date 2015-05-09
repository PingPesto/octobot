module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        jshint: {
            all: ['*.js', 'scripts/*.js']
        },
        coffeelint: {
            all: ['scripts/*.coffee']
        },
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-coffeelint');

    grunt.registerTask('default', ['jshint', 'coffeelint']);
};
