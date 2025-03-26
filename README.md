# A simple Flutter counter app

This is a simple Flutter counter app that uses Supabase for authentication and data storage.

## Start Supabase

From the project root, run the following command to start Supabase:

```bash
supabase start
````

This will start a local Supabase instance on `http://localhost:54323`.

## Configuration

Copy and rename [app_config_template.dart](lib/app_config_template.dart) to `app_config.dart` in the [lib](lib) directory

```bash
cp lib/app_config_template.dart lib/app_config.dart
```

Update `app_config.dart` with the Supabase URL and anon key.

## Run the app

```bash
flutter run
```

# Tips
1. Type `st` in your editor to get snippets for state widgets
2. Use the refactor tool
    1. AndroidStudio: `option ⌥ + ⏎`
    2. VSCode:  `command ⌘ + .`