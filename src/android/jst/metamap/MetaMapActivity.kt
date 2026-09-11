package jst.metamap

import android.app.Activity
import android.os.Bundle
import android.view.MenuItem
import jp.metamaps.mapview.MetamapMapView
import jp.metamaps.mapview.MetamapMapViewConfiguration
import jp.metamaps.mapview.MetamapMapViewEvent
import jp.metamaps.mapview.MapViewLoadState
import jp.metamaps.mapview.MapViewPositioningPolicy
import jp.metamaps.mapview.MapViewPositioningStartTrigger
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class MetaMapActivity : Activity() {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private lateinit var mapView: MetamapMapView
    private var isMapReady = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        actionBar?.setDisplayHomeAsUpEnabled(true)
        actionBar?.title="メタマップ"
        mapView = MetamapMapView(this).apply {
            val additionalQuery =
                intent.getSerializableExtra("additionalQuery", HashMap::class.java) as HashMap<String, String>
            val language = intent.getStringExtra("language")
            configure(MetamapMapViewConfiguration(
                mapSlug = "miraikan",
                 language = language,
                 positioningPolicy = MapViewPositioningPolicy.DISABLED,

                 positioningStartTrigger = MapViewPositioningStartTrigger.USER_ACTION,
                additionalQuery = additionalQuery
            ))
            eventListener = { event ->
                when (event) {
                    is MetamapMapViewEvent.Ready -> isMapReady = true
                    is MetamapMapViewEvent.LoadState -> {
                        if (event.state == MapViewLoadState.LOADING) isMapReady = false
                    }
                    is MetamapMapViewEvent.Error -> {
                        // エラー内容をアプリの回復UIへ渡す。
                    }
                    else -> Unit
                }
            }
        }
        setContentView(mapView)
        scope.launch {
            try {
                mapView.load()
            } catch (cancellation: CancellationException) {
                throw cancellation
            } catch (error: Throwable) {
                // エラー内容をアプリの回復UIへ渡す。
            }
        }
    }

    override fun onDestroy() {
        scope.cancel()
        mapView.dispose()
        isMapReady = false
        super.onDestroy()
    }

    override fun onMenuItemSelected(featureId: Int, item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> {
                finish()
                return true
            }
        }
        return super.onMenuItemSelected(featureId, item)
    }
}