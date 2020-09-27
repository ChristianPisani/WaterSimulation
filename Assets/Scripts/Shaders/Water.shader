﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Watere"
{
    Properties
    {
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_EdgeLength("Edge length", Range(2,50)) = 5
		_Phong("Phong Strengh", Range(0,1)) = 0.5

		_ColorTop ("Color top", Color) = (1,1,1,1)
		_ColorBottom("Color bottom", Color) = (1,1,1,1)
		_ColorLerpStrength("Color lerp strength", Range(-1, 1)) = 0
		
		_Normal1 ("Bump", 2D) = "bump" {}
		_Normal1Speed("Normal 1 Speed", Range(-1, 1)) = 0.5
		_Normal1Scale("Normal 1 Scale", Range(0, 4)) = 0.5
		
		_Normal2 ("Bump", 2D) = "bump" {}
		_Normal2Speed("Normal 2 Speed", Range(-1, 1)) = -0.5
		_Normal2Scale("Normal 2 Scale", Range(0, 4)) = 0.75
		
		_Normal3 ("Bump", 2D) = "bump" {}
		_Normal3Speed("Normal 3 Speed", Range(-1, 1)) = 1.0
		_Normal3Scale("Normal 3 Scale", Range(0, 4)) = 1.0

		_NormalStrength("NormalStrength", Range(-1, 1)) = 0.5
		
		_Depth ("Depth", Range(0, 100)) = 10
		_Phase ("Phase", Range(0, 360)) = 0

		_Direction1 ("Direction 1", Vector) = (1,0,0)
		_Amplitude1 ("Amplitude 1", Range(0, 5)) = 1
		_Speed1 ("Speed 2", Range(-5, 5)) = 1
		
		_Direction2("Direction 2", Vector) = (1,0,0)
		_Amplitude2("Amplitude 2", Range(0, 5)) = 1
		_Speed2("Speed 2", Range(-5, 5)) = 1


		_NeighbourDistance("NeighbourDistance", Range(0.0001,1)) = 0.01
		_TimeScale("Timescale", Range(0, 20)) = 10
	}
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha
		Cull off
        LOD 600

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha vertex:vert fragment:frag tessellate:tessEdge tessphong:_Phong
		
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"

		sampler2D _Normal1;
		sampler2D _Normal2;
		sampler2D _Normal3;

		float3 _Direction1;
		float _Amplitude1;
		float _Speed1;
		float3 _Direction2;
		float _Amplitude2;
		float _Speed2;

		
		float _Depth;
		float _Phase;
		float _NeighbourDistance;
		float _TimeScale;

		struct Input
		{
			float3 worldPos;
			float4 color : COLOR;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			fixed3 color : COLOR0;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _ColorTop;
		fixed4 _ColorBottom;
		float _ColorLerpStrength;

		half _NormalStrength;
		half _Normal1Speed;
		half _Normal2Speed;
		half _Normal3Speed;

		half _Normal1Scale;
		half _Normal2Scale;
		half _Normal3Scale;

		fixed4 color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		float _Phong;
		float _EdgeLength;

		float4 tessEdge(appdata_full v0, appdata_full v1, appdata_full v2)
		{
			return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		struct GerstnerWaveStruct {
			float3 position;
			float3 offsetX;
			float3 offsetZ;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = lerp(_ColorBottom, _ColorTop, IN.color);
			o.Alpha = IN.color.a;
			
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			float time = _Time * _TimeScale;
			
			half3 n1 = HandleNormal(_Normal1, IN.worldPos.xz, _Normal1Scale, _Normal1Speed, time);
			half3 n2 = HandleNormal(_Normal2, IN.worldPos.xz, _Normal2Scale, _Normal2Speed, time);
			half3 n3 = HandleNormal(_Normal3, IN.worldPos.xz, _Normal3Scale, _Normal3Speed, time);
			half3 blendedNormals = MultiBlendNormals(n1, n2, n3);
			o.Normal = lerp(float3(0.5, 0.5, 0.5), blendedNormals, _NormalStrength);
		}

		GerstnerWaveStruct GetWave(float3 worldPos, float3 direction, float amplitude, float depth, float phase, float speed, float time) {
			GerstnerWaveStruct wave;
			
			float waveTime = time * speed;

			wave.position = GerstnerWave(worldPos, direction, amplitude, depth, phase, waveTime);

			float3 offsetX = float3(0, 0, _NeighbourDistance);
			float3 offsetZ = float3(_NeighbourDistance, 0, 0);

			wave.offsetX = GerstnerWave(worldPos + offsetX, direction, amplitude, depth, phase, waveTime);
			wave.offsetZ = GerstnerWave(worldPos + offsetZ, direction, amplitude, depth, phase, waveTime);
			
			return wave;
		}

		float3 GetNormal(float3 pos, float3 offsetX, float3 offsetZ) {
			return cross(normalize(offsetX - pos), normalize(offsetZ - pos));
		}

		void vert(inout appdata_full v) {			
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
			
			float time = _Time * _TimeScale;
			
			GerstnerWaveStruct wave1 = GetWave(worldPos, _Direction1, _Amplitude1, _Depth, _Phase, _Speed1, time);
			GerstnerWaveStruct wave2 = GetWave(worldPos, _Direction2, _Amplitude2, _Depth, _Phase, _Speed2, time);

			float3 waveWorldPos = GerstnerWaveToWorld(wave1.position + wave2.position, v.vertex.xyz);
			float3 offsetX = GerstnerWaveToWorld(wave1.offsetX + wave2.offsetX, v.vertex.xyz + float3(0, 0, _NeighbourDistance));
			float3 offsetZ = GerstnerWaveToWorld(wave1.offsetZ + wave2.offsetZ, v.vertex.xyz + float3(_NeighbourDistance, 0, 0));
			
			v.vertex.xyz = waveWorldPos;
			v.normal.xyz = GetNormal(waveWorldPos, offsetX, offsetZ);

			v.color = lerp(float4(0,0,0,1), float4(1,1,1,1), saturate(v.vertex.y - _ColorLerpStrength));
		}		
		ENDCG

		CGINCLUDE
		float2 TileAndOffset(float2 uv, float scale, float offset) {
			return (uv + float2(offset, 0)) * scale;
		}

		half3 HandleNormal(sampler2D normal, float2 uv, float scale, float speed, float time) {
			float2 uvTile = TileAndOffset(uv, scale, speed * time);
			
			return UnpackNormal(tex2D(normal, uvTile));
		}

		half3 MultiBlendNormals(half3 n1, half3 n2, half3 n3) {
			return BlendNormals(BlendNormals(n1, n2), n3);
		}

		float Frequency(float3 direction, float depth) {
			float gravity = 9.8;
			float wL = length(direction);

			return sqrt(gravity * wL * tanh(wL * depth));
		}

		float Theta(float3 direction, float3 vertexPos, float depth, float phase, float time) {
			float freq = Frequency(direction, depth);

			return direction.x * vertexPos.x + direction.z * vertexPos.z - freq * time - phase;
		}

		float3 GerstnerWaveToWorld(float3 wave, float3 vertexPos) {
			return float3(vertexPos.x - wave.x, wave.y, vertexPos.z - wave.z);
		}

		float3 GerstnerWave(float3 vertexPos, float3 direction, float amplitude, float depth, float phase, float time) {
			float theta = Theta(direction, vertexPos, depth, phase, time);
			float wL = length(direction);

			float y = amplitude * cos(theta);
			float x = (direction.x / wL) * (amplitude / tanh(wL * depth)) * sin(theta);
			float z = (direction.z / wL) * (amplitude / tanh(wL * depth)) * sin(theta);

			return float3(x, y, z);
		}
		ENDCG
    }
    FallBack "Diffuse"
}
