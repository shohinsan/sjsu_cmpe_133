# Passenger Documentation

Required plugins to install:

1. flutter pub add firebase_core
2. flutter pub add firebase_auth
3. flutter pub add firebase_database
4. flutter pub add fluttertoast
5. flutter pub add geolocator
6. flutter pub add google_maps_flutter
7. flutter pub add http
8. flutter pub add provider
9. flutter pub add flutter_polyline_points
10. flutter pub add flutter_geofire
11. flutter pub add firebase_messaging
12. flutter pub add smooth_star_rating_nsafe 
13. flutter pub add animated_text_kit 
14. flutter pub add intl


Required assets to add:

- images/car_android.png
- images/car_ios.png
- images/carpool.png
- images/carpool1.png
- images/desticon.png
- images/desticon1.png
- images/logo.png
- images/logo-large.png
- images/main-screen.png
- images/pickicon.png
- images/pickmarker.png
- images/posimarker.png
- images/posimarker1.png
- images/redmarker.png
- images/user_icon.png
- images/destination.png
- images/origin.png
- images/car_logo.png

# How to install plugins

### Example

* Step 1: Open command line
* Step 2: In command line type: flutter pub add [insert plugin name]
* Continue step 2 until you have downloaded all 14 plugins

# How to add assets

### Example
* Step 1: Create images folder under the project structure
* Step 2: Copy/paste all images from the assets folder in the project structure
* Step 3: Open pubspec.yaml file
* Step 4: Add the following code under the assets section:
  [- images/your_image_name.png]
* Continue step 4 until you have downloaded all the 19 required images

# Running Apps

* Run any Android Emulator or iOS Simulator
* Run the app by typing: flutter run
* The app will run on the emulator/simulator


* For physical device, connect your device to your computer and enable USB debugging
* Run the app by typing: flutter run
* The app will run on your device

## Project layout

    driver/
        android/
           build.gradle
           app/
              google-services.json
              build.gradle
                 src/
                    main/
                       AndroidManifest.xml
        images/
           .png
        lib/
            authentication/
                login_screen.dart  
                registration_screen.dart
            global/
                global.dart
                map_key.dart
            helper/
                geofire_helper.dart
                helper_methods.dart
                request_helper.dart
            info_handler/
                app_info.dart
            models/
                active_nearby_available_drivers.dart
                direction_details_info.dart
                directions.dart
                predicted_places.dart
                trips_history_model.dart
                user_model.dart
            screens/
                about_screen.dart
                main_screen.dart
                profile_screen.dart
                rate_driver_screen.dart
                search_screen.dart
                select_nearest_active_driver_screen.dart
                trip_history_screen.dart
            splash/
                splash_screen.dart
            widgets/
                history_design_ui.dart
                my_drawer.dart
                pay_fare_amount_dialog.dart
                place_prediction_tile.dart
                info_design_ui.dart
                progress_dialog.dart
            main.dart
            generated_plugin_registrant.dart
        pubspec.yaml
        passenger_documentation.md
        
        
       
# Driver Documentation

Required plugins to install:

1. flutter pub add firebase_core
2. flutter pub add firebase_auth
3. flutter pub add firebase_database
4. flutter pub add fluttertoast
5. flutter pub add geolocator
6. flutter pub add google_maps_flutter
7. flutter pub add http
8. flutter pub add provider
9. flutter pub add flutter_polyline_points
10. flutter pub add flutter_geofire
11. flutter pub add firebase_messaging
12. flutter pub add smooth_star_rating_nsafe

Required assets to add:

  - images/car_android.png
  - images/car_ios.png
  - images/carpool.png
  - images/carpool1.png
  - images/desticon.png
  - images/desticon1.png
  - images/logo.png
  - images/logo-large.png
  - images/main-screen.png
  - images/pickicon.png
  - images/pickmarker.png
  - images/posimarker.png
  - images/posimarker1.png
  - images/redmarker.png
  - images/user_icon.png
  - images/destination.png
  - images/origin.png
  - images/car_logo.png

# How to install plugins

### Example

* Step 1: Open command line
* Step 2: In command line type: flutter pub add [insert plugin name]
* Continue step 2 until you have downloaded all 12 plugins

# How to add assets

### Example
* Step 1: Create images folder under the project structure
* Step 2: Copy/paste all images from the assets folder in the project structure
* Step 3: Open pubspec.yaml file
* Step 4: Add the following code under the assets section:
    [- images/your_image_name.png]
* Continue step 4 until you have downloaded all the 18 required images

# Running Apps

* Run any Android Emulator or iOS Simulator
* Run the app by typing: flutter run
* The app will run on the emulator/simulator


* For physical device, connect your device to your computer and enable USB debugging
* Run the app by typing: flutter run
* The app will run on your device

## Project layout

    driver/
        android/
           build.gradle
           app/
              google-services.json
              build.gradle
                 src/
                    main/
                       AndroidManifest.xml
        images/
           .png
        lib/
            authentication/
                car_info_screen.dart
                login_screen.dart  
                registration_screen.dart
            global/
                global.dart
                map_key.dart
            helper/
                helper_methods.dart
                light_theme_google_map.dart
                request_helper.dart
            info_handler/
                app_info.dart
            models/
                direction_details_info.dart
                directions.dart
                driver_data.dart
                predicted_places.dart
                trips_history_model.dart
                user_model.dart
                user_ride_request_information.dart
            push_notifications
                notification_dialog_box.dart
                push_notifications_system.dart
            screens/
                earning_tab.dart
                home_tab.dart
                new_trip_screen.dart
                profile_tab.dart
                ratings_tab.dart
                tabs_controller.dart
                trip_details_screen.dart
            splash/
                splash_screen.dart
            widgets/
                fare_amount_collection_dialog.dart
                history_design_ui.dart
                info_design_ui.dart
                progress_dialog.dart
            main.dart
            generated_plugin_registrant.dart
        pubspec.yaml
        driver_documentation.md

