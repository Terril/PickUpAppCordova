
/** Auto-generated url.js */
var REDIRECT_URI = false;
var IS_NATIVE_APP = true;
var DEVICE_TYPE = 2;
window.location.hash = window.location.hash.replace(/\?__goto__=(.*)/, "");
var CURRENT_LANGUAGE = AVAILABLE_LANGUAGES.indexOf(language) >= 0 ? language : 'en';

// WebView
if (typeof IS_PREVIEW === 'undefined' ||
    (typeof IS_PREVIEW !== 'undefined' && IS_PREVIEW !== true)) {
    PROTOCOL = 'http://';
    DOMAIN = 'http://nyotaride.com';
    APP_KEY = 'overview';
    BASE_PATH = '/'+APP_KEY;
}

var BASE_URL = DOMAIN + BASE_PATH;
var IMAGE_URL = DOMAIN + '/';