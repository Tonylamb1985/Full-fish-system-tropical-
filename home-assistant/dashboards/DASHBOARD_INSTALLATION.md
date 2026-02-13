# 📊 Complete 17-Tab Dashboard Installation

## What You're Getting

**Complete dashboard with 1,034 lines of YAML:**
- Tab 10: Water Testing (Seachem badge, API strips, NT Labs)
- Tab 11: Fish Health (AI monitoring, disease detection)
- Tab 12: Plant Growth (coverage tracking, algae detection)
- Tab 13: Tank Cleanliness (scoring, maintenance scheduling)
- Tab 14: Equipment Monitor (heater, filter, lights)
- Tab 15: Feeding & Care (feeding verification, maintenance)
- Tab 16: Analytics & Insights (trends, costs, predictions)
- Tab 17: Alerts & Status (overall score, quick actions)

---

## Prerequisites

Before adding the dashboard, make sure:
- ✅ aquarium-complete-system.tar.gz installed
- ✅ Docker analyzer running
- ✅ Home Assistant packages loaded
- ✅ All sensors created (check Developer Tools → States)

---

## Installation Method

### Option 1: UI Mode (Recommended)

**If using UI dashboard editor:**

1. **Open Dashboard in Edit Mode**
   ```
   Settings → Dashboards → Your Dashboard → Edit Dashboard
   ```

2. **Add New Tab**
   - Click "+ ADD TAB" button
   - Enter title: "Water Testing"
   - Enter path: "water_testing"
   - Choose icon: mdi:test-tube

3. **Switch to YAML Editor**
   - Click the 3-dot menu on the new tab
   - Select "Edit in YAML"

4. **Paste YAML**
   - Copy the YAML for Tab 10 from aquarium_dashboard_17_tabs_COMPLETE.yaml
   - Paste into editor
   - Click "Save"

5. **Repeat for Tabs 11-17**
   - Each tab is clearly marked in the YAML file
   - Copy/paste each section individually

---

### Option 2: YAML Mode

**If using YAML dashboard mode:**

1. **Locate Dashboard File**
   ```bash
   # Usually:
   /config/ui-lovelace.yaml
   # Or check configuration.yaml for location
   ```

2. **Backup Current Dashboard**
   ```bash
   cp /config/ui-lovelace.yaml /config/ui-lovelace.yaml.backup
   ```

3. **Add New Tabs**
   ```bash
   # Edit dashboard file
   nano /config/ui-lovelace.yaml
   
   # Scroll to end of 'views:' section
   # Paste Tabs 10-17 from aquarium_dashboard_17_tabs_COMPLETE.yaml
   ```

4. **Check Configuration**
   ```
   Settings → System → Configuration → Check Configuration
   ```

5. **Restart HA**
   ```
   Settings → System → Restart
   ```

---

## Required Custom Cards

Some dashboard features use custom cards. Install via HACS:

### **Essential (for best experience):**
```
HACS → Frontend → Search:
1. "Mushroom Cards" - Modern card design
2. "Multiple Entity Row" - Compact entity display
3. "Bar Card" - Progress bars
4. "Card Mod" - Styling cards
```

### **Optional (enhanced features):**
```
5. "ApexCharts Card" - Advanced charts
6. "Button Card" - Custom buttons
7. "Fold Entity Row" - Collapsible rows
```

### **Install Custom Cards:**
```
1. HACS → Frontend
2. Click "+ EXPLORE & DOWNLOAD REPOSITORIES"
3. Search for card name
4. Click card → "DOWNLOAD"
5. Restart Home Assistant
```

**Note:** Dashboard will work without custom cards, but some features may display differently.

---

## Post-Installation

### 1. Check Entities Exist

**Developer Tools → States**

Search for:
- `sensor.aquarium_ammonia_test`
- `sensor.fish_health_monitor`
- `sensor.plant_coverage`
- `sensor.tank_cleanliness_score`
- `sensor.heater_performance`
- `sensor.feeding_score`
- `sensor.tank_overall_score`

**If missing:** Check aquarium packages are loaded in configuration.yaml

### 2. Test Upload Scripts

**Developer Tools → Services**

Call:
- `script.upload_ammonia_badge_photo`
- `script.upload_api_strip_photo`
- `script.upload_fish_health_photo`

**Should:** Trigger phone notification

### 3. Verify Tabs Appear

Check dashboard sidebar:
- Tab 10: Water Testing ✓
- Tab 11: Fish Health ✓
- Tab 12: Plant Growth ✓
- Tabs 13-17 ✓

---

## Customization

### Update Device Name

**Search and replace YOUR_PHONE:**

All automations reference `mobile_app_YOUR_PHONE`.

Replace with your actual device:
```bash
# Find device name:
Settings → Companion App → Device Name
# Example: pixel_7

# Update package files:
cd /config/aquarium/packages
sed -i 's/YOUR_PHONE/pixel_7/g' *.yaml

# Restart HA
```

### Adjust Thresholds

**Edit package files to customize:**

```yaml
# aquarium_automations.yaml
# Change alert levels:
- platform: numeric_state
  entity_id: sensor.aquarium_ammonia_test
  above: 0.25  # Change this value
```

### Hide Unused Tabs

**In dashboard YAML:**
```yaml
- title: Fish Health
  visible: false  # Add this line
  path: fish_health
```

### Reorder Tabs

**Drag and drop in UI mode, or:**

Move tab sections in YAML file to reorder.

---

## Troubleshooting

### Tabs Don't Appear

**Check:**
```bash
# 1. Configuration valid
Settings → System → Configuration → Check

# 2. No YAML errors
Settings → System → Logs → Search "lovelace"

# 3. Clear browser cache
Ctrl+Shift+R (hard reload)
```

### Cards Show "Entity Not Available"

**Fix:**
```bash
# 1. Check sensor exists
Developer Tools → States → Search sensor name

# 2. If missing, check packages loaded:
grep -r "packages:" /config/configuration.yaml

# Should show:
#   packages: !include_dir_named aquarium/packages

# 3. Restart HA
ha core restart
```

### Custom Cards Not Working

**Install via HACS:**
```
1. HACS → Frontend
2. Download required cards
3. Hard refresh browser (Ctrl+Shift+R)
```

### Upload Buttons Don't Work

**Check scripts:**
```bash
# 1. Scripts exist
Developer Tools → Services → Search "upload"

# 2. Device name correct
# Edit aquarium_scripts.yaml
# Replace YOUR_PHONE with actual device name

# 3. Restart HA
```

---

## Dashboard Features

### Tab 10: Water Testing
- Photo upload for badge/strips/tubes
- Real-time results with confidence scores
- Safety assessment with warnings
- 30-day history charts
- Testing guidelines

### Tab 11: Fish Health
- AI health monitoring
- Activity level tracking
- Disease detection alerts
- Health scoring per fish

### Tab 12: Plant Growth
- Coverage percentage tracking
- Algae detection (4 types)
- Growth rate measurement
- Maintenance scheduling

### Tab 13: Tank Cleanliness
- Overall score 0-100
- Component breakdown
- Maintenance reminders
- Trend tracking

### Tab 14: Equipment Monitor
- Heater performance
- Filter flow rate
- Light intensity
- Failure predictions

### Tab 15: Feeding & Care
- Feeding verification
- Consumption tracking
- Response time analysis
- Maintenance log

### Tab 16: Analytics
- Cost tracking
- Pattern discovery
- Long-term trends
- Optimization insights

### Tab 17: Alerts & Status
- Overall tank score
- Active alerts
- Quick actions
- Achievement tracking

---

## Summary

**✅ What You Have:**
- Complete 17-tab dashboard (1,034 lines)
- All sensors configured
- Photo upload workflows
- Automated analysis
- Professional interface

**📱 Daily Use:**
1. Take photo with phone
2. AI analyzes in 2 seconds
3. Results appear in dashboard
4. Alerts if problems detected

**🎉 Your aquarium is now fully automated!**

For support, check aquarium-complete-system documentation.
