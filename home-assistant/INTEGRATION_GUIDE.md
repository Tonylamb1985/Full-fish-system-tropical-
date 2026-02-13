# 🏠 Home Assistant Integration Guide

## File Organization

This system uses **packages** to keep aquarium config separate from your main configuration.

### What are Packages?

Packages let you organize related configuration into separate files instead of one huge `configuration.yaml`.

**Benefits:**
- ✅ Easy to find aquarium settings
- ✅ Easy to backup
- ✅ Easy to disable/enable
- ✅ Doesn't clutter main config
- ✅ Easy to share

### Directory Structure:

```
/config/
├── configuration.yaml (your main file)
├── aquarium/ (NEW - all aquarium files)
│   ├── packages/ (auto-loaded by HA)
│   │   ├── aquarium_sensors.yaml
│   │   ├── aquarium_scripts.yaml
│   │   └── aquarium_automations.yaml
│   └── python_scripts/
│       └── aquarium_helpers.py
├── python_scripts/ (HA's python_scripts folder)
│   └── aquarium_helpers.py (symlink or copy)
└── www/
    └── aquarium_photos/ (photo storage)
```

---

## Configuration.yaml Changes

Add these lines to your `/config/configuration.yaml`:

```yaml
# ============================================
# Aquarium Monitoring System
# ============================================
homeassistant:
  packages: !include_dir_named aquarium/packages

python_script:
```

**That's it!** Everything else is in the package files.

---

## What Each Package Does

### aquarium_sensors.yaml

**Contains:**
- All MQTT sensors for water tests
- Fish health sensors
- Plant growth sensors
- Equipment monitoring sensors
- Analytics sensors

**Purpose:**
- Receive data from Docker analyzer
- Update dashboard values
- Provide data to other HA components

**Example:**
```yaml
mqtt:
  sensor:
    - name: "Fish Health Monitor"
      state_topic: "aquarium/fish/health"
      value_template: "{{ value_json.overall_health }}"
```

### aquarium_scripts.yaml

**Contains:**
- Photo upload scripts
- Helper scripts for actions
- Time-lapse generation scripts

**Purpose:**
- Trigger phone camera
- Handle photo uploads
- Process user actions

**Example:**
```yaml
script:
  upload_fish_health_photo:
    sequence:
      - service: notify.mobile_app_YOUR_PHONE
        data:
          title: "📸 Fish Health"
```

### aquarium_automations.yaml

**Contains:**
- Photo upload handlers
- Alert automations
- Notification automations

**Purpose:**
- React to events
- Send alerts
- Process uploads

**Example:**
```yaml
automation:
  - alias: "Fish Health - Photo Uploaded"
    trigger:
      - platform: event
        event_type: mobile_app_notification_action
```

---

## Installation Steps

### 1. Enable Packages in configuration.yaml

```bash
# Edit your main config:
nano /config/configuration.yaml

# Add at the end:
homeassistant:
  packages: !include_dir_named aquarium/packages

python_script:
```

### 2. Create Directory Structure

```bash
mkdir -p /config/aquarium/packages
mkdir -p /config/python_scripts
mkdir -p /config/www/aquarium_photos
```

### 3. Copy Package Files

```bash
# Copy the three package files:
cp aquarium_sensors.yaml /config/aquarium/packages/
cp aquarium_scripts.yaml /config/aquarium/packages/
cp aquarium_automations.yaml /config/aquarium/packages/

# Copy python helper:
cp python_scripts/aquarium_helpers.py /config/python_scripts/
```

### 4. Update YOUR_PHONE

```bash
# Find your device name:
# Settings → Companion App → Device Name
# Example: pixel_7

# Replace in files:
cd /config/aquarium/packages
sed -i 's/YOUR_PHONE/YOUR_DEVICE_NAME/g' *.yaml
```

### 5. Check Configuration

```bash
# In HA UI:
# Settings → System → Configuration → Check Configuration

# Should show: ✓ Configuration valid
```

### 6. Restart Home Assistant

```bash
# Settings → System → Restart
# OR: ha core restart

# Wait 2-3 minutes
```

### 7. Verify

```bash
# Check entities created:
# Developer Tools → States
# Search: aquarium

# Should see:
# - sensor.fish_health_monitor
# - sensor.plant_coverage
# - sensor.tank_cleanliness_score
# - etc.
```

---

## Troubleshooting

### Packages Not Loading

**Check configuration.yaml:**
```yaml
# Make sure you have:
homeassistant:
  packages: !include_dir_named aquarium/packages

# NOT:
homeassistant:
  packages: !include_dir_merge_named aquarium/packages
```

**Verify directory:**
```bash
ls -la /config/aquarium/packages/
# Should show:
# aquarium_sensors.yaml
# aquarium_scripts.yaml
# aquarium_automations.yaml
```

### Entities Not Created

**Check logs:**
```
Settings → System → Logs
Search for: aquarium
```

**Common issues:**
- YAML indentation wrong
- Entity names duplicated
- MQTT not configured

### Scripts Not Appearing

**Enable python_script:**
```yaml
# In configuration.yaml:
python_script:
```

**Check python_scripts exists:**
```bash
ls /config/python_scripts/
# Should show: aquarium_helpers.py
```

---

## Customizing

### Add Your Fish Names

Edit `/config/aquarium/packages/aquarium_sensors.yaml`:

```yaml
# Change generic names to your fish:
- name: "Fish Oscar"  # Your fish name
  state_topic: "aquarium/fish/oscar"
```

### Adjust Alert Thresholds

Edit `/config/aquarium/packages/aquarium_automations.yaml`:

```yaml
# Change trigger values:
- platform: numeric_state
  entity_id: sensor.aquarium_ammonia_test
  above: 0.25  # Adjust this value
```

### Add Custom Scripts

Create `/config/aquarium/packages/aquarium_custom.yaml`:

```yaml
# Your custom scripts/automations
script:
  my_custom_aquarium_script:
    sequence:
      - service: notify.mobile_app_YOUR_PHONE
        data:
          message: "Custom action"
```

---

## Backup

### What to Backup

```bash
# Essential files:
/config/aquarium/                    # All aquarium config
/config/www/aquarium_photos/         # Photo history
/config/configuration.yaml           # Main config (has package include)

# For full backup:
tar -czf aquarium-backup.tar.gz \
  /config/aquarium \
  /config/www/aquarium_photos
```

### Restore

```bash
# Extract backup:
tar -xzf aquarium-backup.tar.gz -C /

# Restart HA:
ha core restart
```

---

## Disable/Enable System

### Temporary Disable

```bash
# Rename packages directory:
mv /config/aquarium/packages /config/aquarium/packages_disabled

# Restart HA
```

### Re-enable

```bash
# Rename back:
mv /config/aquarium/packages_disabled /config/aquarium/packages

# Restart HA
```

### Permanent Removal

```bash
# 1. Remove from configuration.yaml:
# Delete the packages lines

# 2. Remove files:
rm -rf /config/aquarium

# 3. Restart HA
```

---

## Advanced

### Multiple Aquariums

```bash
# Create separate packages:
/config/aquarium/packages/
  ├── aquarium1_sensors.yaml
  ├── aquarium1_scripts.yaml
  ├── aquarium2_sensors.yaml
  └── aquarium2_scripts.yaml

# Each package uses different MQTT topics:
# aquarium1/fish/health
# aquarium2/fish/health
```

### Integration with Existing Automations

```yaml
# In your own automations:
automation:
  - alias: "My Morning Routine"
    trigger:
      - platform: time
        at: "07:00:00"
    action:
      # Include aquarium check:
      - service: script.upload_fish_health_photo
```

---

## Summary

**✅ Organized:** All aquarium config in one place  
**✅ Clean:** Main config.yaml stays simple  
**✅ Maintainable:** Easy to update/disable  
**✅ Shareable:** Can share whole aquarium folder  
**✅ Professional:** Industry best practice  

**Your aquarium system is properly integrated! 🎉**
