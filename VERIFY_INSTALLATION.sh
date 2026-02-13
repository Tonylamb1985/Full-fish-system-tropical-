#!/bin/bash
# Aquarium System Installation Verification

echo "==================================="
echo "Aquarium System Verification"
echo "==================================="
echo ""

# Check Docker files
echo "✓ Checking Docker files..."
[ -f docker/Dockerfile ] && echo "  ✓ Dockerfile" || echo "  ✗ Dockerfile MISSING"
[ -f docker/docker-compose.yml ] && echo "  ✓ docker-compose.yml" || echo "  ✗ docker-compose.yml MISSING"
[ -f docker/analyzer/aquarium_analyzer.py ] && echo "  ✓ aquarium_analyzer.py" || echo "  ✗ aquarium_analyzer.py MISSING"
[ -f docker/config/analyzer_config.yaml ] && echo "  ✓ analyzer_config.yaml" || echo "  ✗ analyzer_config.yaml MISSING"

echo ""
echo "✓ Checking HA packages..."
[ -f home-assistant/packages/aquarium_sensors.yaml ] && echo "  ✓ aquarium_sensors.yaml" || echo "  ✗ aquarium_sensors.yaml MISSING"
[ -f home-assistant/packages/aquarium_scripts.yaml ] && echo "  ✓ aquarium_scripts.yaml" || echo "  ✗ aquarium_scripts.yaml MISSING"
[ -f home-assistant/packages/aquarium_automations.yaml ] && echo "  ✓ aquarium_automations.yaml" || echo "  ✗ aquarium_automations.yaml MISSING"

echo ""
echo "✓ Checking documentation..."
[ -f README.md ] && echo "  ✓ README.md" || echo "  ✗ README.md MISSING"
[ -f INSTALLATION.md ] && echo "  ✓ INSTALLATION.md" || echo "  ✗ INSTALLATION.md MISSING"

echo ""
echo "==================================="
echo "File check complete!"
echo "==================================="
