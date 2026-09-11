// This is a JavaScript file
console.log("aaaaaaaaaaaa:MetaMap Start");
var MetaMap = function(){};
console.log("aaaaaaaaaaaa:MetaMap Init");
MetaMap.prototype.callMetaMap = function(additionalQuery, language) {
    console.log("aaaaaaaaaaaa:cordova.exec");
    cordova.exec(
        function(result){console.log("success MetaMap Call result = " + result);},
        function(error){console.log("failure MetaMap Call error = " + error);},
        "CallMetaMap",
        "callMetaMap",
        [additionalQuery, language]
    );
};
console.log("aaaaaaaaaaaa:MetaMap.prototype.callMetaMap");
var metamap = new MetaMap();
console.log("aaaaaaaaaaaa:new MetaMap()");
module.exports = metamap;
console.log("aaaaaaaaaaaa:module.exports");
