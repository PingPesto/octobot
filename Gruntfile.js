module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        jshint: {
            all: ['*.js', 'scripts/*.js']
        },
        coffeelint: {
            options: {
                'max_line_length': {
                    'level': 'ignore'
                },
            },
            all: ['scripts/*.coffee']
        },
        exec: {
            hubot: 'bin/hubot -t',
            npm_purge: 'rm -rf node_modules/*',
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-exec');


    grunt.registerTask('default', ['jshint', 'coffeelint', 'exec']);
};
