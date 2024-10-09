Shader "Custom/DiffuseWrap"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _WrapFactor("Wrap Factor", Range(0, 1)) = 0.5 // Define wrap factor as a property
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf WrapLambert

        // Include the wrap factor as a uniform so it can be used in the shader
        uniform float _WrapFactor; 

        half4 LightingWrapLambert(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            // Apply wrap factor to control light spreading
            half diff = NdotL * _WrapFactor + (1 - _WrapFactor); 
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
