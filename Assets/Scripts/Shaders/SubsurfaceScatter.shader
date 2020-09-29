Shader "Custom/SubsurfaceScatter"
{
	Properties
	{
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Emission("Emission", Color) = (0,0,0)
		_Albedo("Albedo", Color) = (0,0,0)

		_Distortion("Distortion", float) = 0.5
		_Power("Power", float) = 1
		_Scale("Scale", float) = 1
		_Attenuation("Attenuation", float) = 1
		_Ambient("Ambient", Color) = (1,1,1,1)
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "true" "ForceNoShadowCasting" = "True"  "RenderType" = "Opaque" }
			ZWrite on
			Cull off
			LOD 600

			CGPROGRAM
			#pragma surface surf StandardTranslucent fullforwardshadows addshadow
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "Tessellation.cginc"

		float _Power;
		float _Scale;
		float _Distortion;
		float _Attenuation;
		float4 _Ambient;

		struct Input
		{
			float3 worldPos;
			float4 color : COLOR;
			float4 screenPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed3 _Emission;
		fixed4 _Albedo;
		
		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)		
		
		#include "UnityPBSLighting.cginc"
		inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			fixed4 pbr = LightingStandard(s, viewDir, gi);

			float3 L = gi.light.dir;
			float3 V = viewDir;
			float3 N = s.Normal;

			float3 H = normalize(L + N * _Distortion);
			float VdotH = pow(saturate(dot(V, -H)), _Power) * _Scale;

			float3 thickness = lerp(0.1, 1, saturate((N.x - N.y + N.z)));

			float3 I = _Attenuation * (VdotH + _Ambient) * thickness;
			
			pbr.rgb = pbr.rgb + gi.light.color * I;

			return pbr;
		}

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Albedo = _Albedo;
			o.Emission = _Emission;
		}
		ENDCG
		}
	FallBack "Diffuse"
}
