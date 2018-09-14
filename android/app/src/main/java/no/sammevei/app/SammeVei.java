//
//  CoronaApplication.java
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

package no.sammevei.app;

/**
 * Extends the Application class to receive Corona runtime events and to extend the Lua API.
 * <p>
 * Only one instance of this class will be created by the Android OS. It will be created before this application's
 * activity is displayed and will persist after the activity is destroyed. The name of this class must be set in the
 * AndroidManifest.xml file's "application" tag or else an instance of this class will not be created on startup.
 */


/*
private MapView mapView;

@Override
protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Mapbox.getInstance(this, "pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ");
		setContentView(R.layout.activity_main);
		mapView = (MapView) findViewById(R.id.mapView);
		mapView.onCreate(savedInstanceState);
		}
*/







public class SammeVei extends android.app.Application {
	/** Called when your application has started. */
	@Override
	public void onCreate() {
		super.onCreate();
		// Set up a Corona runtime listener used to add custom APIs to Lua.
		com.ansca.corona.CoronaEnvironment.addRuntimeListener(new SammeVei.CoronaRuntimeEventHandler());

		// Mapbox Access token
		// Mapbox.getInstance(getApplicationContext(), "pk.eyJ1Ijoib2NoZWxzZXQiLCJhIjoiY2ltbmZqbXA4MDAxdXgza3E2OW44ZzZ2NyJ9.Kgl_Fc5Gu2QnpXcvL9UXRQ");
	}
	
	/** Receives and handles Corona runtime events. */
	private class CoronaRuntimeEventHandler implements com.ansca.corona.CoronaRuntimeListener {
		/**
		 * Called after the Corona runtime has been created and just before executing the "main.lua" file.
		 * This is the application's opportunity to register custom APIs into Lua.
		 * <p>
		 * Warning! This method is not called on the main thread.
		 * @param runtime Reference to the CoronaRuntime object that has just been loaded/initialized.
		 *                Provides a LuaState object that allows the application to extend the Lua API.
		 */

		@Override
		public void onLoaded(com.ansca.corona.CoronaRuntime runtime) {
		}


		/**
		 * Called just after the Corona runtime has executed the "main.lua" file.
		 * <p>
		 * Warning! This method is not called on the main thread.
		 * @param runtime Reference to the CoronaRuntime object that has just been started.
		 */
		@Override
		public void onStarted(com.ansca.corona.CoronaRuntime runtime) {

		}
		
		/**
		 * Called just after the Corona runtime has been suspended which pauses all rendering, audio, timers,
		 * and other Corona related operations. This can happen when another Android activity (ie: window) has
		 * been displayed, when the screen has been powered off, or when the screen lock is shown.
		 * <p>
		 * Warning! This method is not called on the main thread.
		 * @param runtime Reference to the CoronaRuntime object that has just been suspended.
		 */
		@Override
		public void onSuspended(com.ansca.corona.CoronaRuntime runtime) {
		}
		
		/**
		 * Called just after the Corona runtime has been resumed after a suspend.
		 * <p>
		 * Warning! This method is not called on the main thread.
		 * @param runtime Reference to the CoronaRuntime object that has just been resumed.
		 */
		@Override
		public void onResumed(com.ansca.corona.CoronaRuntime runtime) {


		}
		
		/**
		 * Called just before the Corona runtime terminates.
		 * <p>
		 * This happens when the Corona activity is being destroyed which happens when the user presses the Back button
		 * on the activity, when the native.requestExit() method is called in Lua, or when the activity's finish()
		 * method is called. This does not mean that the application is exiting.
		 * <p>
		 * Warning! This method is not called on the main thread.
		 * @param runtime Reference to the CoronaRuntime object that is being terminated.
		 */
		@Override
		public void onExiting(com.ansca.corona.CoronaRuntime runtime) {
		}

		// ----------------------------------------------------------------------------------------- //
		/*
		@Override
		public void onStart() {
			super.onStart();
			mapView.onStart();
		}

		@Override
		public void onResume() {
			super.onResume();
			mapView.onResume();
		}

		@Override
		public void onPause() {
			super.onPause();
			mapView.onPause();
		}

		@Override
		public void onStop() {
			super.onStop();
			mapView.onStop();
		}

		@Override
		public void onLowMemory() {
			super.onLowMemory();
			mapView.onLowMemory();
		}

		@Override
		protected void onDestroy() {
			super.onDestroy();
			mapView.onDestroy();
		}

		@Override
		protected void onSaveInstanceState(Bundle outState) {
			super.onSaveInstanceState(outState);
			mapView.onSaveInstanceState(outState);
		}
		*/

		// ----------------------------------------------------------------------------------------- //
	}
}
