Shader "Custom/NormalMapping"
{
    Properties
    {
        _MainTex ("Diffuse Texture", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Sample the base color from the diffuse texture
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;

            // Unpack the normal map and transform it to the tangent space
            half3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Normal = normal; // Directly assign the normal
        }
        ENDCG
    }
    FallBack "Diffuse"
}
