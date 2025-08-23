#!/bin/bash
set -e

echo "Building LibreChat configuration from environment variables..."

# Set configuration file path with default fallback
CONFIG_PATH="${CONFIG_PATH:-/app/librechat.yaml}"
DATA_FILE="/tmp/librechat-data.json"

# Helper function to check if environment variable exists and is not empty
env_exists() {
    [ -n "${!1}" ]
}

# Helper function to add property to JSON if env var exists
add_if_exists() {
    local var_name="$1"
    local json_path="$2"
    local value_type="${3:-string}"
    
    if env_exists "$var_name"; then
        local value="${!var_name}"
        if [ "$value_type" = "boolean" ]; then
            # Convert string to boolean
            case "${value,,}" in
                true|1|yes|on) value="true" ;;
                *) value="false" ;;
            esac
            echo "$(echo "$json_data" | jq "$json_path = $value")"
        elif [ "$value_type" = "number" ]; then
            echo "$(echo "$json_data" | jq "$json_path = $value")"
        else
            echo "$(echo "$json_data" | jq "$json_path = \"$value\"")"
        fi
    else
        echo "$json_data"
    fi
}

# Helper function to add array from comma-separated string
add_array_if_exists() {
    local var_name="$1"
    local json_path="$2"
    
    if env_exists "$var_name"; then
        local value="${!var_name}"
        # Convert comma-separated string to JSON array
        local array_json=$(echo "$value" | jq -R 'split(",") | map(select(length > 0))')
        echo "$(echo "$json_data" | jq "$json_path = $array_json")"
    else
        echo "$json_data"
    fi
}

# Initialize empty JSON object
json_data="{}"

# Basic configuration
json_data=$(add_if_exists "LIBRECHAT_VERSION" ".version")
json_data=$(add_if_exists "LIBRECHAT_CACHE" ".cache" "boolean")

# File strategy
if env_exists "LIBRECHAT_FILESTRATEGY"; then
    json_data=$(add_if_exists "LIBRECHAT_FILESTRATEGY" ".fileStrategy.single")
else
    json_data=$(add_if_exists "LIBRECHAT_FILESTRATEGY_AVATAR" ".fileStrategy.avatar")
    json_data=$(add_if_exists "LIBRECHAT_FILESTRATEGY_IMAGE" ".fileStrategy.image")
    json_data=$(add_if_exists "LIBRECHAT_FILESTRATEGY_DOCUMENT" ".fileStrategy.document")
fi

# Interface configuration
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_CUSTOMWELCOME" ".interface.customWelcome")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_FILESEARCH" ".interface.fileSearch" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_ENDPOINTSMENU" ".interface.endpointsMenu" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_MODELSELECT" ".interface.modelSelect" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PARAMETERS" ".interface.parameters" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_SIDEPANEL" ".interface.sidePanel" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PRESETS" ".interface.presets" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PROMPTS" ".interface.prompts" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_BOOKMARKS" ".interface.bookmarks" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_MULTICONVO" ".interface.multiConvo" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_AGENTS" ".interface.agents" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_FILECITATIONS" ".interface.fileCitations" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TEMPORARYCHATRETENTION" ".interface.temporaryChatRetention" "number")

# Privacy Policy
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PRIVACYPOLICY_EXTERNALURL" ".interface.privacyPolicy.externalUrl")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PRIVACYPOLICY_OPENNEWTAB" ".interface.privacyPolicy.openNewTab" "boolean")

# Terms of Service
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TERMSOFSERVICE_EXTERNALURL" ".interface.termsOfService.externalUrl")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TERMSOFSERVICE_OPENNEWTAB" ".interface.termsOfService.openNewTab" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALACCEPTANCE" ".interface.termsOfService.modalAcceptance" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALTITLE" ".interface.termsOfService.modalTitle")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALCONTENT" ".interface.termsOfService.modalContent")

# People Picker
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PEOPLEPICKER_USERS" ".interface.peoplePicker.users" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PEOPLEPICKER_GROUPS" ".interface.peoplePicker.groups" "boolean")
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_PEOPLEPICKER_ROLES" ".interface.peoplePicker.roles" "boolean")

# Marketplace
json_data=$(add_if_exists "LIBRECHAT_INTERFACE_MARKETPLACE_USE" ".interface.marketplace.use" "boolean")

# Turnstile
json_data=$(add_if_exists "LIBRECHAT_TURNSTILE_SITEKEY" ".turnstile.siteKey")
json_data=$(add_if_exists "LIBRECHAT_TURNSTILE_OPTIONS_LANGUAGE" ".turnstile.options.language")
json_data=$(add_if_exists "LIBRECHAT_TURNSTILE_OPTIONS_SIZE" ".turnstile.options.size")

# Registration
json_data=$(add_array_if_exists "LIBRECHAT_REGISTRATION_SOCIALLOGINS" ".registration.socialLogins")
json_data=$(add_array_if_exists "LIBRECHAT_REGISTRATION_ALLOWEDDOMAINS" ".registration.allowedDomains")

# Balance
json_data=$(add_if_exists "LIBRECHAT_BALANCE_ENABLED" ".balance.enabled" "boolean")
json_data=$(add_if_exists "LIBRECHAT_BALANCE_STARTBALANCE" ".balance.startBalance" "number")
json_data=$(add_if_exists "LIBRECHAT_BALANCE_AUTOREFFILLENABLED" ".balance.autoRefillEnabled" "boolean")
json_data=$(add_if_exists "LIBRECHAT_BALANCE_REFILLINTERVALVALUE" ".balance.refillIntervalValue" "number")
json_data=$(add_if_exists "LIBRECHAT_BALANCE_REFILLINTERVALUNIT" ".balance.refillIntervalUnit")
json_data=$(add_if_exists "LIBRECHAT_BALANCE_REFILLAMOUNT" ".balance.refillAmount" "number")

# Actions
json_data=$(add_array_if_exists "LIBRECHAT_ACTIONS_ALLOWEDDOMAINS" ".actions.allowedDomains")

# Assistants endpoint
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_DISABLEBUILDER" ".endpoints.assistants.disableBuilder" "boolean")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_POLLINTERVALMS" ".endpoints.assistants.pollIntervalMs" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_TIMEOUTMS" ".endpoints.assistants.timeoutMs" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_PRIVATEASSISTANTS" ".endpoints.assistants.privateAssistants" "boolean")
json_data=$(add_array_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_SUPPORTEDIDS" ".endpoints.assistants.supportedIds")
json_data=$(add_array_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_EXCLUDEDIDS" ".endpoints.assistants.excludedIds")
json_data=$(add_array_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_RETRIEVALMODELS" ".endpoints.assistants.retrievalModels")
json_data=$(add_array_if_exists "LIBRECHAT_ENDPOINTS_ASSISTANTS_CAPABILITIES" ".endpoints.assistants.capabilities")

# Agents endpoint
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_RECURSIONLIMIT" ".endpoints.agents.recursionLimit" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_MAXRECURSIONLIMIT" ".endpoints.agents.maxRecursionLimit" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_DISABLEBUILDER" ".endpoints.agents.disableBuilder" "boolean")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_MAXCITATIONS" ".endpoints.agents.maxCitations" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_MAXCITATIONSPERFILE" ".endpoints.agents.maxCitationsPerFile" "number")
json_data=$(add_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_MINRELEVANCESCORE" ".endpoints.agents.minRelevanceScore" "number")
json_data=$(add_array_if_exists "LIBRECHAT_ENDPOINTS_AGENTS_CAPABILITIES" ".endpoints.agents.capabilities")

# Custom endpoints (indexed)
custom_endpoints="[]"
i=0
while env_exists "LIBRECHAT_ENDPOINTS_CUSTOM_${i}_NAME"; do
    endpoint="{}"
    var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_NAME"
    endpoint=$(echo "$endpoint" | jq ".name = \"${!var_name}\"")
    
    # Add basic parameters
    for param in APIKEY BASEURL TITLEMODEL MODELDISPLAYLABEL; do
        var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_${param}"
        if env_exists "$var_name"; then
            prop_name=$(echo "$param" | tr '[:upper:]' '[:lower:]')
            case "$prop_name" in
                "apikey") prop_name="apiKey" ;;
                "baseurl") prop_name="baseURL" ;;
                "titlemodel") prop_name="titleModel" ;;
                "modeldisplaylabel") prop_name="modelDisplayLabel" ;;
            esac
            endpoint=$(echo "$endpoint" | jq ".$prop_name = \"${!var_name}\"")
        fi
    done
    
    # Add boolean parameters
    for param in TITLECONVO SUMMARIZE FORCEPROMPT; do
        var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_${param}"
        if env_exists "$var_name"; then
            prop_name=$(echo "$param" | tr '[:upper:]' '[:lower:]')
            case "$prop_name" in
                "titleconvo") prop_name="titleConvo" ;;
                "forceprompt") prop_name="forcePrompt" ;;
            esac
            value="${!var_name}"
            case "${value,,}" in
                true|1|yes|on) value="true" ;;
                *) value="false" ;;
            esac
            endpoint=$(echo "$endpoint" | jq ".$prop_name = $value")
        fi
    done
    
    # Add headers (parse key:value,key:value format)
    var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_HEADERS"
    if env_exists "$var_name"; then
        headers_str="${!var_name}"
        headers="{}"
        IFS=',' read -ra HEADERS_ARRAY <<< "$headers_str"
        for header in "${HEADERS_ARRAY[@]}"; do
            if [[ "$header" == *":"* ]]; then
                key=$(echo "$header" | cut -d':' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                value=$(echo "$header" | cut -d':' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                headers=$(echo "$headers" | jq --arg k "$key" --arg v "$value" '.[$k] = $v')
            fi
        done
        endpoint=$(echo "$endpoint" | jq ".headers = $headers")
    fi
    
    # Add models
    var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_MODELS_DEFAULT"
    if env_exists "$var_name"; then
        models_str="${!var_name}"
        models_array=$(echo "$models_str" | jq -R 'split(",") | map(select(length > 0))')
        endpoint=$(echo "$endpoint" | jq ".models.default = $models_array")
        
        var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_MODELS_FETCH"
        if env_exists "$var_name"; then
            value="${!var_name}"
            case "${value,,}" in
                true|1|yes|on) value="true" ;;
                *) value="false" ;;
            esac
            endpoint=$(echo "$endpoint" | jq ".models.fetch = $value")
        fi
    fi
    
    # Add dropParams
    var_name="LIBRECHAT_ENDPOINTS_CUSTOM_${i}_DROPPARAMS"
    if env_exists "$var_name"; then
        params_str="${!var_name}"
        params_array=$(echo "$params_str" | jq -R 'split(",") | map(select(length > 0))')
        endpoint=$(echo "$endpoint" | jq ".dropParams = $params_array")
    fi
    
    custom_endpoints=$(echo "$custom_endpoints" | jq ". += [$endpoint]")
    i=$((i + 1))
done

if [ "$custom_endpoints" != "[]" ]; then
    json_data=$(echo "$json_data" | jq ".endpoints.custom = $custom_endpoints")
fi

# Write JSON data to temporary file
echo "$json_data" > "$DATA_FILE"

# Render template using gomplate
echo "Rendering configuration template..."
gomplate -d data="file://$DATA_FILE" -f /app/templates/librechat.yaml.tmpl -o "$CONFIG_PATH"

# Clean up temporary file
rm -f "$DATA_FILE"

echo "Configuration built successfully!"
echo "Generated configuration at: $CONFIG_PATH"