# et-portaudio

A utility program intended for script use to convert a supported
EmComm Tools ALSA audio device (i.e. `ET_AUDIO`) to a PulseAudio device. 

## Usage

Returns a JSON object with the PulseAudio device details on success.

```bash
./et-portaudio 2>/dev/null
{
  "device": "USB Audio Device: - (hw:1,0)",
  "index": 6
}
```

If no supported device is found or on error, the utility exits with an
exit status of 1.


## Build

``bash
make
```

## Install

```bash
sudo make install
```
