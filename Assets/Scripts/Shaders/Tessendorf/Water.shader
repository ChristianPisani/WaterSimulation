Shader "Tessendorf/Water"
{
	Properties
	{
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Emission("Emission", Color) = (0,0,0)

		_Distortion("Distortion", float) = 0.5
		_Power("Power", float) = 1
		_Scale("Scale", float) = 1
		_Attenuation("Attenuation", float) = 1
		_Ambient("Ambient", Color) = (1,1,1,1)

		_EdgeLength("Edge length", Range(0.1,50)) = 5
		_Phong("Edge Phong Strengh", Range(0,1)) = 0.5

		_ColorTop("Color top", Color) = (1,1,1,1)
		_ColorBottom("Color bottom", Color) = (1,1,1,1)
		_ColorLerpStrength("Color lerp strength", Range(-1, 1)) = 0

		_HeightMap("Heightmap", 2D) = "bump" {}
		_NormalMap("Normalmap", 2D) = "bump" {}
		_ChoppyMap("Choppymap", 2D) = "bump" {}
		_DisplacementStrength("Heightmap displacement strength", Range(0, 4)) = 1

		_Normal1("Normal 1", 2D) = "bump" {}
		_Normal1Speed("Normal 1 Speed", Vector) = (0.5, 0, 0)
		_Normal1Scale("Normal 1 Scale", Range(0, 4)) = 0.5

		_Normal2("Normal 2", 2D) = "bump" {}
		_Normal2Speed("Normal 2 Speed", Vector) = (-0.5, 0, 0)
		_Normal2Scale("Normal 2 Scale", Range(0, 4)) = 0.75

		_Normal3("Normal 3", 2D) = "bump" {}
		_Normal3Speed("Normal 3 Speed", Vector) = (0, 1.0, 0)
		_Normal3Scale("Normal 3 Scale", Range(0, 4)) = 1.0

		_NormalStrength("NormalStrength", Range(-100, 100)) = 0.5

		_NeighbourDistance("NeighbourDistance", Range(0.0001,1)) = 0.01
		_TimeScale("Timescale", Range(0, 20)) = 10
	}
		SubShader
		{
			Tags { "Queue" = "Opaque" "IgnoreProjector" = "true" "ForceNoShadowCasting" = "False"  "RenderType" = "Opaque" }
			ZWrite on
			Cull off
			LOD 600

			GrabPass { "_BackgroundTexture" }

			CGPROGRAM
			#pragma surface surf StandardTranslucent vertex:vert fullforwardshadows addshadow
			//#pragma tessellate:tessEdge
			

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "Tessellation.cginc"

		sampler2D _BackgroundTexture;

		sampler2D _DepthTexture;
		
		sampler2D _HeightMap;
		sampler2D _NormalMap;
		sampler2D _ChoppyMap;
		
		sampler2D _Normal1;
		sampler2D _Normal2;
		sampler2D _Normal3;

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
		};

		half _Glossiness;
		half _Metallic;
		fixed3 _Emission;
		fixed4 _ColorTop;
		fixed4 _ColorBottom;
		float _ColorLerpStrength;

		half _NormalStrength;
		float2 _Normal1Speed;
		float2 _Normal2Speed;
		float2 _Normal3Speed;

		half _Normal1Scale;
		half _Normal2Scale;
		half _Normal3Scale;

		fixed4 color;

		float _Phong;
		float _EdgeLength;

		float thickness = 0.5;

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
			I.r *= 0.25;
			I.g *= 0.7;
			I.b *= 0.8;

			pbr.rgb = pbr.rgb + gi.light.color * I;
			return pbr;
		}

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}

		float4 tessEdge(appdata_full v0, appdata_full v1, appdata_full v2)
		{
			return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		float4 tessDistance(appdata_full v0, appdata_full v1, appdata_full v2) {
			float minDist = 2.0;
			float maxDist = 20.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _EdgeLength);
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float4 vertex = IN.color;
			float4 colorBase = lerp(0, 1, saturate(vertex.y - _ColorLerpStrength));

			o.Albedo = lerp(_ColorBottom, _ColorTop, colorBase.r);

			float4 hpos = UnityObjectToClipPos(vertex);
			float4 grabUV = ComputeGrabScreenPos(hpos);

			float sceneZ = LinearEyeDepth(tex2Dproj(_DepthTexture, UNITY_PROJ_COORD(IN.screenPos)).r);

			half4 background = tex2Dproj(_BackgroundTexture, UNITY_PROJ_COORD(grabUV + sin(vertex.g)));
			background.r *= 0.25;
			background.g *= 0.7;
			background.b *= 0.8;

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
			
			float4 worldPos = mul(unity_ObjectToWorld, v.vertex) * 0.1;
			
			float d = tex2Dlod(_HeightMap, float4(abs(worldPos.x) % 1, abs(worldPos.z) % 1, 0, 0)).r;
			float2 choppy = tex2Dlod(_ChoppyMap, float4(abs(worldPos.x) % 1, abs(worldPos.z) % 1, 0, 0)).rg;
			float2 normal = tex2Dlod(_NormalMap, float4(abs(worldPos.x) % 1, abs(worldPos.z) % 1, 0, 0)).rg;
			//fixed d = tex2Dlod(_HeightMap, v.texcoord).r;
			//float2 normal = tex2Dlod(_NormalMap, v.texcoord).rg;
			
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
