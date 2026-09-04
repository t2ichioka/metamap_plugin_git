package jst.metamap

import org.apache.cordova.CordovaPlugin
import org.apache.cordova.CallbackContext
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class CallMetaMap : CordovaPlugin() {

    // JSから呼び出されるとこのメソッドが実行される
    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        if (action == "callMetaMap") {
            var result = ""
            val additionalQuery: JSONObject = args.getJSONObject(0)
            additionalQuery.names()?.let {
                result += " additionalQuery = "
                val len = it.length()
                for(i in 0..len - 1) {
                    val name = it.get(i) as String
                    val value = additionalQuery.getString(name)
                    result += "[$name:$value]"
                }
            }
            val language: String = args.getString(1)
            result += " language = $language" 
            callbackContext.success(result)
            return true
        }
        callbackContext.error("なぜゆえかエラー")
        return false
    }
}
