# 📋 Complete Installation Guide

## Overview

This guide will walk you through setting up the complete aquarium monitoring system.

**Time required:** 45-60 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Basic Linux command line knowledge

---

## ✅ Pre-Installation Checklist

Before starting, verify you have:

- [ ] Home Assistant VM running and accessible
- [ ] Docker host with i5-6400 CPU + HD Graphics 530
- [ ] Both on same network (note IP addresses)
- [ ] SSH access to both servers
- [ ] Home Assistant mobile app installed
- [ ] Seachem Ammonia Alert Badge ($6)
- [ ] API 5-in-1 test strips
- [ ] NT Labs liquid test kits (optional but recommended)

**Network Info to Note:**
- Home Assistant VM IP: ____________
- Docker Host IP: ____________

---

## 📦 Phase 1: Shared Folder Setup (15 minutes)

### Why We Need This:

Home Assistant needs to save uploaded photos somewhere that Docker can read them. We use NFS (Network File System) to share a folder between the two servers.

### On Home Assistant VM:

```bash
# 1. SSH into Home Assistant
ssh root@YOUR_HA_IP

# 2. Install NFS server
apk add nfs-utils

# 3. Create shared directory
mkdir -p /media/aquarium_photos
chmod 777 /media/aquarium_photos

# 4. Configure NFS export
# Replace 192.168.1.100 with your Docker host IP
echo "/media/aquarium_photos 192.168.1.100(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

# 5. Start NFS server
rc-update add nfs
rc-service nfs start

# 6. Verify export
exportfs -v
# Should show: /media/aquarium_photos 192.168.1.100(rw,...)
```

### On Docker Host:

```bash
# 1. Install NFS client
sudo apt update
sudo apt install nfs-common

# 2. Create mount point
sudo mkdir -p /mnt/aquarium_photos

# 3. Test mount (replace with your HA VM IP)
sudo mount -t nfs 192.168.1.50:/media/aquarium_photos /mnt/aquarium_photos

# 4. Verify it works
ls -la /mnt/aquarium_photos
# Should show empty directory

# 5. Make mount permanent
echo "192.168.1.50:/media/aquarium_photos /mnt/aquarium_photos nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# 6. Test permanent mount
sudo umount /mnt/aquarium_photos
sudo mount -a
ls -la /mnt/aquarium_photos
```

### Test Shared Folder:

```bash
# From HA VM:
echo "test from HA" > /media/aquarium_photos/test.txt

# From Docker host:
cat /mnt/aquarium_photos/test.txt
# Should show: "test from HA"

# If this works, shared folder is ready! ✅
```

---

## 🐳 Phase 2: Docker Deployment (10 minutes)

### Copy Files to Docker Host:

```bash
# On your computer, extract the tar.gz:
tar -xzf aquarium-complete-system.tar.gz

# Copy docker folder to Docker host:
scp -r aquarium-complete-system/docker/* user@DOCKER_HOST_IP:~/aquarium-system/

# SSH into Docker host:
ssh user@DOCKER_HOST_IP
cd ~/aquarium-system
```

### Edit Configuration:

```bash
# 1. Edit docker-compose.yml
nano docker-compose.yml

# Update these lines:
# Line 28: MQTT_BROKER=192.168.1.50  (your HA VM IP)
# Line 42: /mnt/aquarium_photos:/media/photos:ro

# Save: Ctrl+O, Enter, Ctrl+X
```

### Build and Start:

```bash
# 1. Build the container (takes 5-10 minutes)
docker-compose build

# You'll see:
# - Downloading Intel drivers
# - Installing OpenCV
# - Setting up Python packages

# 2. Start the container
docker-compose up -d

# 3. Check it's running
docker-compose ps
# Should show: aquarium-analyzer ... Up

# 4. Check logs
docker-compose logs -f aquarium-analyzer

# You should see:
# "Intel HD Graphics 530 Setup"
# "OpenCL Device: Intel(R) HD Graphics 530"
# "GPU acceleration ENABLED ✓"
# "AQUARIUM ANALYZER - READY"

# Press Ctrl+C to exit logs
```

### Verify GPU Access:

```bash
# Check VAAPI
docker exec -it aquarium-analyzer vainfo
# Should show: i965 driver, HD Graphics 530

# Check OpenCL
docker exec -it aquarium-analyzer clinfo -l
# Should list: Intel(R) HD Graphics 530

# If both work: GPU is ready! ✅
```

---

## 🏠 Phase 3: Home Assistant Configuration (20 minutes)

### Copy Files to Home Assistant:

```bash
# From your computer:
scp -r aquarium-complete-system/home-assistant/* \
  root@HA_IP:/config/aquarium/

# SSH into HA:
ssh root@HA_IP
cd /config/aquarium
```

### Update configuration.yaml:

```bash
# Edit your main configuration
nano /config/configuration.yaml

# Add these lines at the END of the file:
# ============================================
# Aquarium Monitoring System
# ============================================
homeassistant:
  packages: !include_dir_named aquarium/packages

python_script:

# Create packages directory if not exists
mkdir -p /config/aquarium/packages

# Move the package files
mv /config/aquarium/aquarium_*.yaml /config/aquarium/packages/
```

### Update Entity Names:

```bash
# Edit all package files to replace YOUR_PHONE
cd /config/aquarium/packages

# Find your actual device name:
# In HA: Settings → Companion App → Device Name
# Example: mobile_app_pixel_7

# Replace in all files:
sed -i 's/YOUR_PHONE/pixel_7/g' aquarium_scripts.yaml
sed -i 's/YOUR_PHONE/pixel_7/g' aquarium_automations.yaml

# Update IPs in automations:
sed -i 's/192.168.1.50/YOUR_HA_IP/g' aquarium_sensors.yaml
```

### Copy Python Scripts:

```bash
# Copy helper scripts
mkdir -p /config/python_scripts
cp /config/aquarium/python_scripts/* /config/python_scripts/
```

### Install Dashboard:

```bash
# Your main dashboard file is probably:
# /config/ui-lovelace.yaml or in the UI

# If using YAML mode:
# Add the aquarium tabs to your dashboard file

# If using UI mode:
# 1. Copy contents of aquarium_dashboard_COMPLETE.yaml
# 2. Go to HA → Settings → Dashboards
# 3. Edit your dashboard
# 4. Add new tabs (10-17)
# 5. Paste YAML for each tab
```

### Create Photo Storage:

```bash
# Create www directory for photos
mkdir -p /config/www/aquarium_photos
chmod 777 /config/www/aquarium_photos
```

### Restart Home Assistant:

```bash
# From HA UI:
# Settings → System → Restart

# OR from command line:
ha core restart

# Wait 2-3 minutes for restart
```

### Verify Configuration:

```bash
# After restart, check:

# 1. Configuration is valid
# Settings → System → Configuration → Check

# 2. Sensors exist
# Developer Tools → States
# Search for: aquarium
# Should see: sensor.fish_health_monitor, etc.

# 3. Scripts exist  
# Developer Tools → Services
# Search for: upload_fish_health_photo
# Should see all aquarium scripts

# 4. Dashboard tabs visible
# Check tabs 10-17 appear in sidebar
```

---

## 📱 Phase 4: Mobile App Setup (5 minutes)

### Configure Phone:

```bash
# 1. Install Home Assistant Companion App
# iOS: App Store
# Android: Play Store

# 2. Login to your HA instance

# 3. Enable permissions:
# - Camera access: ✓
# - Notifications: ✓
# - Storage: ✓

# 4. Test notification:
# In HA: Developer Tools → Services
# Service: notify.mobile_app_YOUR_DEVICE
# Service Data:
{
  "message": "Test notification",
  "title": "Aquarium System Test"
}

# Call Service
# Should receive notification on phone ✓
```

---

## 🎯 Phase 5: First Test (10 minutes)

### Test Water Testing:

```bash
# 1. In Home Assistant app on phone
# Go to Tab 10: Water Testing

# 2. Install Seachem Ammonia Alert Badge in tank
# - Stick to inside glass
# - Visible from front

# 3. Tap "Ammonia Badge" button
# - Notification appears
# - Tap "Take Photo"
# - Point at badge in tank
# - Take photo

# 4. Wait 2-3 seconds
# - Dashboard updates
# - Result appears
# - Notification sent

# Success! ✓
```

### Test API Strip:

```bash
# 1. Do API 5-in-1 test strip
# - Dip in tank water
# - Wait 60 seconds

# 2. Place on white background

# 3. In HA app, Tab 10
# Tap "API Strip" button

# 4. Take photo of strip

# 5. Results appear in 2 seconds ✓
```

### Test Fish Health:

```bash
# 1. Go to Tab 11: Fish Health

# 2. Tap "Check Fish Health" button

# 3. Take photo of fish
# - Multiple angles if possible
# - Good lighting

# 4. Wait for analysis

# 5. See results:
# - Fish detected
# - Health scores
# - Activity level

# Success! ✓
```

---

## ⚙️ Phase 6: Calibration (30 minutes)

See `documentation/setup/04_CALIBRATION.md` for complete calibration guide.

### Quick Calibration:

**For Water Tests:**

```bash
# 1. Take reference photo with known values
# Example: Distilled water (ammonia = 0)

# 2. Note if reading is accurate

# 3. If off, adjust color charts in:
# docker/config/analyzer_config.yaml

# 4. Restart Docker container:
docker-compose restart aquarium-analyzer
```

**For Fish/Plant Photos:**

```bash
# 1. Take sample photos

# 2. Check analysis results

# 3. If detection is poor:
# - Improve lighting
# - Different camera angle
# - Clean glass/decorations

# 4. Model improves over time!
```

---

## ✅ Installation Complete!

### Verify Everything Works:

- [ ] Shared folder accessible from both servers
- [ ] Docker container running with GPU
- [ ] Home Assistant sensors created
- [ ] Dashboard tabs visible (10-17)
- [ ] Mobile app can upload photos
- [ ] Water test analysis works
- [ ] Fish health detection works
- [ ] Results appear in dashboard
- [ ] Notifications working

### If All Checked:

🎉 **Congratulations! Your aquarium is now smart!** 🎉

---

## 📊 Next Steps

1. **Daily Use:**
   - Morning: Photo of badge + API strip
   - Evening: Check dashboard
   - Weekly: NT Labs verification

2. **Calibration:**
   - Fine-tune over first week
   - Adjust as needed
   - See calibration guide

3. **Explore Features:**
   - Try all tabs
   - Upload different photos
   - Check analytics

4. **Customize:**
   - Adjust alert thresholds
   - Modify dashboard
   - Add more fish/plants

---

## 🆘 Troubleshooting

### Photo Won't Upload:

```bash
# Check HA permissions:
ls -la /media/aquarium_photos
chmod 777 /media/aquarium_photos

# Check NFS mount:
mount | grep aquarium
```

### Docker Not Analyzing:

```bash
# Check logs:
docker-compose logs -f aquarium-analyzer

# Check MQTT connection:
# Should see: "Connected to MQTT"

# Restart if needed:
docker-compose restart aquarium-analyzer
```

### Sensors Not Updating:

```bash
# Check MQTT broker running:
# In HA: Settings → Integrations → MQTT

# Check topics:
# Developer Tools → MQTT → Listen to #

# Should see messages on:
# aquarium/water_test/*
# aquarium/fish/*
# aquarium/plants/*
```

### Low Confidence Scores:

```bash
# Improve photo quality:
# - Better lighting
# - White background
# - Sharp focus
# - Fill frame

# Recalibrate regions:
# See 04_CALIBRATION.md
```

---

## 📚 Additional Documentation

- **USAGE_GUIDE.md** - Daily operations
- **PHOTO_TIPS.md** - Best photo practices
- **TROUBLESHOOTING.md** - Common issues
- **04_CALIBRATION.md** - Fine-tuning system

**System is ready! Enjoy your automated aquarium monitoring!** 🐠🌿✨
