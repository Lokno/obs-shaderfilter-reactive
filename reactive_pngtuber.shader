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
> = 0.3;

uniform float min_intensity<
    string label = "Inactive Minimum Intensity";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.3;

uniform bool swap_on_talk<
    string label = "Swap to Talk Image/Source";
    string widget_type = "check";
> = false;

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

uniform texture2d talk_texture;

float4 mainImage(VertData v_in) : TARGET
{
    float I = min_intensity + (1.0-min_intensity)*step(threshold,audio_magnitude);

    float4 col;
    float2 uv = v_in.uv;

    if( squish && audio_magnitude >= threshold )
    {
        float curr_bounce = audio_magnitude*amount;
        float y = (uv.y-curr_bounce)*(1.0/(1.0-curr_bounce));
        uv = float2(uv.x,y);
    }

    if( audio_magnitude < threshold )
    {
        col = image.Sample(textureSampler, uv);
        col = float4(col.rgb*min_intensity, col.a);
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
            col = lerp(image.Sample(textureSampler, uv),talk_texture.Sample(textureSampler, uv),I);
        }
        else
        {
             col = image.Sample(textureSampler, uv);
        }
        
        col = float4(col.rgb*I, col.a);
    }

    return col;
}
