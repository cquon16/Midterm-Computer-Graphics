Shader "Custom/LambertLightingShader"
{
    Properties
    {
        _MainTex("Albedo (Base Texture)", 2D) = "white" {} // The main texture (albedo map)
        _Color("Color Tint", Color) = (1,1,1,1) // Tint to multiply with the texture color
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert // Use Lambert lighting model

        // Declare textures and properties
        sampler2D _MainTex; // Base texture (albedo map)
        fixed4 _Color; // Tint color to apply to the base texture

        struct Input
        {
            float2 uv_MainTex; // UV coordinates for texture sampling
        };

        // surf function: defines how the surface should appear
        void surf(Input IN, inout SurfaceOutput o)
        {
            // Sample the base texture using the UV coordinates
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            
            // Multiply the sampled texture color with the tint color
            o.Albedo = tex.rgb * _Color.rgb; // Set the surface color (albedo)
        }
        ENDCG
    }

    // Fall back to the default diffuse shader if necessary
    FallBack "Diffuse"
}
