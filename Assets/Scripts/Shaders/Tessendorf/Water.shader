// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Tessendorf/Water"
{
	Properties
	{
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(-1,1)) = 0.0

		_Distortion("Distortion", float) = 0.5
		_Power("Power", float) = 1
		_Scale("Scale", float) = 1
		_Attenuation("Attenuation", float) = 1
		_Ambient("Ambient", Color) = (1,1,1,1)

		_TesselationStrength("Tesselation strength", Range(0,1000)) = 5
		_Phong("Phong Strengh", Range(0,1)) = 0.5

		_ColorTop("Color top", Color) = (1,1,1,1)
		_ColorBottom("Color bottom", Color) = (1,1,1,1)
		_ColorLerpStrength("Color lerp strength", Range(-1, 1)) = 0

		_HeightMap("Heightmap", 2D) = "bump" {}
		_NormalMap("Normalmap", 2D) = "bump" {}
		_ChoppyMap("Choppymap", 2D) = "bump" {}
		_DisplacementStrength("Heightmap displacement strength", Range(0, 4)) = 1
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "true" "ForceNoShadowCasting" = "True"  "RenderType" = "Opaque" }
			ZWrite on
			Cull off
			LOD 600

			GrabPass { "_BackgroundTexture" }

			CGPROGRAM
			#pragma surface surf StandardTranslucent tessellate:tessDistance tessphong:_Phong vertex:vert fullforwardshadows addshadow
			//#pragma tessellate:tessEdge


			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "Tessellation.cginc"

		sampler2D _BackgroundTexture;

		sampler2D _HeightMap;
		sampler2D _NormalMap;
		sampler2D _ChoppyMap;

		float _Power;
		float _Scale;
		float _Distortion;
		float _Attenuation;
		float4 _Ambient;

		float _NeighbourDistance;
		float _TimeScale;

		struct Input
		{
			float3 worldPos;
			float4 color : COLOR;
			float4 screenPos;
			float4 grabUV;
			float eyeDepth;
		};

		half _Glossiness;
		half _Metallic;

		fixed3 _Emission;
		fixed4 _ColorTop;
		fixed4 _ColorBottom;
		float _ColorLerpStrength;

		sampler2D _CameraDepthTexture;

		float _TesselationStrength;
		float _Phong;

		#include "UnityPBSLighting.cginc"
		inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			// Original colour
			fixed4 pbr = LightingStandard(s, viewDir, gi);

			float3 L = gi.light.dir;
			float3 V = viewDir;
			float3 N = s.Normal;

			float3 H = normalize(L + N * _Distortion);
			float VdotH = pow(saturate(dot(V, -H)), _Power) * _Scale;

			float thickness = lerp(0.1, 0.8, dot(N, -float3(1,0.25,1)));

			float3 I = _Attenuation * (VdotH + _Ambient) * thickness;

			// Fake wavelength 
			I.r *= 0.65;
			I.g *= 0.8;
			I.b *= 0.9;

			pbr.rgb = pbr.rgb + gi.light.color * I;
			return pbr;
		}

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}

		float4 tessEdge(appdata_full v0, appdata_full v1, appdata_full v2)
		{
			return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _TesselationStrength);
		}

		float4 tessDistance(appdata_full v0, appdata_full v1, appdata_full v2) {
			float minDist = 0.0;
			float maxDist = 200.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _TesselationStrength);
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float4 vertex = IN.color;
			float4 colorBase = lerp(0, 1, saturate(vertex.y - _ColorLerpStrength));
			
			float4 hpos = UnityObjectToClipPos(vertex);
			float4 grabUV = ComputeGrabScreenPos(hpos);

			float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos)).r;
			float existingDepthLinear = LinearEyeDepth(existingDepth01);
			float depthDifference = existingDepthLinear - IN.eyeDepth;
			float waterDepthDifference01 = saturate(depthDifference / 10.0);

			o.Albedo = lerp(_ColorBottom, _ColorTop, colorBase.r);
			
			float4 emUV = grabUV;

			if (waterDepthDifference01 > 0.0 && waterDepthDifference01 < 2) {
				emUV += float4(sin(o.Normal.x * 4.0) * 0.4, 0, 0, cos(o.Normal.z * 4.0) * 0.4);
			}

			half4 background = tex2Dproj(_BackgroundTexture, emUV);
			background.r *= 0.65;
			background.g *= 0.8;
			background.b *= 0.9;

			o.Emission = background * 0.5;


			o.Metallic = _Metallic;
			
			o.Smoothness = _Glossiness;

			float time = _Time * _TimeScale;
		}

		float3 GetNormal(float3 pos, float3 offsetX, float3 offsetZ) {
			return cross(normalize(offsetX - pos), normalize(offsetZ - pos));
		}

		void vert(inout appdata_full v) {
			//UNITY_INITIALIZE_OUTPUT(Input, o);

			float4 worldPos = mul(unity_ObjectToWorld, v.vertex) * 0.06;

			//float d = tex2Dlod(_HeightMap, float4(abs(worldPos.x) % 1, abs(worldPos.z) % 1, 0, 0)).r;


			float tiledX = abs(worldPos.x) % 1.0;
			float tiledZ = abs(worldPos.z) % 1.0;
			v.texcoord = float4(tiledX, tiledZ, 0, 1);

			//float2 choppy = tex2Dlod(_ChoppyMap, float4(tiledX, tiledZ, 0, 0)).rg;
			//float2 normal = tex2Dlod(_NormalMap, float4(tiledX, tiledZ, 0, 0)).rg;
			float2 choppy = tex2Dlod(_ChoppyMap, v.texcoord % 1).rg;

			float sampleSize = 1.0 / 1024.0;
			float2 normalSample1 = tex2Dlod(_NormalMap, v.texcoord % 1).rg;
			float2 normalSample2 = tex2Dlod(_NormalMap, (v.texcoord + float4(sampleSize, 0, 0, 0)) % 1).rg;
			float2 normalSample3 = tex2Dlod(_NormalMap, (v.texcoord + float4(0, sampleSize, 0, 0)) % 1).rg;
			float2 normalSample4 = tex2Dlod(_NormalMap, (v.texcoord + float4(sampleSize, sampleSize, 0, 0)) % 1).rg;
			//float2 normal = (normalSample1 + normalSample2 + normalSample3 + normalSample4) / 4.0;
			fixed d = tex2Dlod(_HeightMap, v.texcoord).r;

			float distance = length(mul(unity_ObjectToWorld, v.vertex) - _WorldSpaceCameraPos);
			float2 normal = tex2Dlod(_NormalMap, v.texcoord).rg / (distance / 50.0);

			v.vertex.y = d;
			v.vertex.xz += choppy;
			v.normal.xyz = float3(-normal.x, 1, -normal.y);

			v.color = v.vertex;
		}
		ENDCG

		CGINCLUDE
		float2 TileAndOffset(float2 uv, float scale, float2 offset) {
			return (uv + offset) * scale;
		}

		half3 HandleNormal(sampler2D normal, float2 uv, float scale, float2 speed, float time) {
			float2 uvTile = TileAndOffset(uv, scale, speed * time);

			return UnpackNormal(tex2D(normal, uvTile));
		}

		half3 MultiBlendNormals(half3 n1, half3 n2, half3 n3) {
			return BlendNormals(BlendNormals(n1, n2), n3);
		}
		ENDCG
		}
}
