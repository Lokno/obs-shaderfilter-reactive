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

uniform bool use_talk_texture<
    string label = "Use Talk Texture";
    string widget_type = "check";
> = false;

uniform texture2d talk_texture;

float4 mainImage(VertData v_in) : TARGET
{
    float I = min_intensity + (1.0-min_intensity)*step(threshold,audio_magnitude);

    float4 col;

    if( audio_magnitude < threshold )
    {
        col = image.Sample(textureSampler, v_in.uv);
        col = float4(col.rgb*min_intensity, col.a);
    }
    else if( audio_magnitude > full_threshold )
    {
        if( use_talk_texture )
        {
            col = talk_texture.Sample(textureSampler, v_in.uv);
        }
        else
        {
            col = image.Sample(textureSampler, v_in.uv);
        }
        
    }
    else
    {
        I = lerp(min_intensity,full_threshold,(audio_magnitude-threshold)*(1.0/(full_threshold-min_intensity)));

        if( use_talk_texture )
        {
            col = lerp(image.Sample(textureSampler, v_in.uv),talk_texture.Sample(textureSampler, v_in.uv),I);
        }
        else
        {
             col = image.Sample(textureSampler, v_in.uv);
        }
        
        col = float4(col.rgb*I, col.a);
    }

    return col;
}
