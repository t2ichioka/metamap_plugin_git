package jst.metamap

import android.app.Activity
import android.content.Intent
import org.apache.cordova.CordovaInterface
import org.apache.cordova.CordovaPlugin
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaWebView
import org.apache.cordova.PluginResult
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class CallMetaMap : CordovaPlugin() {

    // JSから呼び出されるとこのメソッドが実行される
    @Throws(JSONException::class)
    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        System.out.println("aaaaaaaaaaaa:execute action = " + action)
        if (action == "callMetaMap") {
            var result = ""
            val jsonQuery: JSONObject = args.getJSONObject(0)
            var additionalQuery: HashMap<String, String> = HashMap<String, String>()
            jsonQuery.names()?.let {
                result += " additionalQuery = "
                val len = it.length()
                for(i in 0..len - 1) {
                    val name = it.get(i) as String
                    val value = jsonQuery.getString(name)
                    additionalQuery[name] = value
                    result += "[$name:$value]"
                }
            }
            val language: String = args.getString(1)
            System.out.println("aaaaaaaaaaaa:execute callMetaMap language = " + language)
            result += " language = $language" 
            val activity = cordova.activity
            val intent = Intent(activity.applicationContext, MetaMapActivity::class.java)
            intent.putExtra("additionalQuery", additionalQuery)
            intent.putExtra("language", language)
            activity.startActivity(intent)
            callbackContext.success(result)
            return true
        }
        callbackContext.error("なぜゆえかエラー")
        return false
    }
}
