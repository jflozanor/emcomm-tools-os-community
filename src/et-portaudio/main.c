/*
 * Author  : Gaston Gonzalez
 * Date    : 1 October 2025
 * Purpose : Maps an ET_AUDIO ALSA device to a PortAudio device.
 *
 * This utility enumerates all ALSA audio devices using PortAudio
 * to identify a currently plugged-in ET_AUDIO device. If a matching 
 * device is found, it generates a JSON object on STDOUT containing:
 *
 *  - PortAudio device name
 *  - PortAudio device index
 *
 * Exit Status:
 *   0 - ET_AUDIO device found and JSON output generated successfully
 *   1 - ET_AUDIO device not found
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "portaudio.h"

#define PROC_ALSA_PATH_FMT "/proc/asound/card%d/id"

// Read the ALSA card ID from the /proc filesystem
int get_alsa_card_id(int card, char *id_buf, size_t buf_size) {
    char path[64];
    snprintf(path, sizeof(path), PROC_ALSA_PATH_FMT, card);
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    if (!fgets(id_buf, buf_size, f)) {
        fclose(f);
        return -1;
    }
    id_buf[strcspn(id_buf, "\n")] = 0; 
    fclose(f);

    return 0;
}

int main(void) {
    PaError err;
    int i, numDevices;
    const PaDeviceInfo *deviceInfo;
    const PaHostApiInfo *hostApiInfo;
    int found = 0;  

    err = Pa_Initialize();
    if (err != paNoError) {
        fprintf(stderr, "PortAudio error: %s\n", Pa_GetErrorText(err));
        return 1;
    }

    numDevices = Pa_GetDeviceCount();
    if (numDevices < 0) {
        fprintf(stderr, "No audio devices found");
        Pa_Terminate();
        return 1;
    }

    for (i = 0; i < numDevices; i++) {
        deviceInfo = Pa_GetDeviceInfo(i);
        hostApiInfo = Pa_GetHostApiInfo(deviceInfo->hostApi);

        // Only show ALSA devices
        if (hostApiInfo && strcmp(hostApiInfo->name, "ALSA") == 0) {
            int card = -1, device = -1;

            // Extract ALSA card and device (hw:X,Y)
            if (sscanf(deviceInfo->name, "%*[^()](hw:%d,%d)", &card, &device) == 2) {
                char card_id[64];
                if (get_alsa_card_id(card, card_id, sizeof(card_id)) == 0) {

                    // Only print if card ID matches ET_AUDIO
                    if (strcmp(card_id, "ET_AUDIO") == 0) {
                        found = 1;
                        printf("{\n");
                        printf("  \"device\": \"%s\",\n", deviceInfo->name);
                        printf("  \"index\": %d\n", i);
                        printf("}\n");
                    }
                }
            }
        }
    }

    Pa_Terminate();
    return found ? 0 : 1;
}
