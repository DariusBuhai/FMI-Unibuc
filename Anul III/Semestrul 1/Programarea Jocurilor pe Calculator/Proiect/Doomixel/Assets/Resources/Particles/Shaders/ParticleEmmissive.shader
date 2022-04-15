Shader "Galactic Sudios/Ultra Emissive Particles"
{
	Properties 
	{
_DiffuseColor("_DiffuseColor", Color) = (0.5019608,0.5019608,0.5019608,1)
_Emission("_Emission", Float ) = 1
_MainTex("_MainTex", 2D) = "black" {}
	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Transparent"
"IgnoreProjector"="True"
"RenderType"="Transparent"
		}

		
Cull Off
ZWrite On
ZTest LEqual
ColorMask RGBA
Fog{
}


		CGPROGRAM
#pragma surface surf Lambert nolightmap alpha decal:add vertex:vert
#pragma target 3.0


float4 _DiffuseColor;
float _Emission;
sampler2D _MainTex;

			//struct SurfaceOutput {
			//	half3 Albedo;
			//	half3 Normal;
			//	half3 Emission;
			//};
			

			
			struct Input {
				float2 uv_MainTex;
			};

			void vert (inout appdata_full v, out Input o) {
				UNITY_INITIALIZE_OUTPUT(Input,o);
			}
			

			void surf (Input IN, inout SurfaceOutput o) {
				o.Normal = float3(0.0,0.0,1.0);
				o.Albedo = 0.0;
				o.Emission = 0.0;
				
				float4 MainTex = tex2D(_MainTex,(IN.uv_MainTex.xyxy).xy);
				float4 DiffuseTint = _DiffuseColor * MainTex;
				o.Albedo = DiffuseTint;
				o.Emission = DiffuseTint*_Emission;
				o.Normal = normalize(o.Normal);
			}
		ENDCG
	}
	Fallback "ParticleAdditive"
}