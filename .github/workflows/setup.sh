# Function to parse the device name from input string
parse_device_name() {
    local input_str=$1
    local IFS=',' # Set Internal Field Separator to comma for splitting
    
    for kv in $input_str; do
        key="${kv%%=*}"     # Extract key (everything before '=')
        value="${kv#*=}"    # Extract value (everything after '=')
        
        if [ "$key" = "name" ]; then
            echo "$value"
            return
        fi
    done
}

# Extract device name from the input (assuming it's passed as the first argument)
input=${1:-"platform=iOS Simulator,name=iPhone 15 Pro"}
DEVICE_NAME=$(parse_device_name "$input")

echo "Device name: $DEVICE_NAME"

# Retrieve the iOS simulator IDs for the specified device
REGEX_PATTERN="$DEVICE_NAME( Simulator)? \(.*\)"
SIMULATOR_IDS=$(xctrace list devices | grep -E "$REGEX_PATTERN" | awk '{print $NF}' | tr -d '()')

# Check if SIMULATOR_IDS is empty
if [ -z "$SIMULATOR_IDS" ]; then
    echo "No simulators found for the specified device."
    exit 1
fi

# Loop through each Simulator ID
for SIMULATOR_ID in $SIMULATOR_IDS; do
    echo "Processing Simulator ID: $SIMULATOR_ID"

    xcrun simctl boot "$SIMULATOR_ID"

    PLIST1="$HOME/Library/Developer/CoreSimulator/Devices/$SIMULATOR_ID/data/Containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/UserSettings.plist"
    PLIST2="$HOME/Library/Developer/CoreSimulator/Devices/$SIMULATOR_ID/data/Library/UserConfigurationProfiles/EffectiveUserSettings.plist"
    PLIST3="$HOME/Library/Developer/CoreSimulator/Devices/$SIMULATOR_ID/data/Library/UserConfigurationProfiles/PublicInfo/PublicEffectiveUserSettings.plist"

    # Loop for a maximum of 30 seconds
    for (( i=0; i<30; i++ )); do
        if [ -f "$PLIST1" ] && [ -f "$PLIST2" ] && [ -f "$PLIST3" ]; then
            echo "All files found."
            break
        fi
        sleep 1
    done

    # Check if the loop exited because all files were found or because of timeout
    if [ ! -f "$PLIST1" ] || [ ! -f "$PLIST2" ] || [ ! -f "$PLIST3" ]; then
        echo "Error: Not all files were found within the 30-second timeout."
        exit 1
    fi

    # Disable AutoFillPasswords
    plutil -replace restrictedBool.allowPasswordAutoFill.value -bool NO $PLIST1
    plutil -replace restrictedBool.allowPasswordAutoFill.value -bool NO $PLIST2
    plutil -replace restrictedBool.allowPasswordAutoFill.value -bool NO $PLIST3

    # Restart (shutdown if needed and boot) the iOS simulator for the changes to take effect
    if xcrun simctl shutdown "$SIMULATOR_ID"; then
        echo "Simulator $SIMULATOR_ID shutdown successfully."
    else
        echo "Unable to shutdown simulator $SIMULATOR_ID as it is already shutdown."
    fi
done