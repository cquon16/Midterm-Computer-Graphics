Shader "Custom/ToonShader"
{
    Properties
    {
        // Base color for the lit area of the object
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        
        // Middle color for semi-lit areas
        _MiddleColor("Middle Color", Color) = (0.75, 0.75, 0.75, 1)
        
        // Shadow color for darker areas
        _ShadowColor("Shadow Color", Color) = (0.5, 0.5, 0.5, 1)
        
        // Threshold to determine where light transitions to middle color
        _Threshold1("Threshold Light to Middle", Range(0, 1)) = 0.5
        
        // Threshold to determine where middle color transitions to shadow
        _Threshold2("Threshold Middle to Shadow", Range(0, 1)) = 0.25
    }
    SubShader
    {
        // Tag to specify this shader renders as opaque (no transparency)
        Tags { "RenderType" = "Opaque" }
        LOD 200 // Level of detail for shader

        Pass
        {
            // Start of the Cg (shader language) program
            CGPROGRAM
            #pragma vertex vert // Defines the vertex function
            #pragma fragment frag // Defines the fragment function (pixel shader)

            #include "UnityCG.cginc" // Include Unity's common shader functions

            // Input data from the vertex shader
            struct appdata_t
            {
                float4 vertex : POSITION; // Vertex position in 3D space
                float3 normal : NORMAL;   // Vertex normal for lighting calculations
            };

            // Data passed from vertex shader to fragment shader
            struct v2f
            {
                float4 pos : SV_POSITION; // Screen-space position
                float3 normal : NORMAL;   // Normal vector for lighting
            };

            // Properties passed in from the editor
            float4 _BaseColor;   // Color for fully lit areas
            float4 _MiddleColor; // Color for partially lit areas
            float4 _ShadowColor; // Color for shadowed areas
            float _Threshold1;   // Threshold for light-to-middle transition
            float _Threshold2;   // Threshold for middle-to-shadow transition

            // Vertex shader: processes vertices before rendering
            v2f vert(appdata_t v)
            {
                v2f o;
                // Convert object space vertex to screen space
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // Normalize the normal vector for consistent lighting calculations
                o.normal = normalize(v.normal);
                return o;
            }

            // Fragment shader: determines the final pixel color
            fixed4 frag(v2f i) : SV_Target
            {
                // Define the light direction (can be customized for different effects)
                float3 lightDir = normalize(float3(1, 1, -1)); // Example: light coming from the top-right
                
                // Calculate light intensity based on the angle between light direction and surface normal
                float intensity = max(dot(i.normal, lightDir), 0.0);

                // Determine the color based on the intensity of the light
                fixed4 color;
                if (intensity > _Threshold1)
                {
                    color = _BaseColor; // Fully lit area
                }
                else if (intensity > _Threshold2)
                {
                    color = _MiddleColor; // Partially lit (middle) area
                }
                else
                {
                    color = _ShadowColor; // Dark (shadowed) area
                }

                return color; // Return the calculated color
            }
            ENDCG // End of the Cg program
        }
    }
    FallBack "Diffuse" // Fallback shader in case this one isn't supported
}

