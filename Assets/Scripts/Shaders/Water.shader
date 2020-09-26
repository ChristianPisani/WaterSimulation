// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Watere"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB) Alpha (A)", 2D) = "white" {}
		
		_Normal1 ("Bump", 2D) = "bump" {}
		_Normal1Speed("Normal 1 Speed", Range(-1, 1)) = 0.5
		_Normal1Scale("Normal 1 Scale", Range(0, 4)) = 0.5
		
		_Normal2 ("Bump", 2D) = "bump" {}
		_Normal2Speed("Normal 2 Speed", Range(-1, 1)) = -0.5
		_Normal2Scale("Normal 2 Scale", Range(0, 4)) = 0.75
		
		_Normal3 ("Bump", 2D) = "bump" {}
		_Normal3Speed("Normal 3 Speed", Range(-1, 1)) = 1.0
		_Normal3Scale ("Normal 3 Scale", Range(0, 4)) = 1.0
		
		_NormalStrength("NormalStrength", Range(-1, 1)) = 0.5
        
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
	}
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha
		Cull off
        LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha
		
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		#include "UnityStandardUtils.cginc"

		sampler2D _MainTex;
		sampler2D _Normal1;
		sampler2D _Normal2;
		sampler2D _Normal3;
		
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_Normal1;
			float2 uv_Normal2;
			float2 uv_Normal3;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		half _NormalStrength;
		half _Normal1Speed;
		half _Normal2Speed;
		half _Normal3Speed;

		half _Normal1Scale;
		half _Normal2Scale;
		half _Normal3Scale;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			
			half3 n1 = HandleNormal(_Normal1, IN.worldPos.xz, _Normal1Scale, _Normal1Speed, _Time);
			half3 n2 = HandleNormal(_Normal2, IN.worldPos.xz, _Normal2Scale, _Normal2Speed, _Time);
			half3 n3 = HandleNormal(_Normal3, IN.worldPos.xz, _Normal3Scale, _Normal3Speed, _Time);
			half3 blendedNormals = MultiBlendNormals(n1, n2, n3);
			o.Normal = lerp(float3(0.5, 0.5, 0.5), blendedNormals, _NormalStrength);
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
		ENDCG
    }
    FallBack "Diffuse"
}
