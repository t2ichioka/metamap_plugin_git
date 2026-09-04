// This is a JavaScript file
var MetaMap = {};

MetaMap.prototype.callMetaMap = function(additionalQuery, language) {
    cordova.exec(
        function(result){alert("success MetaMap Call result = " + result);},
        function(error){alert("failure MetaMap Call error = " + error);},
        "CallMetaMap",
        "callMetamap",
        [additionalQuery, language]
    );
};
var metamap = new MetaMap();
module.exports = metamap;
