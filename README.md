# TitanLRS Web Flasher

Web-hosted flasher for TitanLRS firmware (ExpressLRS fork for Titan Dynamics).

Based on the official [ExpressLRS Web Flasher](https://github.com/ExpressLRS/web-flasher).

## Supported Flashing Methods

- UART (Receivers do not need to be in bootloader mode)
- Betaflight passthrough
- EdgeTX passthrough
- STLink

## Developing and Testing Locally

### 1. Download Firmware

Download TitanLRS firmware from GitHub Releases:

```bash
./get_artifacts.sh 4.0.0-TD
```

To download a specific version, pass it as an argument:

```bash
./get_artifacts.sh <version>
```

If the backpack release uses a different version than the main firmware, pass it as a second argument:

```bash
./get_artifacts.sh <firmware-version> <backpack-version>
```

Available versions: https://github.com/wvarty/TitanLRS/releases

### 2. Install Dependencies

```bash
npm install
```

### 3. Start Development Server

```bash
npm run dev
```

The development server will start (typically at http://localhost:5173).

### 4. Build for Production

```bash
npm run build
```

The built files will be in the `dist/` directory.

## Firmware Structure

The `get_artifacts.sh` script downloads firmware from TitanLRS GitHub Releases and creates the following structure:

```
public/assets/
├── firmware/
│   ├── index.json           # Version index
│   ├── {VERSION}/           # e.g., 4.0.0-TD
│   │   ├── FCC/            # FCC region firmware
│   │   ├── LBT/            # LBT region firmware
│   │   └── hardware/
│   └── hardware/
│       └── targets.json
└── backpack/
    └── index.json
```

## Repository Information

- **Web Flasher Fork**: https://github.com/wvarty/web-flasher
- **Firmware Source**: https://github.com/wvarty/TitanLRS/releases
- **Upstream**: https://github.com/ExpressLRS/web-flasher

## License

Developed by the ExpressLRS community. Adapted for TitanLRS by Titan Dynamics.
