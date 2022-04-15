Shader "Unlit/FloorShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [Toggle] _IsCeiling ("Is Ceiling", Float) = 0
         _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 color : COLOR0;
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            float4 _Color;
            float _IsCeiling;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = _Color;
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = i.color;
                fixed4 texColor = tex2D(_MainTex, i.uv);

                float4 result = texColor * col;

                float yDifference = 0.5f - (i.screenPos.y / i.screenPos.w);
                if (_IsCeiling)
                    yDifference = -yDifference;
                result.rgb *= 2.0f * yDifference;
                
                return result;
            }
            ENDCG
        }
    }
}
