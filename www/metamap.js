// This is a JavaScript file
var MetaMap = function(){};

MetaMap.prototype.callMetaMap = function(additionalQuery, language) {
    cordova.exec(
        function(result){console.log("success MetaMap Call result = " + result);},
        function(error){console.log("failure MetaMap Call error = " + error);},
        "CallMetaMap",
        "callMetaMap",
        [additionalQuery, language]
    );
};
var metamap = new MetaMap();
module.exports = metamap;
