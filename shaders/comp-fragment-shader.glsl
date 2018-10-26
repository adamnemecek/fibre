precision highp float;

uniform sampler2D Fluence;
uniform float invNpasses;
uniform float exposure;
uniform float invGamma;
uniform float time;
uniform bool dashes;
uniform float dash_spacing;
uniform float dash_speed;

in vec2 vTexCoord;
out vec4 outputColor;

void main() 
{
    // Read normalized fluence and time delay (integrated along primary rays)
    vec4 image = float(invNpasses) * texture(Fluence, vTexCoord);
    vec3 fluence = image.rgb;
    vec3 emission = fluence ;

    // Apply exposure 
    float gain = pow(2.0, exposure);
    float r = gain*emission.x; 
    float g = gain*emission.y; 
    float b = gain*emission.z;

    // Reinhard tonemap
    vec3 C = vec3(r/(1.0+r), g/(1.0+g), b/(1.0+b));

    // Apply gamma
    C = pow(C, vec3(invGamma));

    // Optionally render moving dashes
    float modulation = 1.0;
    if (dashes)
    {
        float t = image.w;
        modulation = step(0.0, cos(t/dash_spacing - dash_speed*time));
    }
        

    outputColor = vec4(modulation*C, 1.0);
}
