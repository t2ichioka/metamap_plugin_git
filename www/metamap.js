// This is a JavaScript file
var MetaMap = function(){};

MetaMap.prototype.callMetaMap = function(additionalQuery, language) {
    console.log("aaaaaaaaaaaaa:callMetaMap");
    console.log("aaaaaaaaaaaaa:cordova = " + cordova);
    cordova.exec(
        function(result){alert("success MetaMap Call result = " + result);},
        function(error){alert("failure MetaMap Call error = " + error);},
        "CallMetaMap",
        "callMetaMap",
        [additionalQuery, language]
    );
};
var metamap = new MetaMap();
module.exports = metamap;
