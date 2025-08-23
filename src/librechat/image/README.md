# LibreChat Custom Image

Custom Docker image for LibreChat with dynamic configuration generation based on environment variables.

## Quick Start

Build the custom LibreChat image:

```bash
cd src/librechat/image
docker build -t librechat .
docker tag librechat localhost/librechat
```

## Features

- **Dynamic Configuration**: The `librechat.yaml` configuration file is automatically generated from environment variables
- **Modularity**: Only necessary sections are added to the configuration
- **Extensibility**: Easy to add new configuration parameters
- **Compatibility**: Works with the existing component build system

## File Structure

```sh
src/librechat/image/
├── Dockerfile                    # Custom image based on official LibreChat
├── scripts/
│   ├── build-config.sh          # Configuration generation script (uses Handlebars)
│   └── entrypoint.sh            # Container entry point
├── templates/
│   └── librechat.yaml.hbs       # Handlebars template for LibreChat configuration
└── README.md                    # This documentation
```

## How It Works

1. **Image Build**: Dockerfile creates a custom image with Node.js, handlebars-cli, and jq
2. **Data Preparation**: `build-config.sh` converts environment variables to JSON using jq
3. **Template Rendering**: Handlebars processes the template with the JSON data
4. **Application Start**: `entrypoint.sh` starts LibreChat with the generated configuration

## Technology Stack

- **Handlebars**: Template engine for clean, readable YAML generation
- **jq**: JSON processor for environment variable handling
- **Node.js**: Runtime for handlebars-cli
- **Bash**: Orchestration and environment variable processing

## Advantages of Handlebars Solution

### Compared to Previous Bash Implementation

- **Readability**: Template is clean YAML with simple `{{#if}}` conditions
- **Maintainability**: Logic separated from template structure
- **Compactness**: ~190 lines vs ~500 lines of bash
- **Type Safety**: Proper boolean/number handling via jq
- **Debugging**: Easy to inspect generated JSON data

### Template Benefits

- **Declarative**: Shows final YAML structure clearly
- **Conditional**: Only includes sections when data exists
- **Extensible**: Easy to add new sections or modify existing ones
- **Standard**: Uses widely-adopted Handlebars syntax

## Complete Environment Variables List

All configuration variables start with `LIBRECHAT_` and follow YAML structure:

### Basic Configuration

- `CONFIG_PATH` - path to configuration file (default: /app/librechat.yaml)
- `LIBRECHAT_VERSION` - configuration version (default: 1.2.1)
- `LIBRECHAT_CACHE` - enable caching (true/false)

### File Storage Strategy

- `LIBRECHAT_FILESTRATEGY` - single strategy for all file types (local/s3/firebase)
- `LIBRECHAT_FILESTRATEGY_AVATAR` - storage for user/agent avatar images
- `LIBRECHAT_FILESTRATEGY_IMAGE` - storage for uploaded images in chats
- `LIBRECHAT_FILESTRATEGY_DOCUMENT` - storage for document uploads

### Interface Configuration

- `LIBRECHAT_INTERFACE_CUSTOMWELCOME` - welcome message
- `LIBRECHAT_INTERFACE_FILESEARCH` - file search (true/false)
- `LIBRECHAT_INTERFACE_ENDPOINTSMENU` - endpoints menu (true/false)
- `LIBRECHAT_INTERFACE_MODELSELECT` - model selection (true/false)
- `LIBRECHAT_INTERFACE_PARAMETERS` - parameters panel (true/false)
- `LIBRECHAT_INTERFACE_SIDEPANEL` - side panel (true/false)
- `LIBRECHAT_INTERFACE_PRESETS` - presets (true/false)
- `LIBRECHAT_INTERFACE_PROMPTS` - prompts (true/false)
- `LIBRECHAT_INTERFACE_BOOKMARKS` - bookmarks (true/false)
- `LIBRECHAT_INTERFACE_MULTICONVO` - multi conversation (true/false)
- `LIBRECHAT_INTERFACE_AGENTS` - agents (true/false)
- `LIBRECHAT_INTERFACE_FILECITATIONS` - file citations (true/false)
- `LIBRECHAT_INTERFACE_TEMPORARYCHATRETENTION` - temporary chat retention period in hours

### Privacy Policy

- `LIBRECHAT_INTERFACE_PRIVACYPOLICY_EXTERNALURL` - privacy policy URL
- `LIBRECHAT_INTERFACE_PRIVACYPOLICY_OPENNEWTAB` - open in new tab (true/false)

### Terms of Service

- `LIBRECHAT_INTERFACE_TERMSOFSERVICE_EXTERNALURL` - terms of service URL
- `LIBRECHAT_INTERFACE_TERMSOFSERVICE_OPENNEWTAB` - open in new tab (true/false)
- `LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALACCEPTANCE` - modal acceptance (true/false)
- `LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALTITLE` - modal title
- `LIBRECHAT_INTERFACE_TERMSOFSERVICE_MODALCONTENT` - modal content (multiline)

### People Picker

- `LIBRECHAT_INTERFACE_PEOPLEPICKER_USERS` - users picker (true/false)
- `LIBRECHAT_INTERFACE_PEOPLEPICKER_GROUPS` - groups picker (true/false)
- `LIBRECHAT_INTERFACE_PEOPLEPICKER_ROLES` - roles picker (true/false)

### Marketplace

- `LIBRECHAT_INTERFACE_MARKETPLACE_USE` - marketplace usage (true/false)

### Cloudflare Turnstile

- `LIBRECHAT_TURNSTILE_SITEKEY` - turnstile site key
- `LIBRECHAT_TURNSTILE_OPTIONS_LANGUAGE` - language (auto/ISO 639-1 code)
- `LIBRECHAT_TURNSTILE_OPTIONS_SIZE` - size (normal/compact/flexible/invisible)

### Registration

- `LIBRECHAT_REGISTRATION_SOCIALLOGINS` - social login providers (comma-separated)
- `LIBRECHAT_REGISTRATION_ALLOWEDDOMAINS` - allowed email domains (comma-separated)

### Balance Settings

- `LIBRECHAT_BALANCE_ENABLED` - enable balance system (true/false)
- `LIBRECHAT_BALANCE_STARTBALANCE` - starting balance amount
- `LIBRECHAT_BALANCE_AUTOREFFILLENABLED` - auto refill enabled (true/false)
- `LIBRECHAT_BALANCE_REFILLINTERVALVALUE` - refill interval value
- `LIBRECHAT_BALANCE_REFILLINTERVALUNIT` - refill interval unit (days/hours/minutes)
- `LIBRECHAT_BALANCE_REFILLAMOUNT` - refill amount

### Actions

- `LIBRECHAT_ACTIONS_ALLOWEDDOMAINS` - allowed domains for actions (comma-separated)

### Assistants Endpoint

- `LIBRECHAT_ENDPOINTS_ASSISTANTS_DISABLEBUILDER` - disable builder interface (true/false)
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_POLLINTERVALMS` - polling interval in milliseconds
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_TIMEOUTMS` - timeout in milliseconds
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_SUPPORTEDIDS` - supported assistant IDs (comma-separated)
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_EXCLUDEDIDS` - excluded assistant IDs (comma-separated)
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_PRIVATEASSISTANTS` - private assistants only (true/false)
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_RETRIEVALMODELS` - retrieval models (comma-separated)
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_CAPABILITIES` - capabilities (comma-separated)

### Agents Endpoint

- `LIBRECHAT_ENDPOINTS_AGENTS_RECURSIONLIMIT` - default recursion depth
- `LIBRECHAT_ENDPOINTS_AGENTS_MAXRECURSIONLIMIT` - max recursion depth
- `LIBRECHAT_ENDPOINTS_AGENTS_DISABLEBUILDER` - disable builder interface (true/false)
- `LIBRECHAT_ENDPOINTS_AGENTS_MAXCITATIONS` - maximum total citations
- `LIBRECHAT_ENDPOINTS_AGENTS_MAXCITATIONSPERFILE` - maximum citations per file
- `LIBRECHAT_ENDPOINTS_AGENTS_MINRELEVANCESCORE` - minimum relevance score (0.0-1.0)
- `LIBRECHAT_ENDPOINTS_AGENTS_CAPABILITIES` - capabilities (comma-separated)

### Custom Endpoints (indexed from 0)

For each custom endpoint (replace `N` with index: 0, 1, 2, etc.):

#### Basic Parameters

- `LIBRECHAT_ENDPOINTS_CUSTOM_N_NAME` - endpoint name
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_APIKEY` - API key
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_BASEURL` - base URL
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_TITLEMODEL` - model for titles
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_MODELDISPLAYLABEL` - display label

#### Boolean Parameters

- `LIBRECHAT_ENDPOINTS_CUSTOM_N_TITLECONVO` - enable title conversation (true/false)
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_SUMMARIZE` - enable summarization (true/false)
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_FORCEPROMPT` - force prompt parameter (true/false)
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_MODELS_FETCH` - fetch models from API (true/false)

#### Models Configuration

- `LIBRECHAT_ENDPOINTS_CUSTOM_N_MODELS_DEFAULT` - default models (comma-separated, quoted)

#### Headers and Parameters

- `LIBRECHAT_ENDPOINTS_CUSTOM_N_HEADERS` - headers (key:value,key:value format)
- `LIBRECHAT_ENDPOINTS_CUSTOM_N_DROPPARAMS` - parameters to drop (comma-separated, quoted)

### Array Format Examples

For arrays, use comma-separated format with quotes:

- `LIBRECHAT_ENDPOINTS_CUSTOM_0_MODELS_DEFAULT='"model1", "model2", "model3"'`
- `LIBRECHAT_REGISTRATION_SOCIALLOGINS='"github", "google", "discord"'`
- `LIBRECHAT_ENDPOINTS_ASSISTANTS_CAPABILITIES='"code_interpreter", "retrieval", "actions"'`

### Headers Format Example

For headers, use `key:value,key:value` format:

- `LIBRECHAT_ENDPOINTS_CUSTOM_0_HEADERS=x-api-key:value,authorization:Bearer token`

## Usage

### 1. Build Image

```bash
cd src/librechat/image
docker build -t librechat-custom .
```

### 2. Use with Existing Build System

```bash
cd src/librechat
./build.sh
cd build/letsencrypt/base
docker-compose up -d
```

### 3. Direct Run

```bash
docker run -d \
  --name librechat \
  -p 3080:3080 \
  -e MONGO_URI=mongodb://mongo:27017/LibreChat \
  -e LIBRECHAT_INTERFACE_CUSTOMWELCOME="Welcome to LibreChat!" \
  -e LIBRECHAT_ENDPOINTS_CUSTOM_0_NAME=OpenRouter \
  -e LIBRECHAT_ENDPOINTS_CUSTOM_0_APIKEY=your-api-key \
  librechat-custom
```

## Configuration Examples

### Minimal Configuration

```bash
LIBRECHAT_VERSION=1.2.1
LIBRECHAT_CACHE=true
LIBRECHAT_INTERFACE_CUSTOMWELCOME=Welcome to LibreChat!
```

### Full Configuration with Custom Endpoint

```bash
# Basic settings
LIBRECHAT_VERSION=1.2.1
LIBRECHAT_CACHE=true

# Interface
LIBRECHAT_INTERFACE_CUSTOMWELCOME=Welcome to LibreChat!
LIBRECHAT_INTERFACE_FILESEARCH=true
LIBRECHAT_INTERFACE_AGENTS=true

# OpenRouter endpoint
LIBRECHAT_ENDPOINTS_CUSTOM_0_NAME=OpenRouter
LIBRECHAT_ENDPOINTS_CUSTOM_0_APIKEY=${OPENROUTER_KEY}
LIBRECHAT_ENDPOINTS_CUSTOM_0_BASEURL=https://openrouter.ai/api/v1
LIBRECHAT_ENDPOINTS_CUSTOM_0_MODELS_DEFAULT='"anthropic/claude-sonnet-4:online"'
LIBRECHAT_ENDPOINTS_CUSTOM_0_TITLECONVO=true
LIBRECHAT_ENDPOINTS_CUSTOM_0_MODELDISPLAYLABEL=OpenRouter

# Groq endpoint
LIBRECHAT_ENDPOINTS_CUSTOM_1_NAME=Groq
LIBRECHAT_ENDPOINTS_CUSTOM_1_APIKEY=${GROQ_API_KEY}
LIBRECHAT_ENDPOINTS_CUSTOM_1_BASEURL=https://api.groq.com/openai/v1/
LIBRECHAT_ENDPOINTS_CUSTOM_1_MODELS_DEFAULT='"llama3-70b-8192", "mixtral-8x7b-32768"'
```

## Debugging

To view the generated configuration:

```bash
docker logs librechat
```

The configuration is output to logs during container startup.

## Extending Functionality

To add new configuration parameters:

1. Add variable handling in `scripts/build-config.sh`
2. Add example in `components/base/.env.example`
3. Update documentation

## Compatibility

- Compatible with existing component build system
- Supports all parameters from official LibreChat documentation
- Backward compatibility with inline configuration (if needed)
