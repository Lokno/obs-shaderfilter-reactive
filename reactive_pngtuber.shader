uniform float audio_magnitude;

uniform float threshold<
    string label = "Activation Threshold";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.1;

uniform float full_threshold<
    string label = "Full Activation Threshold";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.2;

uniform float min_intensity<
    string label = "Inactive Minimum Intensity";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.5;

uniform bool swap_on_talk<
    string label = "Swap to Talk Texture";
    string widget_type = "check";
> = false;

uniform bool blink<
    string label = "Blink?";
    string widget_type = "check";
> = false;

uniform float blink_freq<
    string label = "Blink Frequency";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 30.0;
    float step = 1.0;
> = 9.0;

uniform float blink_dur<
    string label = "Blink Duration";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.09;

uniform bool squish<
    string label = "Squish?";
    string widget_type = "check";
> = false;

uniform float amount<
    string label = "Maximum Squish Height";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.1;

uniform texture2d blink_texture;
uniform texture2d talk_texture;

float rand(float2 co){
  return frac(sin(dot(co.xy,float2(12.9898,78.233))) * 43758.5453);
}

float4 mainImage(VertData v_in) : TARGET
{
    float I = min_intensity + (1.0-min_intensity)*step(threshold,audio_magnitude);

    float4 col;
    float2 uv = v_in.uv;
    float4 baseCol;

    if( squish && audio_magnitude >= threshold )
    {
        float curr_bounce = audio_magnitude*amount;
        float y = (uv.y-curr_bounce)*(1.0/(1.0-curr_bounce));
        uv = float2(uv.x,y);
    }

    float blink_offset = rand(float2(floor(elapsed_time_active/blink_freq),1.0));

    if( blink && fmod(elapsed_time_active+blink_offset,blink_freq) < (blink_dur) )
    {
        baseCol = blink_texture.Sample(textureSampler, uv);
    }
    else
    {
        baseCol = image.Sample(textureSampler, uv);
    }

    if( audio_magnitude < threshold )
    {
        col = float4(baseCol.rgb*min_intensity, baseCol.a);
    }
    else if( audio_magnitude > full_threshold )
    {
        if( swap_on_talk )
        {
            col = talk_texture.Sample(textureSampler, uv);
        }
        else
        {
            col = image.Sample(textureSampler, uv);
        }
        
    }
    else
    {
        I = lerp(min_intensity,full_threshold,(audio_magnitude-threshold)*(1.0/(full_threshold-min_intensity)));

        if( swap_on_talk )
        {
            col = lerp(baseCol,talk_texture.Sample(textureSampler, uv),I);
        }
        else
        {
             col = baseCol;
        }
        
        col = float4(col.rgb*I, col.a);
    }

    return col;
}
