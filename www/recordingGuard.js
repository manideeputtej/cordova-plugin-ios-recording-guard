var exec = require('cordova/exec');

exports.checkAndHide = function(success, error) {
    exec(success, error, "ScreenRecordingGuard", "checkAndHide", []);
};