// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Watere"
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

		_EdgeLength("Edge length", Range(2,50)) = 5
		_Phong("Edge Phong Strengh", Range(0,1)) = 0.5

		_ColorTop("Color top", Color) = (1,1,1,1)
		_ColorBottom("Color bottom", Color) = (1,1,1,1)
		_ColorLerpStrength("Color lerp strength", Range(-1, 1)) = 0

		_Normal1("Normal 1", 2D) = "bump" {}
		_Normal1Speed("Normal 1 Speed", Vector) = (0.5, 0, 0)
		_Normal1Scale("Normal 1 Scale", Range(0, 4)) = 0.5

		_Normal2("Normal 2", 2D) = "bump" {}
		_Normal2Speed("Normal 2 Speed", Vector) = (-0.5, 0, 0)
		_Normal2Scale("Normal 2 Scale", Range(0, 4)) = 0.75

		_Normal3("Normal 3", 2D) = "bump" {}
		_Normal3Speed("Normal 3 Speed", Vector) = (0, 1.0, 0)
		_Normal3Scale("Normal 3 Scale", Range(0, 4)) = 1.0

		_NormalStrength("NormalStrength", Range(-1, 1)) = 0.5

		_Depth("Depth", Range(0, 100)) = 10
		_Phase("Phase", Range(0, 360)) = 0

		_Amplitude1("Amplitude 1", Range(0, 1)) = 1
		_Speed1("Speed 1", Range(0, 5)) = 1
		_Direction1("Direction 1", Vector) = (1,0,0)

		_Amplitude2("Amplitude 2", Range(0, 1)) = 1
		_Speed2("Speed 2", Range(0, 5)) = 1
		_Direction2("Direction 2", Vector) = (1,0,0)

		_Amplitude3("Amplitude 3", Range(0, 1)) = 1
		_Speed3("Speed 3", Range(0, 5)) = 1
		_Direction3("Direction 3", Vector) = (1,0,0)

		_Amplitude4("Amplitude 4", Range(0, 1)) = 1
		_Speed4("Speed 4", Range(0, 5)) = 1
		_Direction4("Direction 4", Vector) = (1,0,0)

		_Amplitude5("Amplitude 5", Range(0, 1)) = 1
		_Speed5("Speed 5", Range(0, 5)) = 1
		_Direction5("Direction 5", Vector) = (1,0,0)

		_Amplitude6("Amplitude 6", Range(0, 1)) = 1
		_Speed6("Speed 6", Range(0, 5)) = 1
		_Direction6("Direction 6", Vector) = (1,0,0)

		_NeighbourDistance("NeighbourDistance", Range(0.0001,1)) = 0.01
		_TimeScale("Timescale", Range(0, 20)) = 10
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True"  "RenderType" = "Transparent" }
			ZWrite on
			Cull off
			LOD 600

			CGPROGRAM
			#pragma surface surf StandardTranslucent vertex:vert tessellate:tessEdge tessphong:_Phong fullforwardshadows addshadow

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
		float3 _Direction3;
		float _Amplitude3;
		float _Speed3;
		float3 _Direction4;
		float _Amplitude4;
		float _Speed4;
		float3 _Direction5;
		float _Amplitude5;
		float _Speed5;
		float3 _Direction6;
		float _Amplitude6;
		float _Speed6;

		float _Power;
		float _Scale;
		float _Distortion;
		float _Attenuation;
		float4 _Ambient;


		float _Depth;
		float _Phase;
		float _NeighbourDistance;
		float _TimeScale;

		struct Input
		{
			float3 worldPos;
			float4 color : COLOR;
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

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

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
			float3 I = _Attenuation * (VdotH + _Ambient) * thickness;

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

		struct GerstnerWaveStruct {
			float3 position;
			float3 offsetX;
			float3 offsetZ;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = lerp(_ColorBottom, _ColorTop, IN.color.r);
			//o.Alpha = IN.color.a;

			thickness = (IN.color.g + 0.1) * 0.75;

			o.Metallic = _Metallic;
			//o.Specular = (1, 1, 1, 0.001);
			o.Smoothness = _Glossiness;
			o.Emission = _Emission;

			float time = _Time * _TimeScale;

			half3 n1 = HandleNormal(_Normal1, IN.worldPos.xz, _Normal1Scale, _Normal1Speed, time);
			half3 n2 = HandleNormal(_Normal2, IN.worldPos.xz, _Normal2Scale, _Normal2Speed, time);
			half3 n3 = HandleNormal(_Normal3, IN.worldPos.xz, _Normal3Scale, _Normal3Speed, time);
			half3 blendedNormals = MultiBlendNormals(n1, n2, n3);
			o.Normal = lerp(blendedNormals, fixed3(0.9, 0.9, 2), -_NormalStrength + 1.0);
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
			GerstnerWaveStruct wave3 = GetWave(worldPos, _Direction3, _Amplitude3, _Depth, _Phase, _Speed3, time);
			GerstnerWaveStruct wave4 = GetWave(worldPos, _Direction4, _Amplitude4, _Depth, _Phase, _Speed4, time);
			GerstnerWaveStruct wave5 = GetWave(worldPos, _Direction5, _Amplitude5, _Depth, _Phase, _Speed5, time);
			GerstnerWaveStruct wave6 = GetWave(worldPos, _Direction6, _Amplitude6, _Depth, _Phase, _Speed6, time);

			float3 waveWorldPos = GerstnerWaveToWorld(wave1.position + wave2.position + wave3.position + wave4.position + wave5.position + wave6.position, v.vertex.xyz);
			float3 offsetX = GerstnerWaveToWorld(wave1.offsetX + wave2.offsetX + wave3.offsetX + wave4.offsetX + wave5.offsetX + wave6.offsetX, v.vertex.xyz + float3(0, 0, _NeighbourDistance));
			float3 offsetZ = GerstnerWaveToWorld(wave1.offsetZ + wave2.offsetZ + wave3.offsetZ + wave4.offsetZ + wave5.offsetZ + wave6.offsetZ, v.vertex.xyz + float3(_NeighbourDistance, 0, 0));

			v.vertex.xyz = waveWorldPos;
			v.normal.xyz = GetNormal(waveWorldPos, offsetX, offsetZ);

			thickness = saturate(v.normal.x + v.normal.y + v.normal.z);

			v.color.r = lerp(0, 1, saturate(v.vertex.y - _ColorLerpStrength));
			v.color.g = lerp(0, 1, saturate((v.normal.x + v.normal.y + v.normal.z)) - 0.5);
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
