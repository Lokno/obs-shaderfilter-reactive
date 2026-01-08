# obs-shaderfilter-reactive
Creates a PNGTuber on an image source in OBS Studio using obs-shaderfilter

## Features
- fades brightness with audio (adjustable)
- swap to talk texture (optional)
- swap to blink texture an interval (optional)
- swap to scream texture (optional)
- squishes with volume (optional)

## How to use
- Install obs-shaderfilter 2.6.0+ (https://github.com/exeldro/obs-shaderfilter/releases)
- Download this entire git repo or just the file named `reactive_pngtuber.shader`
- Add a source to your scene to source as the idle state
- Right-click source and select Filters
- Click the plus sign (+) and select "User-defined shader" (requires obs-shaderfilter)
- You may rename the shader/filter to whatever you like
- With your new filter selected, you should see some options below a preview of your source
- Check the box labeled "Load shader text from file"
- Click the button labeled "Browse" beside the box labeled "Shader text file"
- In your file system, select the file `reactive_pngtuber.shader`
- Select the dropdown labeled "Audio source" and select the audio input you wish to detect
- Basic set-up complete!

![Screenshot from OBS of the Filters Window with a obs-shaderfilter filter added and set to the current shader](images/FilterWindowExample.png)

## Options

Audio source - Source of the audio you wish the shader to react to
Activation Threshold - The value of audio magnitude the image will begin to brighten
Full Activation Threshold - The value of the audio magnitude to image will be at full brightness
Inactive Brightness - The brightness (intensity) of the image when unactive
Swap to Talk Texture (Checkbox) - Whether to swap to a talk texture (image or OBS source) when activated
Blink? (Checkbox) - Whether to swap to a blink texture (image or OBS source) on a blink interval
Blink Frequency - How often the blink texture will appear (in seconds)
Blink Duration - How long the blink texture will appear per interval
Squish? (Checkbox) - Whether to squish the image with proportional to the audio magnitude
Maximum Squish Amount - The percentage of source height to squish on audio magnitude
Swap to Scream Texture (Checkbox) - Whether to swap to a scream texture (image or OBS source) when past the scream threshold
Scream Threshold - The value of audio magnitude to swap to the scream texture
blink texture - obs source or image file to use for the blink texture
talk texture - obs source or image file to user for the talk texture
scream texture - obs source or image file to user for the scream texture
