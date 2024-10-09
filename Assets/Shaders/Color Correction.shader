Shader "Custom/LUTShader"
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LUT ("LUT", 2D) = "white" {}
        _Contribution ("Contribution", Range(0, 1)) = 1
    }

    SubShader 
    {
        Tags { "RenderType" = "Opaque" }
        
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _LUT;
            float _Contribution;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                // Add other attributes if needed
            };

            struct v2f 
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v) 
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 lutColor = tex2D(_LUT, col.rgb);
                return lerp(col, lutColor, _Contribution);
            }
            ENDCG
        }
    }
}
