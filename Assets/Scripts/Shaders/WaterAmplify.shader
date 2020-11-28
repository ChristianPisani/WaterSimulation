// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterAmplify"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[ASEBegin]_Albedo("Albedo", Color) = (0.1177465,0.1929061,0.509434,0)
		_HeightMap("HeightMap", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Tiling("Tiling", Float) = 1
		_Scale("Scale", Vector) = (1,1,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_NormalStrength("NormalStrength", Float) = 1
		_WaterClarity("WaterClarity", Range( 0 , 100)) = 25
		_FoamDistance("FoamDistance", Range( 0 , 25)) = 0
		_Float3("Float 3", Range( 0 , 25)) = 0
		_RefractionStrength("RefractionStrength", Range( 0 , 10)) = 0
		_ChoppyMap("ChoppyMap", 2D) = "white" {}
		_FoamTexture("FoamTexture", 2D) = "white" {}
		[ASEEnd]_FoamNormal("FoamNormal", 2D) = "white" {}

		[HideInInspector] _RenderQueueType("Render Queue Type", Float) = 1
		//[HideInInspector] [ToggleUI] _AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 1
		[HideInInspector] _StencilRef("Stencil Ref", Int) = 0
		[HideInInspector] _StencilWriteMask("Stencil Write Mask", Int) = 6
		[HideInInspector] _StencilRefDepth("Stencil Ref Depth", Int) = 8
		[HideInInspector] _StencilWriteMaskDepth("Stencil Write Mask Depth", Int) = 8
		[HideInInspector] _StencilRefMV("Stencil Ref MV", Int) = 40
		[HideInInspector] _StencilWriteMaskMV("Stencil Write Mask MV", Int) = 40
		[HideInInspector] _StencilRefDistortionVec("Stencil Ref Distortion Vec", Int) = 4
		[HideInInspector] _StencilWriteMaskDistortionVec("Stencil Write Mask Distortion Vec", Int) = 4
		[HideInInspector] _StencilWriteMaskGBuffer("Stencil Write Mask GBuffer", Int) = 14
		[HideInInspector] _StencilRefGBuffer("Stencil Ref GBuffer", Int) = 10
		[HideInInspector] _ZTestGBuffer("ZTest GBuffer", Int) = 4
		[HideInInspector] [ToggleUI] _RequireSplitLighting("Require Split Lighting", Float) = 0
		[HideInInspector] [ToggleUI] _ReceivesSSR("Receives SSR", Float) = 1
		[HideInInspector] _SurfaceType("Surface Type", Float) = 0
		[HideInInspector] _BlendMode("Blend Mode", Float) = 0
		[HideInInspector] _SrcBlend("Src Blend", Float) = 1
		[HideInInspector] _DstBlend("Dst Blend", Float) = 0
		[HideInInspector] _AlphaSrcBlend("Alpha Src Blend", Float) = 1
		[HideInInspector] _AlphaDstBlend("Alpha Dst Blend", Float) = 0
		[HideInInspector] [ToggleUI] _ZWrite("ZWrite", Float) = 1
		[HideInInspector] [ToggleUI] _TransparentZWrite("Transparent ZWrite", Float) = 1
		[HideInInspector] _CullMode("Cull Mode", Float) = 2
		[HideInInspector] _TransparentSortPriority("Transparent Sort Priority", Int) = 0
		[HideInInspector] [ToggleUI] _EnableFogOnTransparent("Enable Fog On Transparent", Float) = 1
		[HideInInspector] _CullModeForward("Cull Mode Forward", Float) = 2
		[HideInInspector] [Enum(Front, 1, Back, 2)] _TransparentCullMode("Transparent Cull Mode", Float) = 2
		[HideInInspector] _ZTestDepthEqualForOpaque("ZTest Depth Equal For Opaque", Int) = 4
		[HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestTransparent("ZTest Transparent", Float) = 4
		[HideInInspector] [ToggleUI] _TransparentBackfaceEnable("Transparent Backface Enable", Float) = 0
		[HideInInspector] [ToggleUI] _AlphaCutoffEnable("Alpha Cutoff Enable", Float) = 0
		[HideInInspector] [ToggleUI] _UseShadowThreshold("Use Shadow Threshold", Float) = 0
		[HideInInspector] [ToggleUI] _DoubleSidedEnable("Double Sided Enable", Float) = 1
		[HideInInspector] [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Double Sided Normal Mode", Float) = 2
		[HideInInspector] _DoubleSidedConstants("DoubleSidedConstants", Vector) = (1,1,-1,0)
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		_TessEdgeLength ( "Edge length", Range( 2, 50 ) ) = 16
		_TessMaxDisp( "Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="HDRenderPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

		HLSLINCLUDE
		#pragma target 4.5
		#pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
		#pragma multi_compile_instancing
		#pragma instancing_options renderinglayer

		struct GlobalSurfaceDescription // GBuffer Forward META TransparentBackface
		{
			float3 Albedo;
			float3 Normal;
			float3 BentNormal;
			float3 Specular;
			float CoatMask;
			float Metallic;
			float3 Emission;
			float Smoothness;
			float Occlusion;
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float AlphaClipThresholdDepthPrepass;
			float AlphaClipThresholdDepthPostpass;
			float SpecularAAScreenSpaceVariance;
			float SpecularAAThreshold;
			float SpecularOcclusion;
			float DepthOffset;
			//Refraction
			float RefractionIndex;
			float3 RefractionColor;
			float RefractionDistance;
			//SSS/Translucent
			float Thickness;
			float SubsurfaceMask;
			float DiffusionProfile;
			//Anisotropy
			float Anisotropy;
			float3 Tangent;
			//Iridescent
			float IridescenceMask;
			float IridescenceThickness;
			//BakedGI
			float3 BakedGI;
			float3 BakedBackGI;
		};

		struct AlphaSurfaceDescription // ShadowCaster
		{
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float DepthOffset;
		};

		struct SceneSurfaceDescription // SceneSelection
		{
			float Alpha;
			float AlphaClipThreshold;
			float DepthOffset;
		};

		struct PrePassSurfaceDescription // DepthPrePass
		{
			float Alpha;
			float AlphaClipThresholdDepthPrepass;
			float DepthOffset;
		};

		struct PostPassSurfaceDescription //DepthPostPass
		{
			float Alpha;
			float AlphaClipThresholdDepthPostpass;
			float DepthOffset;
		};

		struct SmoothSurfaceDescription // MotionVectors DepthOnly
		{
			float3 Normal;
			float Smoothness;
			float Alpha;
			float AlphaClipThreshold;
			float DepthOffset;
		};

		struct DistortionSurfaceDescription //Distortion
		{
			float Alpha;
			float2 Distortion;
			float DistortionBlur;
			float AlphaClipThreshold;
		};

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlaneASE (float3 pos, float4 plane)
		{
			return dot (float4(pos,1.0f), plane);
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlaneASE(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlaneASE(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlaneASE(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlaneASE(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL
		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="GBuffer" }

			Cull [_CullMode]
			ZTest [_ZTestGBuffer]

			Stencil
			{
				Ref [_StencilRefGBuffer]
				WriteMask [_StencilWriteMaskGBuffer]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#if !defined(DEBUG_DISPLAY) && defined(_ALPHATEST_ON)
			#define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST
			#endif

			#define SHADERPASS SHADERPASS_GBUFFER
			#pragma multi_compile _ DEBUG_DISPLAY
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile _ LIGHT_LAYERS

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_VERT_POSITION


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;
			sampler2D _FoamTexture;
			sampler2D _NormalMap;
			sampler2D _FoamNormal;


			float4 ASEHDSampleSceneColor(float2 uv, float lod, float exposureMultiplier)
			{
				#if defined(REQUIRE_OPAQUE_TEXTURE) && defined(_SURFACE_TYPE_TRANSPARENT) && defined(SHADERPASS) && (SHADERPASS != SHADERPASS_LIGHT_TRANSPORT)
				return float4( SampleCameraColor(uv, lod) * exposureMultiplier, 1.0 );
				#endif
				return float4(0.0, 0.0, 0.0, 1.0);
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2(0.0, 0.0);
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				
				float3 vertexPos268 = inputMesh.positionOS;
				float4 ase_clipPos268 = TransformWorldToHClip( TransformObjectToWorld(vertexPos268));
				float4 screenPos268 = ComputeScreenPos( ase_clipPos268 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord5 = screenPos268;
				
				float3 vertexPos381 = inputMesh.positionOS;
				float4 ase_clipPos381 = TransformWorldToHClip( TransformObjectToWorld(vertexPos381));
				float4 screenPos381 = ComputeScreenPos( ase_clipPos381 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord6 = screenPos381;
				
				float4 ase_clipPos = TransformWorldToHClip( TransformObjectToWorld(inputMesh.positionOS));
				float4 screenPos = ComputeScreenPos( ase_clipPos , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord7 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(inputMesh.positionOS));
				float eyeDepth = -objectToViewPos.z;
				outputPackedVaryingsMeshToPS.ase_texcoord8.x = eyeDepth;
				float3 vertexPos235 = inputMesh.positionOS;
				float4 ase_clipPos235 = TransformWorldToHClip( TransformObjectToWorld(vertexPos235));
				float4 screenPos235 = ComputeScreenPos( ase_clipPos235 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord9 = screenPos235;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord8.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput,
						OUTPUT_GBUFFER(outGBuffer)
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
						)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
				SurfaceData surfaceData;
				BuiltinData builtinData;

				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float4 temp_output_261_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner270 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_261_0.xy);
				float2 panner397 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_261_0.xy);
				float4 screenPos268 = packedInput.ase_texcoord5;
				float4 ase_screenPosNorm268 = screenPos268 / screenPos268.w;
				ase_screenPosNorm268.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm268.z : ase_screenPosNorm268.z * 0.5 + 0.5;
				float screenDepth268 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm268.xy ),_ZBufferParams);
				float distanceDepth268 = abs( ( screenDepth268 - LinearEyeDepth( ase_screenPosNorm268.z,_ZBufferParams ) ) / ( _FoamDistance ) );
				float clampResult269 = clamp( distanceDepth268 , 0.0 , 1.0 );
				float4 lerpResult266 = lerp( ( tex2D( _FoamTexture, panner270 ) + tex2D( _FoamTexture, panner397 ) ) , _Albedo , clampResult269);
				float4 Color229 = lerpResult266;
				
				float localBicubicPrepare2_g46 = ( 0.0 );
				float2 temp_output_51_0_g44 = WorldspaceUV61.xy;
				float2 break52_g44 = temp_output_51_0_g44;
				float temp_output_34_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult55_g44 = (float2(( break52_g44.x + temp_output_34_0_g44 ) , break52_g44.y));
				float2 Input_UV100_g46 = appendResult55_g44;
				float2 UV2_g46 = Input_UV100_g46;
				float4 TexelSize2_g46 = _NormalMap_TexelSize;
				float2 UV02_g46 = float2( 0,0 );
				float2 UV12_g46 = float2( 0,0 );
				float2 UV22_g46 = float2( 0,0 );
				float2 UV32_g46 = float2( 0,0 );
				float W02_g46 = 0;
				float W12_g46 = 0;
				{
				{
				 UV2_g46 = UV2_g46 * TexelSize2_g46.zw - 0.5;
				    float2 f = frac( UV2_g46 );
				    UV2_g46 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g46.x - 0.5, UV2_g46.x + 1.5, UV2_g46.y - 0.5, UV2_g46.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g46.xyxy;
				    UV02_g46 = off.xz;
				    UV12_g46 = off.yz;
				    UV22_g46 = off.xw;
				    UV32_g46 = off.yw;
				    W02_g46 = s.x / ( s.x + s.y );
				 W12_g46 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g46 = lerp( tex2D( _NormalMap, UV32_g46 ) , tex2D( _NormalMap, UV22_g46 ) , W02_g46);
				float4 lerpResult45_g46 = lerp( tex2D( _NormalMap, UV12_g46 ) , tex2D( _NormalMap, UV02_g46 ) , W02_g46);
				float4 lerpResult44_g46 = lerp( lerpResult46_g46 , lerpResult45_g46 , W12_g46);
				float4 Output_2D131_g46 = lerpResult44_g46;
				float4 break74_g46 = Output_2D131_g46;
				float localBicubicPrepare2_g45 = ( 0.0 );
				float2 Input_UV100_g45 = temp_output_51_0_g44;
				float2 UV2_g45 = Input_UV100_g45;
				float4 TexelSize2_g45 = _NormalMap_TexelSize;
				float2 UV02_g45 = float2( 0,0 );
				float2 UV12_g45 = float2( 0,0 );
				float2 UV22_g45 = float2( 0,0 );
				float2 UV32_g45 = float2( 0,0 );
				float W02_g45 = 0;
				float W12_g45 = 0;
				{
				{
				 UV2_g45 = UV2_g45 * TexelSize2_g45.zw - 0.5;
				    float2 f = frac( UV2_g45 );
				    UV2_g45 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g45.x - 0.5, UV2_g45.x + 1.5, UV2_g45.y - 0.5, UV2_g45.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g45.xyxy;
				    UV02_g45 = off.xz;
				    UV12_g45 = off.yz;
				    UV22_g45 = off.xw;
				    UV32_g45 = off.yw;
				    W02_g45 = s.x / ( s.x + s.y );
				 W12_g45 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g45 = lerp( tex2D( _NormalMap, UV32_g45 ) , tex2D( _NormalMap, UV22_g45 ) , W02_g45);
				float4 lerpResult45_g45 = lerp( tex2D( _NormalMap, UV12_g45 ) , tex2D( _NormalMap, UV02_g45 ) , W02_g45);
				float4 lerpResult44_g45 = lerp( lerpResult46_g45 , lerpResult45_g45 , W12_g45);
				float4 Output_2D131_g45 = lerpResult44_g45;
				float4 break74_g45 = Output_2D131_g45;
				float temp_output_57_85_g44 = break74_g45.g;
				float temp_output_43_0_g44 = _NormalStrength;
				float3 appendResult45_g44 = (float3(1.0 , 0.0 , ( ( break74_g46.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float localBicubicPrepare2_g47 = ( 0.0 );
				float2 appendResult38_g44 = (float2(break52_g44.x , ( break52_g44.y + temp_output_34_0_g44 )));
				float2 Input_UV100_g47 = appendResult38_g44;
				float2 UV2_g47 = Input_UV100_g47;
				float4 TexelSize2_g47 = _NormalMap_TexelSize;
				float2 UV02_g47 = float2( 0,0 );
				float2 UV12_g47 = float2( 0,0 );
				float2 UV22_g47 = float2( 0,0 );
				float2 UV32_g47 = float2( 0,0 );
				float W02_g47 = 0;
				float W12_g47 = 0;
				{
				{
				 UV2_g47 = UV2_g47 * TexelSize2_g47.zw - 0.5;
				    float2 f = frac( UV2_g47 );
				    UV2_g47 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g47.x - 0.5, UV2_g47.x + 1.5, UV2_g47.y - 0.5, UV2_g47.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g47.xyxy;
				    UV02_g47 = off.xz;
				    UV12_g47 = off.yz;
				    UV22_g47 = off.xw;
				    UV32_g47 = off.yw;
				    W02_g47 = s.x / ( s.x + s.y );
				 W12_g47 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g47 = lerp( tex2D( _NormalMap, UV32_g47 ) , tex2D( _NormalMap, UV22_g47 ) , W02_g47);
				float4 lerpResult45_g47 = lerp( tex2D( _NormalMap, UV12_g47 ) , tex2D( _NormalMap, UV02_g47 ) , W02_g47);
				float4 lerpResult44_g47 = lerp( lerpResult46_g47 , lerpResult45_g47 , W12_g47);
				float4 Output_2D131_g47 = lerpResult44_g47;
				float4 break74_g47 = Output_2D131_g47;
				float3 appendResult50_g44 = (float3(0.0 , 1.0 , ( ( break74_g47.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float3 normalizeResult54_g44 = normalize( cross( appendResult45_g44 , appendResult50_g44 ) );
				float4 temp_output_374_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner376 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g10 = panner376;
				float2 break6_g10 = temp_output_2_0_g10;
				float temp_output_25_0_g10 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
				float4 tex2DNode14_g10 = tex2D( _FoamNormal, temp_output_2_0_g10 );
				float temp_output_4_0_g10 = 2.0;
				float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
				float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
				float2 panner392 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g11 = panner392;
				float2 break6_g11 = temp_output_2_0_g11;
				float temp_output_25_0_g11 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g11 = (float2(( break6_g11.x + temp_output_25_0_g11 ) , break6_g11.y));
				float4 tex2DNode14_g11 = tex2D( _FoamNormal, temp_output_2_0_g11 );
				float temp_output_4_0_g11 = 2.0;
				float3 appendResult13_g11 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float2 appendResult9_g11 = (float2(break6_g11.x , ( break6_g11.y + temp_output_25_0_g11 )));
				float3 appendResult16_g11 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float3 normalizeResult22_g11 = normalize( cross( appendResult13_g11 , appendResult16_g11 ) );
				float4 color382 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos381 = packedInput.ase_texcoord6;
				float4 ase_screenPosNorm381 = screenPos381 / screenPos381.w;
				ase_screenPosNorm381.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm381.z : ase_screenPosNorm381.z * 0.5 + 0.5;
				float screenDepth381 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm381.xy ),_ZBufferParams);
				float distanceDepth381 = abs( ( screenDepth381 - LinearEyeDepth( ase_screenPosNorm381.z,_ZBufferParams ) ) / ( _Float3 ) );
				float clampResult384 = clamp( distanceDepth381 , 0.0 , 1.0 );
				float4 lerpResult385 = lerp( float4( ( normalizeResult22_g10 + normalizeResult22_g11 ) , 0.0 ) , color382 , clampResult384);
				float4 normalizeResult391 = normalize( ( float4( normalizeResult54_g44 , 0.0 ) + lerpResult385 ) );
				float4 Normal89 = normalizeResult391;
				
				float2 temp_output_20_0_g48 = ( (Normal89.rgb).xy * ( _RefractionStrength / 1.0 ) * 1.0 );
				float4 screenPos = packedInput.ase_texcoord7;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth2_g48 = LinearEyeDepth(SampleCameraDepth( ( float4( temp_output_20_0_g48, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float eyeDepth = packedInput.ase_texcoord8.x;
				float2 temp_output_32_0_g48 = (( float4( ( temp_output_20_0_g48 * saturate( ( eyeDepth2_g48 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal74 = ASEHDSampleSceneColor(temp_output_32_0_g48, 0, GetInverseCurrentExposureMultiplier());
				float4 color233 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos235 = packedInput.ase_texcoord9;
				float4 ase_screenPosNorm235 = screenPos235 / screenPos235.w;
				ase_screenPosNorm235.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm235.z : ase_screenPosNorm235.z * 0.5 + 0.5;
				float screenDepth235 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm235.xy ),_ZBufferParams);
				float distanceDepth235 = saturate( abs( ( screenDepth235 - LinearEyeDepth( ase_screenPosNorm235.z,_ZBufferParams ) ) / ( _WaterClarity ) ) );
				float clampResult310 = clamp( ( _WorldSpaceCameraPos.y - ase_worldPos.y ) , 0.0 , 1.0 );
				float4 lerpResult227 = lerp( fetchOpaqueVal74 , color233 , ( saturate( distanceDepth235 ) * ceil( clampResult310 ) ));
				float4 Refracted75 = saturate( lerpResult227 );
				
				surfaceDescription.Albedo = Color229.rgb;
				surfaceDescription.Normal = Normal89.rgb;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = Refracted75.rgb;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = 1;
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = 0.5;
				#endif

				surfaceDescription.AlphaClipThresholdDepthPrepass = 0.5;
				surfaceDescription.AlphaClipThresholdDepthPostpass = 0.5;

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_DISTORTION
				surfaceDescription.Distortion = float2 ( 2, -1 );
				surfaceDescription.DistortionBlur = 1;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, V, posInput, surfaceData, builtinData );
				ENCODE_INTO_GBUFFER( surfaceData, builtinData, posInput.positionSS, outGBuffer );
				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "META"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_LIGHT_TRANSPORT

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;
			sampler2D _FoamTexture;
			sampler2D _NormalMap;
			sampler2D _FoamNormal;


			float4 ASEHDSampleSceneColor(float2 uv, float lod, float exposureMultiplier)
			{
				#if defined(REQUIRE_OPAQUE_TEXTURE) && defined(_SURFACE_TYPE_TRANSPARENT) && defined(SHADERPASS) && (SHADERPASS != SHADERPASS_LIGHT_TRANSPORT)
				return float4( SampleCameraColor(uv, lod) * exposureMultiplier, 1.0 );
				#endif
				return float4(0.0, 0.0, 0.0, 1.0);
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2(0.0, 0.0);
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			CBUFFER_START(UnityMetaPass)
			bool4 unity_MetaVertexControl;
			bool4 unity_MetaFragmentControl;
			CBUFFER_END

			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh  )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				
				outputPackedVaryingsMeshToPS.ase_texcoord.xyz = ase_worldPos;
				float3 vertexPos268 = inputMesh.positionOS;
				float4 ase_clipPos268 = TransformWorldToHClip( TransformObjectToWorld(vertexPos268));
				float4 screenPos268 = ComputeScreenPos( ase_clipPos268 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord1 = screenPos268;
				
				float3 vertexPos381 = inputMesh.positionOS;
				float4 ase_clipPos381 = TransformWorldToHClip( TransformObjectToWorld(vertexPos381));
				float4 screenPos381 = ComputeScreenPos( ase_clipPos381 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord2 = screenPos381;
				
				float4 ase_clipPos = TransformWorldToHClip( TransformObjectToWorld(inputMesh.positionOS));
				float4 screenPos = ComputeScreenPos( ase_clipPos , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord3 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(inputMesh.positionOS));
				float eyeDepth = -objectToViewPos.z;
				outputPackedVaryingsMeshToPS.ase_texcoord.w = eyeDepth;
				float3 vertexPos235 = inputMesh.positionOS;
				float4 ase_clipPos235 = TransformWorldToHClip( TransformObjectToWorld(vertexPos235));
				float4 screenPos235 = ComputeScreenPos( ase_clipPos235 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord4 = screenPos235;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float2 uv = float2(0.0, 0.0);
				if (unity_MetaVertexControl.x)
				{
					uv = inputMesh.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				}
				else if (unity_MetaVertexControl.y)
				{
					uv = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				}

				outputPackedVaryingsMeshToPS.positionCS = float4(uv * 2.0 - 1.0, inputMesh.positionOS.z > 0 ? 1.0e-4 : 0.0, 1.0);
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv0 = v.uv0;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv0 = patch[0].uv0 * bary.x + patch[1].uv0 * bary.y + patch[2].uv0 * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			float4 Frag(PackedVaryingsMeshToPS packedInput  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = float3(1.0, 1.0, 1.0);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float3 ase_worldPos = packedInput.ase_texcoord.xyz;
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float4 temp_output_261_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner270 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_261_0.xy);
				float2 panner397 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_261_0.xy);
				float4 screenPos268 = packedInput.ase_texcoord1;
				float4 ase_screenPosNorm268 = screenPos268 / screenPos268.w;
				ase_screenPosNorm268.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm268.z : ase_screenPosNorm268.z * 0.5 + 0.5;
				float screenDepth268 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm268.xy ),_ZBufferParams);
				float distanceDepth268 = abs( ( screenDepth268 - LinearEyeDepth( ase_screenPosNorm268.z,_ZBufferParams ) ) / ( _FoamDistance ) );
				float clampResult269 = clamp( distanceDepth268 , 0.0 , 1.0 );
				float4 lerpResult266 = lerp( ( tex2D( _FoamTexture, panner270 ) + tex2D( _FoamTexture, panner397 ) ) , _Albedo , clampResult269);
				float4 Color229 = lerpResult266;
				
				float localBicubicPrepare2_g46 = ( 0.0 );
				float2 temp_output_51_0_g44 = WorldspaceUV61.xy;
				float2 break52_g44 = temp_output_51_0_g44;
				float temp_output_34_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult55_g44 = (float2(( break52_g44.x + temp_output_34_0_g44 ) , break52_g44.y));
				float2 Input_UV100_g46 = appendResult55_g44;
				float2 UV2_g46 = Input_UV100_g46;
				float4 TexelSize2_g46 = _NormalMap_TexelSize;
				float2 UV02_g46 = float2( 0,0 );
				float2 UV12_g46 = float2( 0,0 );
				float2 UV22_g46 = float2( 0,0 );
				float2 UV32_g46 = float2( 0,0 );
				float W02_g46 = 0;
				float W12_g46 = 0;
				{
				{
				 UV2_g46 = UV2_g46 * TexelSize2_g46.zw - 0.5;
				    float2 f = frac( UV2_g46 );
				    UV2_g46 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g46.x - 0.5, UV2_g46.x + 1.5, UV2_g46.y - 0.5, UV2_g46.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g46.xyxy;
				    UV02_g46 = off.xz;
				    UV12_g46 = off.yz;
				    UV22_g46 = off.xw;
				    UV32_g46 = off.yw;
				    W02_g46 = s.x / ( s.x + s.y );
				 W12_g46 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g46 = lerp( tex2D( _NormalMap, UV32_g46 ) , tex2D( _NormalMap, UV22_g46 ) , W02_g46);
				float4 lerpResult45_g46 = lerp( tex2D( _NormalMap, UV12_g46 ) , tex2D( _NormalMap, UV02_g46 ) , W02_g46);
				float4 lerpResult44_g46 = lerp( lerpResult46_g46 , lerpResult45_g46 , W12_g46);
				float4 Output_2D131_g46 = lerpResult44_g46;
				float4 break74_g46 = Output_2D131_g46;
				float localBicubicPrepare2_g45 = ( 0.0 );
				float2 Input_UV100_g45 = temp_output_51_0_g44;
				float2 UV2_g45 = Input_UV100_g45;
				float4 TexelSize2_g45 = _NormalMap_TexelSize;
				float2 UV02_g45 = float2( 0,0 );
				float2 UV12_g45 = float2( 0,0 );
				float2 UV22_g45 = float2( 0,0 );
				float2 UV32_g45 = float2( 0,0 );
				float W02_g45 = 0;
				float W12_g45 = 0;
				{
				{
				 UV2_g45 = UV2_g45 * TexelSize2_g45.zw - 0.5;
				    float2 f = frac( UV2_g45 );
				    UV2_g45 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g45.x - 0.5, UV2_g45.x + 1.5, UV2_g45.y - 0.5, UV2_g45.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g45.xyxy;
				    UV02_g45 = off.xz;
				    UV12_g45 = off.yz;
				    UV22_g45 = off.xw;
				    UV32_g45 = off.yw;
				    W02_g45 = s.x / ( s.x + s.y );
				 W12_g45 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g45 = lerp( tex2D( _NormalMap, UV32_g45 ) , tex2D( _NormalMap, UV22_g45 ) , W02_g45);
				float4 lerpResult45_g45 = lerp( tex2D( _NormalMap, UV12_g45 ) , tex2D( _NormalMap, UV02_g45 ) , W02_g45);
				float4 lerpResult44_g45 = lerp( lerpResult46_g45 , lerpResult45_g45 , W12_g45);
				float4 Output_2D131_g45 = lerpResult44_g45;
				float4 break74_g45 = Output_2D131_g45;
				float temp_output_57_85_g44 = break74_g45.g;
				float temp_output_43_0_g44 = _NormalStrength;
				float3 appendResult45_g44 = (float3(1.0 , 0.0 , ( ( break74_g46.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float localBicubicPrepare2_g47 = ( 0.0 );
				float2 appendResult38_g44 = (float2(break52_g44.x , ( break52_g44.y + temp_output_34_0_g44 )));
				float2 Input_UV100_g47 = appendResult38_g44;
				float2 UV2_g47 = Input_UV100_g47;
				float4 TexelSize2_g47 = _NormalMap_TexelSize;
				float2 UV02_g47 = float2( 0,0 );
				float2 UV12_g47 = float2( 0,0 );
				float2 UV22_g47 = float2( 0,0 );
				float2 UV32_g47 = float2( 0,0 );
				float W02_g47 = 0;
				float W12_g47 = 0;
				{
				{
				 UV2_g47 = UV2_g47 * TexelSize2_g47.zw - 0.5;
				    float2 f = frac( UV2_g47 );
				    UV2_g47 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g47.x - 0.5, UV2_g47.x + 1.5, UV2_g47.y - 0.5, UV2_g47.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g47.xyxy;
				    UV02_g47 = off.xz;
				    UV12_g47 = off.yz;
				    UV22_g47 = off.xw;
				    UV32_g47 = off.yw;
				    W02_g47 = s.x / ( s.x + s.y );
				 W12_g47 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g47 = lerp( tex2D( _NormalMap, UV32_g47 ) , tex2D( _NormalMap, UV22_g47 ) , W02_g47);
				float4 lerpResult45_g47 = lerp( tex2D( _NormalMap, UV12_g47 ) , tex2D( _NormalMap, UV02_g47 ) , W02_g47);
				float4 lerpResult44_g47 = lerp( lerpResult46_g47 , lerpResult45_g47 , W12_g47);
				float4 Output_2D131_g47 = lerpResult44_g47;
				float4 break74_g47 = Output_2D131_g47;
				float3 appendResult50_g44 = (float3(0.0 , 1.0 , ( ( break74_g47.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float3 normalizeResult54_g44 = normalize( cross( appendResult45_g44 , appendResult50_g44 ) );
				float4 temp_output_374_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner376 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g10 = panner376;
				float2 break6_g10 = temp_output_2_0_g10;
				float temp_output_25_0_g10 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
				float4 tex2DNode14_g10 = tex2D( _FoamNormal, temp_output_2_0_g10 );
				float temp_output_4_0_g10 = 2.0;
				float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
				float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
				float2 panner392 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g11 = panner392;
				float2 break6_g11 = temp_output_2_0_g11;
				float temp_output_25_0_g11 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g11 = (float2(( break6_g11.x + temp_output_25_0_g11 ) , break6_g11.y));
				float4 tex2DNode14_g11 = tex2D( _FoamNormal, temp_output_2_0_g11 );
				float temp_output_4_0_g11 = 2.0;
				float3 appendResult13_g11 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float2 appendResult9_g11 = (float2(break6_g11.x , ( break6_g11.y + temp_output_25_0_g11 )));
				float3 appendResult16_g11 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float3 normalizeResult22_g11 = normalize( cross( appendResult13_g11 , appendResult16_g11 ) );
				float4 color382 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos381 = packedInput.ase_texcoord2;
				float4 ase_screenPosNorm381 = screenPos381 / screenPos381.w;
				ase_screenPosNorm381.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm381.z : ase_screenPosNorm381.z * 0.5 + 0.5;
				float screenDepth381 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm381.xy ),_ZBufferParams);
				float distanceDepth381 = abs( ( screenDepth381 - LinearEyeDepth( ase_screenPosNorm381.z,_ZBufferParams ) ) / ( _Float3 ) );
				float clampResult384 = clamp( distanceDepth381 , 0.0 , 1.0 );
				float4 lerpResult385 = lerp( float4( ( normalizeResult22_g10 + normalizeResult22_g11 ) , 0.0 ) , color382 , clampResult384);
				float4 normalizeResult391 = normalize( ( float4( normalizeResult54_g44 , 0.0 ) + lerpResult385 ) );
				float4 Normal89 = normalizeResult391;
				
				float2 temp_output_20_0_g48 = ( (Normal89.rgb).xy * ( _RefractionStrength / 1.0 ) * 1.0 );
				float4 screenPos = packedInput.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth2_g48 = LinearEyeDepth(SampleCameraDepth( ( float4( temp_output_20_0_g48, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float eyeDepth = packedInput.ase_texcoord.w;
				float2 temp_output_32_0_g48 = (( float4( ( temp_output_20_0_g48 * saturate( ( eyeDepth2_g48 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal74 = ASEHDSampleSceneColor(temp_output_32_0_g48, 0, GetInverseCurrentExposureMultiplier());
				float4 color233 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos235 = packedInput.ase_texcoord4;
				float4 ase_screenPosNorm235 = screenPos235 / screenPos235.w;
				ase_screenPosNorm235.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm235.z : ase_screenPosNorm235.z * 0.5 + 0.5;
				float screenDepth235 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm235.xy ),_ZBufferParams);
				float distanceDepth235 = saturate( abs( ( screenDepth235 - LinearEyeDepth( ase_screenPosNorm235.z,_ZBufferParams ) ) / ( _WaterClarity ) ) );
				float clampResult310 = clamp( ( _WorldSpaceCameraPos.y - ase_worldPos.y ) , 0.0 , 1.0 );
				float4 lerpResult227 = lerp( fetchOpaqueVal74 , color233 , ( saturate( distanceDepth235 ) * ceil( clampResult310 ) ));
				float4 Refracted75 = saturate( lerpResult227 );
				
				surfaceDescription.Albedo = Color229.rgb;
				surfaceDescription.Normal = Normal89.rgb;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = Refracted75.rgb;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = 1;
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);
				LightTransportData lightTransportData = GetLightTransportData(surfaceData, builtinData, bsdfData);

				float4 res = float4(0.0, 0.0, 0.0, 1.0);
				if (unity_MetaFragmentControl.x)
				{
					res.rgb = clamp(pow(abs(lightTransportData.diffuseColor), saturate(unity_OneOverOutputBoost)), 0, unity_MaxOutputValue);
				}

				if (unity_MetaFragmentControl.y)
				{
					res.rgb = lightTransportData.emissiveColor;
				}

				return res;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			Cull [_CullMode]
			ZWrite On
			ZClip [_ZClip]
			ZTest LEqual
			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_SHADOWS

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			//#define USE_LEGACY_UNITY_MATRIX_VARIABLES

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			

			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;


			
			void BuildSurfaceData(FragInputs fragInputs, inout AlphaSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(AlphaSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				#ifdef _ALPHATEST_SHADOW_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow );
				#else
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;
				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif
			
			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				AlphaSurfaceDescription surfaceDescription = (AlphaSurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = 0.5;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }
			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#define SCENESELECTIONPASS
			#pragma editor_sync_compilation

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			

			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			int _ObjectId;
			int _PassValue;

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _ChoppyMap;
			sampler2D _HeightMap;


			
			void BuildSurfaceData(FragInputs fragInputs, inout SceneSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(SceneSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;
				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SceneSurfaceDescription surfaceDescription = (SceneSurfaceDescription)0;
				
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			Cull [_CullMode]

			ZWrite On

			Stencil
			{
				Ref [_StencilRefDepth]
				WriteMask [_StencilWriteMaskDepth]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#pragma multi_compile _ WRITE_NORMAL_BUFFER
			#pragma multi_compile _ WRITE_MSAA_DEPTH

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_VERT_POSITION


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;
			sampler2D _NormalMap;
			sampler2D _FoamNormal;


			
			void BuildSurfaceData(FragInputs fragInputs, inout SmoothSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(SmoothSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				
				float3 vertexPos381 = inputMesh.positionOS;
				float4 ase_clipPos381 = TransformWorldToHClip( TransformObjectToWorld(vertexPos381));
				float4 screenPos381 = ComputeScreenPos( ase_clipPos381 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord3 = screenPos381;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				return outputPackedVaryingsMeshToPS;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SmoothSurfaceDescription surfaceDescription = (SmoothSurfaceDescription)0;
				float localBicubicPrepare2_g46 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 temp_output_51_0_g44 = WorldspaceUV61.xy;
				float2 break52_g44 = temp_output_51_0_g44;
				float temp_output_34_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult55_g44 = (float2(( break52_g44.x + temp_output_34_0_g44 ) , break52_g44.y));
				float2 Input_UV100_g46 = appendResult55_g44;
				float2 UV2_g46 = Input_UV100_g46;
				float4 TexelSize2_g46 = _NormalMap_TexelSize;
				float2 UV02_g46 = float2( 0,0 );
				float2 UV12_g46 = float2( 0,0 );
				float2 UV22_g46 = float2( 0,0 );
				float2 UV32_g46 = float2( 0,0 );
				float W02_g46 = 0;
				float W12_g46 = 0;
				{
				{
				 UV2_g46 = UV2_g46 * TexelSize2_g46.zw - 0.5;
				    float2 f = frac( UV2_g46 );
				    UV2_g46 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g46.x - 0.5, UV2_g46.x + 1.5, UV2_g46.y - 0.5, UV2_g46.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g46.xyxy;
				    UV02_g46 = off.xz;
				    UV12_g46 = off.yz;
				    UV22_g46 = off.xw;
				    UV32_g46 = off.yw;
				    W02_g46 = s.x / ( s.x + s.y );
				 W12_g46 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g46 = lerp( tex2D( _NormalMap, UV32_g46 ) , tex2D( _NormalMap, UV22_g46 ) , W02_g46);
				float4 lerpResult45_g46 = lerp( tex2D( _NormalMap, UV12_g46 ) , tex2D( _NormalMap, UV02_g46 ) , W02_g46);
				float4 lerpResult44_g46 = lerp( lerpResult46_g46 , lerpResult45_g46 , W12_g46);
				float4 Output_2D131_g46 = lerpResult44_g46;
				float4 break74_g46 = Output_2D131_g46;
				float localBicubicPrepare2_g45 = ( 0.0 );
				float2 Input_UV100_g45 = temp_output_51_0_g44;
				float2 UV2_g45 = Input_UV100_g45;
				float4 TexelSize2_g45 = _NormalMap_TexelSize;
				float2 UV02_g45 = float2( 0,0 );
				float2 UV12_g45 = float2( 0,0 );
				float2 UV22_g45 = float2( 0,0 );
				float2 UV32_g45 = float2( 0,0 );
				float W02_g45 = 0;
				float W12_g45 = 0;
				{
				{
				 UV2_g45 = UV2_g45 * TexelSize2_g45.zw - 0.5;
				    float2 f = frac( UV2_g45 );
				    UV2_g45 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g45.x - 0.5, UV2_g45.x + 1.5, UV2_g45.y - 0.5, UV2_g45.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g45.xyxy;
				    UV02_g45 = off.xz;
				    UV12_g45 = off.yz;
				    UV22_g45 = off.xw;
				    UV32_g45 = off.yw;
				    W02_g45 = s.x / ( s.x + s.y );
				 W12_g45 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g45 = lerp( tex2D( _NormalMap, UV32_g45 ) , tex2D( _NormalMap, UV22_g45 ) , W02_g45);
				float4 lerpResult45_g45 = lerp( tex2D( _NormalMap, UV12_g45 ) , tex2D( _NormalMap, UV02_g45 ) , W02_g45);
				float4 lerpResult44_g45 = lerp( lerpResult46_g45 , lerpResult45_g45 , W12_g45);
				float4 Output_2D131_g45 = lerpResult44_g45;
				float4 break74_g45 = Output_2D131_g45;
				float temp_output_57_85_g44 = break74_g45.g;
				float temp_output_43_0_g44 = _NormalStrength;
				float3 appendResult45_g44 = (float3(1.0 , 0.0 , ( ( break74_g46.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float localBicubicPrepare2_g47 = ( 0.0 );
				float2 appendResult38_g44 = (float2(break52_g44.x , ( break52_g44.y + temp_output_34_0_g44 )));
				float2 Input_UV100_g47 = appendResult38_g44;
				float2 UV2_g47 = Input_UV100_g47;
				float4 TexelSize2_g47 = _NormalMap_TexelSize;
				float2 UV02_g47 = float2( 0,0 );
				float2 UV12_g47 = float2( 0,0 );
				float2 UV22_g47 = float2( 0,0 );
				float2 UV32_g47 = float2( 0,0 );
				float W02_g47 = 0;
				float W12_g47 = 0;
				{
				{
				 UV2_g47 = UV2_g47 * TexelSize2_g47.zw - 0.5;
				    float2 f = frac( UV2_g47 );
				    UV2_g47 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g47.x - 0.5, UV2_g47.x + 1.5, UV2_g47.y - 0.5, UV2_g47.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g47.xyxy;
				    UV02_g47 = off.xz;
				    UV12_g47 = off.yz;
				    UV22_g47 = off.xw;
				    UV32_g47 = off.yw;
				    W02_g47 = s.x / ( s.x + s.y );
				 W12_g47 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g47 = lerp( tex2D( _NormalMap, UV32_g47 ) , tex2D( _NormalMap, UV22_g47 ) , W02_g47);
				float4 lerpResult45_g47 = lerp( tex2D( _NormalMap, UV12_g47 ) , tex2D( _NormalMap, UV02_g47 ) , W02_g47);
				float4 lerpResult44_g47 = lerp( lerpResult46_g47 , lerpResult45_g47 , W12_g47);
				float4 Output_2D131_g47 = lerpResult44_g47;
				float4 break74_g47 = Output_2D131_g47;
				float3 appendResult50_g44 = (float3(0.0 , 1.0 , ( ( break74_g47.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float3 normalizeResult54_g44 = normalize( cross( appendResult45_g44 , appendResult50_g44 ) );
				float4 temp_output_374_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner376 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g10 = panner376;
				float2 break6_g10 = temp_output_2_0_g10;
				float temp_output_25_0_g10 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
				float4 tex2DNode14_g10 = tex2D( _FoamNormal, temp_output_2_0_g10 );
				float temp_output_4_0_g10 = 2.0;
				float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
				float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
				float2 panner392 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g11 = panner392;
				float2 break6_g11 = temp_output_2_0_g11;
				float temp_output_25_0_g11 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g11 = (float2(( break6_g11.x + temp_output_25_0_g11 ) , break6_g11.y));
				float4 tex2DNode14_g11 = tex2D( _FoamNormal, temp_output_2_0_g11 );
				float temp_output_4_0_g11 = 2.0;
				float3 appendResult13_g11 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float2 appendResult9_g11 = (float2(break6_g11.x , ( break6_g11.y + temp_output_25_0_g11 )));
				float3 appendResult16_g11 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float3 normalizeResult22_g11 = normalize( cross( appendResult13_g11 , appendResult16_g11 ) );
				float4 color382 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos381 = packedInput.ase_texcoord3;
				float4 ase_screenPosNorm381 = screenPos381 / screenPos381.w;
				ase_screenPosNorm381.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm381.z : ase_screenPosNorm381.z * 0.5 + 0.5;
				float screenDepth381 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm381.xy ),_ZBufferParams);
				float distanceDepth381 = abs( ( screenDepth381 - LinearEyeDepth( ase_screenPosNorm381.z,_ZBufferParams ) ) / ( _Float3 ) );
				float clampResult384 = clamp( distanceDepth381 , 0.0 , 1.0 );
				float4 lerpResult385 = lerp( float4( ( normalizeResult22_g10 + normalizeResult22_g11 ) , 0.0 ) , color382 , clampResult384);
				float4 normalizeResult391 = normalize( ( float4( normalizeResult54_g44 , 0.0 ) + lerpResult385 ) );
				float4 Normal89 = normalizeResult391;
				
				surfaceDescription.Normal = Normal89.rgb;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Motion Vectors"
			Tags { "LightMode"="MotionVectors" }

			Cull [_CullMode]

			ZWrite On

			Stencil
			{
				Ref [_StencilRefMV]
				WriteMask [_StencilWriteMaskMV]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_MOTION_VECTORS
			#pragma multi_compile _ WRITE_NORMAL_BUFFER
			#pragma multi_compile _ WRITE_MSAA_DEPTH

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"


			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif


			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float3 previousPositionOS : TEXCOORD4;
				#if defined (_ADD_PRECOMPUTED_VELOCITY)
					float3 precomputedVelocity : TEXCOORD5;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 vmeshPositionCS : SV_Position;
				float3 vmeshInterp00 : TEXCOORD0;
				float3 vpassInterpolators0 : TEXCOORD1; //interpolators0
				float3 vpassInterpolators1 : TEXCOORD2; //interpolators1
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;
			sampler2D _NormalMap;
			sampler2D _FoamNormal;


			
			void BuildSurfaceData(FragInputs fragInputs, inout SmoothSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(SmoothSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			AttributesMesh ApplyMeshModification(AttributesMesh inputMesh, float3 timeParameters, inout PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS )
			{
				_TimeParameters.xyz = timeParameters;
				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				
				outputPackedVaryingsMeshToPS.ase_texcoord3.xyz = ase_worldPos;
				float3 vertexPos381 = inputMesh.positionOS;
				float4 ase_clipPos381 = TransformWorldToHClip( TransformObjectToWorld(vertexPos381));
				float4 screenPos381 = ComputeScreenPos( ase_clipPos381 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord4 = screenPos381;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord3.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS =  inputMesh.normalOS ;
				return inputMesh;
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh)
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS = (PackedVaryingsMeshToPS)0;
				AttributesMesh defaultMesh = inputMesh;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				inputMesh = ApplyMeshModification( inputMesh, _TimeParameters.xyz, outputPackedVaryingsMeshToPS);

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);

				float3 VMESHpositionRWS = positionRWS;
				float4 VMESHpositionCS = TransformWorldToHClip(positionRWS);

				float4 VPASSpreviousPositionCS;
				float4 VPASSpositionCS = mul(UNITY_MATRIX_UNJITTERED_VP, float4(VMESHpositionRWS, 1.0));

				bool forceNoMotion = unity_MotionVectorsParams.y == 0.0;
				if (forceNoMotion)
				{
					VPASSpreviousPositionCS = float4(0.0, 0.0, 0.0, 1.0);
				}
				else
				{
					bool hasDeformation = unity_MotionVectorsParams.x > 0.0;
					float3 effectivePositionOS = (hasDeformation ? inputMesh.previousPositionOS : defaultMesh.positionOS);
					#if defined(_ADD_PRECOMPUTED_VELOCITY)
					effectivePositionOS -= inputMesh.precomputedVelocity;
					#endif

					#if defined(HAVE_MESH_MODIFICATION)
						AttributesMesh previousMesh = defaultMesh;
						previousMesh.positionOS = effectivePositionOS ;
						PackedVaryingsMeshToPS test = (PackedVaryingsMeshToPS)0;
						float3 curTime = _TimeParameters.xyz;
						previousMesh = ApplyMeshModification(previousMesh, _LastTimeParameters.xyz, test);
						_TimeParameters.xyz = curTime;
						float3 previousPositionRWS = TransformPreviousObjectToWorld(previousMesh.positionOS);
					#else
						float3 previousPositionRWS = TransformPreviousObjectToWorld(effectivePositionOS);
					#endif

					#ifdef ATTRIBUTES_NEED_NORMAL
						float3 normalWS = TransformPreviousObjectToWorldNormal(defaultMesh.normalOS);
					#else
						float3 normalWS = float3(0.0, 0.0, 0.0);
					#endif

					#if defined(HAVE_VERTEX_MODIFICATION)
						//ApplyVertexModification(inputMesh, normalWS, previousPositionRWS, _LastTimeParameters.xyz);
					#endif

					VPASSpreviousPositionCS = mul(UNITY_MATRIX_PREV_VP, float4(previousPositionRWS, 1.0));
				}

				outputPackedVaryingsMeshToPS.vmeshPositionCS = VMESHpositionCS;
				outputPackedVaryingsMeshToPS.vmeshInterp00.xyz = VMESHpositionRWS;

				outputPackedVaryingsMeshToPS.vpassInterpolators0 = float3(VPASSpositionCS.xyw);
				outputPackedVaryingsMeshToPS.vpassInterpolators1 = float3(VPASSpreviousPositionCS.xyw);
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float3 previousPositionOS : TEXCOORD4;
				#if defined (_ADD_PRECOMPUTED_VELOCITY)
					float3 precomputedVelocity : TEXCOORD5;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.previousPositionOS = v.previousPositionOS;
				#if defined (_ADD_PRECOMPUTED_VELOCITY)
				o.precomputedVelocity = v.precomputedVelocity;
				#endif
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.previousPositionOS = patch[0].previousPositionOS * bary.x + patch[1].previousPositionOS * bary.y + patch[2].previousPositionOS * bary.z;
				#if defined (_ADD_PRECOMPUTED_VELOCITY)
					o.precomputedVelocity = patch[0].precomputedVelocity * bary.x + patch[1].precomputedVelocity * bary.y + patch[2].precomputedVelocity * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput
				, out float4 outMotionVector : SV_Target0
				#ifdef WRITE_NORMAL_BUFFER
				, out float4 outNormalBuffer : SV_Target1
					#ifdef WRITE_MSAA_DEPTH
						, out float1 depthColor : SV_Target2
					#endif
				#elif defined(WRITE_MSAA_DEPTH)
				, out float4 outNormalBuffer : SV_Target1
				, out float1 depthColor : SV_Target2
				#endif

				#ifdef _DEPTHOFFSET_ON
					, out float outputDepth : SV_Depth
				#endif
				
				)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.vmeshPositionCS;
				input.positionRWS = packedInput.vmeshInterp00.xyz;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SurfaceData surfaceData;
				BuiltinData builtinData;

				SmoothSurfaceDescription surfaceDescription = (SmoothSurfaceDescription)0;
				float localBicubicPrepare2_g46 = ( 0.0 );
				float3 ase_worldPos = packedInput.ase_texcoord3.xyz;
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 temp_output_51_0_g44 = WorldspaceUV61.xy;
				float2 break52_g44 = temp_output_51_0_g44;
				float temp_output_34_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult55_g44 = (float2(( break52_g44.x + temp_output_34_0_g44 ) , break52_g44.y));
				float2 Input_UV100_g46 = appendResult55_g44;
				float2 UV2_g46 = Input_UV100_g46;
				float4 TexelSize2_g46 = _NormalMap_TexelSize;
				float2 UV02_g46 = float2( 0,0 );
				float2 UV12_g46 = float2( 0,0 );
				float2 UV22_g46 = float2( 0,0 );
				float2 UV32_g46 = float2( 0,0 );
				float W02_g46 = 0;
				float W12_g46 = 0;
				{
				{
				 UV2_g46 = UV2_g46 * TexelSize2_g46.zw - 0.5;
				    float2 f = frac( UV2_g46 );
				    UV2_g46 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g46.x - 0.5, UV2_g46.x + 1.5, UV2_g46.y - 0.5, UV2_g46.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g46.xyxy;
				    UV02_g46 = off.xz;
				    UV12_g46 = off.yz;
				    UV22_g46 = off.xw;
				    UV32_g46 = off.yw;
				    W02_g46 = s.x / ( s.x + s.y );
				 W12_g46 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g46 = lerp( tex2D( _NormalMap, UV32_g46 ) , tex2D( _NormalMap, UV22_g46 ) , W02_g46);
				float4 lerpResult45_g46 = lerp( tex2D( _NormalMap, UV12_g46 ) , tex2D( _NormalMap, UV02_g46 ) , W02_g46);
				float4 lerpResult44_g46 = lerp( lerpResult46_g46 , lerpResult45_g46 , W12_g46);
				float4 Output_2D131_g46 = lerpResult44_g46;
				float4 break74_g46 = Output_2D131_g46;
				float localBicubicPrepare2_g45 = ( 0.0 );
				float2 Input_UV100_g45 = temp_output_51_0_g44;
				float2 UV2_g45 = Input_UV100_g45;
				float4 TexelSize2_g45 = _NormalMap_TexelSize;
				float2 UV02_g45 = float2( 0,0 );
				float2 UV12_g45 = float2( 0,0 );
				float2 UV22_g45 = float2( 0,0 );
				float2 UV32_g45 = float2( 0,0 );
				float W02_g45 = 0;
				float W12_g45 = 0;
				{
				{
				 UV2_g45 = UV2_g45 * TexelSize2_g45.zw - 0.5;
				    float2 f = frac( UV2_g45 );
				    UV2_g45 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g45.x - 0.5, UV2_g45.x + 1.5, UV2_g45.y - 0.5, UV2_g45.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g45.xyxy;
				    UV02_g45 = off.xz;
				    UV12_g45 = off.yz;
				    UV22_g45 = off.xw;
				    UV32_g45 = off.yw;
				    W02_g45 = s.x / ( s.x + s.y );
				 W12_g45 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g45 = lerp( tex2D( _NormalMap, UV32_g45 ) , tex2D( _NormalMap, UV22_g45 ) , W02_g45);
				float4 lerpResult45_g45 = lerp( tex2D( _NormalMap, UV12_g45 ) , tex2D( _NormalMap, UV02_g45 ) , W02_g45);
				float4 lerpResult44_g45 = lerp( lerpResult46_g45 , lerpResult45_g45 , W12_g45);
				float4 Output_2D131_g45 = lerpResult44_g45;
				float4 break74_g45 = Output_2D131_g45;
				float temp_output_57_85_g44 = break74_g45.g;
				float temp_output_43_0_g44 = _NormalStrength;
				float3 appendResult45_g44 = (float3(1.0 , 0.0 , ( ( break74_g46.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float localBicubicPrepare2_g47 = ( 0.0 );
				float2 appendResult38_g44 = (float2(break52_g44.x , ( break52_g44.y + temp_output_34_0_g44 )));
				float2 Input_UV100_g47 = appendResult38_g44;
				float2 UV2_g47 = Input_UV100_g47;
				float4 TexelSize2_g47 = _NormalMap_TexelSize;
				float2 UV02_g47 = float2( 0,0 );
				float2 UV12_g47 = float2( 0,0 );
				float2 UV22_g47 = float2( 0,0 );
				float2 UV32_g47 = float2( 0,0 );
				float W02_g47 = 0;
				float W12_g47 = 0;
				{
				{
				 UV2_g47 = UV2_g47 * TexelSize2_g47.zw - 0.5;
				    float2 f = frac( UV2_g47 );
				    UV2_g47 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g47.x - 0.5, UV2_g47.x + 1.5, UV2_g47.y - 0.5, UV2_g47.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g47.xyxy;
				    UV02_g47 = off.xz;
				    UV12_g47 = off.yz;
				    UV22_g47 = off.xw;
				    UV32_g47 = off.yw;
				    W02_g47 = s.x / ( s.x + s.y );
				 W12_g47 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g47 = lerp( tex2D( _NormalMap, UV32_g47 ) , tex2D( _NormalMap, UV22_g47 ) , W02_g47);
				float4 lerpResult45_g47 = lerp( tex2D( _NormalMap, UV12_g47 ) , tex2D( _NormalMap, UV02_g47 ) , W02_g47);
				float4 lerpResult44_g47 = lerp( lerpResult46_g47 , lerpResult45_g47 , W12_g47);
				float4 Output_2D131_g47 = lerpResult44_g47;
				float4 break74_g47 = Output_2D131_g47;
				float3 appendResult50_g44 = (float3(0.0 , 1.0 , ( ( break74_g47.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float3 normalizeResult54_g44 = normalize( cross( appendResult45_g44 , appendResult50_g44 ) );
				float4 temp_output_374_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner376 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g10 = panner376;
				float2 break6_g10 = temp_output_2_0_g10;
				float temp_output_25_0_g10 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
				float4 tex2DNode14_g10 = tex2D( _FoamNormal, temp_output_2_0_g10 );
				float temp_output_4_0_g10 = 2.0;
				float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
				float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
				float2 panner392 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g11 = panner392;
				float2 break6_g11 = temp_output_2_0_g11;
				float temp_output_25_0_g11 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g11 = (float2(( break6_g11.x + temp_output_25_0_g11 ) , break6_g11.y));
				float4 tex2DNode14_g11 = tex2D( _FoamNormal, temp_output_2_0_g11 );
				float temp_output_4_0_g11 = 2.0;
				float3 appendResult13_g11 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float2 appendResult9_g11 = (float2(break6_g11.x , ( break6_g11.y + temp_output_25_0_g11 )));
				float3 appendResult16_g11 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float3 normalizeResult22_g11 = normalize( cross( appendResult13_g11 , appendResult16_g11 ) );
				float4 color382 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos381 = packedInput.ase_texcoord4;
				float4 ase_screenPosNorm381 = screenPos381 / screenPos381.w;
				ase_screenPosNorm381.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm381.z : ase_screenPosNorm381.z * 0.5 + 0.5;
				float screenDepth381 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm381.xy ),_ZBufferParams);
				float distanceDepth381 = abs( ( screenDepth381 - LinearEyeDepth( ase_screenPosNorm381.z,_ZBufferParams ) ) / ( _Float3 ) );
				float clampResult384 = clamp( distanceDepth381 , 0.0 , 1.0 );
				float4 lerpResult385 = lerp( float4( ( normalizeResult22_g10 + normalizeResult22_g11 ) , 0.0 ) , color382 , clampResult384);
				float4 normalizeResult391 = normalize( ( float4( normalizeResult54_g44 , 0.0 ) + lerpResult385 ) );
				float4 Normal89 = normalizeResult391;
				
				surfaceDescription.Normal = Normal89.rgb;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, V, posInput, surfaceData, builtinData );

				float4 VPASSpositionCS = float4(packedInput.vpassInterpolators0.xy, 0.0, packedInput.vpassInterpolators0.z);
				float4 VPASSpreviousPositionCS = float4(packedInput.vpassInterpolators1.xy, 0.0, packedInput.vpassInterpolators1.z);

				#ifdef _DEPTHOFFSET_ON
				VPASSpositionCS.w += builtinData.depthOffset;
				VPASSpreviousPositionCS.w += builtinData.depthOffset;
				#endif

				float2 motionVector = CalculateMotionVector( VPASSpositionCS, VPASSpreviousPositionCS );
				EncodeMotionVector( motionVector * 0.5, outMotionVector );

				bool forceNoMotion = unity_MotionVectorsParams.y == 0.0;
				if( forceNoMotion )
					outMotionVector = float4( 2.0, 0.0, 0.0, 0.0 );

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );

				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.vmeshPositionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.vmeshPositionCS.z;
				#endif

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="Forward" }

			Blend [_SrcBlend] [_DstBlend], [_AlphaSrcBlend] [_AlphaDstBlend]
			Cull [_CullModeForward]
			ZTest [_ZTestDepthEqualForOpaque]
			ZWrite [_ZWrite]

			Stencil
			{
				Ref [_StencilRef]
				WriteMask [_StencilWriteMask]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			ColorMask [_ColorMaskTransparentVel] 1

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_LENGTH_CULL_TESSELLATION
			#define _MATERIAL_FEATURE_SPECULAR_COLOR 1
			#define _ENERGY_CONSERVING_SPECULAR 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#if !defined(DEBUG_DISPLAY) && defined(_ALPHATEST_ON)
			#define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
			#endif

			#define SHADERPASS SHADERPASS_FORWARD
			#pragma multi_compile _ DEBUG_DISPLAY
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
			#pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
			#define HAS_LIGHTLOOP
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_VERT_POSITION


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 previousPositionOS : TEXCOORD4;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						float3 precomputedVelocity : TEXCOORD5;
					#endif
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 vpassPositionCS : TEXCOORD5;
					float3 vpassPreviousPositionCS : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
				float4 ase_texcoord11 : TEXCOORD11;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _ChoppyMap_TexelSize;
			float4 _HeightMap_TexelSize;
			float4 _Albedo;
			float4 _NormalMap_TexelSize;
			float2 _Scale;
			float _Tiling;
			float _FoamDistance;
			float _NormalStrength;
			float _Float3;
			float _RefractionStrength;
			float _WaterClarity;
			float _Smoothness;
			float4 _EmissionColor;
			float _AlphaCutoff;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ChoppyMap;
			sampler2D _HeightMap;
			sampler2D _FoamTexture;
			sampler2D _NormalMap;
			sampler2D _FoamNormal;


			float4 ASEHDSampleSceneColor(float2 uv, float lod, float exposureMultiplier)
			{
				#if defined(REQUIRE_OPAQUE_TEXTURE) && defined(_SURFACE_TYPE_TRANSPARENT) && defined(SHADERPASS) && (SHADERPASS != SHADERPASS_LIGHT_TRANSPORT)
				return float4( SampleCameraColor(uv, lod) * exposureMultiplier, 1.0 );
				#endif
				return float4(0.0, 0.0, 0.0, 1.0);
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			AttributesMesh ApplyMeshModification(AttributesMesh inputMesh, float3 timeParameters, inout PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS )
			{
				_TimeParameters.xyz = timeParameters;
				float localBicubicPrepare2_g50 = ( 0.0 );
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float2 Input_UV100_g50 = WorldspaceUV61.xy;
				float2 UV2_g50 = Input_UV100_g50;
				float4 TexelSize2_g50 = _ChoppyMap_TexelSize;
				float2 UV02_g50 = float2( 0,0 );
				float2 UV12_g50 = float2( 0,0 );
				float2 UV22_g50 = float2( 0,0 );
				float2 UV32_g50 = float2( 0,0 );
				float W02_g50 = 0;
				float W12_g50 = 0;
				{
				{
				 UV2_g50 = UV2_g50 * TexelSize2_g50.zw - 0.5;
				    float2 f = frac( UV2_g50 );
				    UV2_g50 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g50.x - 0.5, UV2_g50.x + 1.5, UV2_g50.y - 0.5, UV2_g50.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g50.xyxy;
				    UV02_g50 = off.xz;
				    UV12_g50 = off.yz;
				    UV22_g50 = off.xw;
				    UV32_g50 = off.yw;
				    W02_g50 = s.x / ( s.x + s.y );
				 W12_g50 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV32_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV22_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult45_g50 = lerp( tex2Dlod( _ChoppyMap, float4( UV12_g50, 0, 0.0) ) , tex2Dlod( _ChoppyMap, float4( UV02_g50, 0, 0.0) ) , W02_g50);
				float4 lerpResult44_g50 = lerp( lerpResult46_g50 , lerpResult45_g50 , W12_g50);
				float4 Output_2D131_g50 = lerpResult44_g50;
				float4 break74_g50 = Output_2D131_g50;
				float localBicubicPrepare2_g49 = ( 0.0 );
				float2 Input_UV100_g49 = WorldspaceUV61.xy;
				float2 UV2_g49 = Input_UV100_g49;
				float4 TexelSize2_g49 = _HeightMap_TexelSize;
				float2 UV02_g49 = float2( 0,0 );
				float2 UV12_g49 = float2( 0,0 );
				float2 UV22_g49 = float2( 0,0 );
				float2 UV32_g49 = float2( 0,0 );
				float W02_g49 = 0;
				float W12_g49 = 0;
				{
				{
				 UV2_g49 = UV2_g49 * TexelSize2_g49.zw - 0.5;
				    float2 f = frac( UV2_g49 );
				    UV2_g49 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g49.x - 0.5, UV2_g49.x + 1.5, UV2_g49.y - 0.5, UV2_g49.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g49.xyxy;
				    UV02_g49 = off.xz;
				    UV12_g49 = off.yz;
				    UV22_g49 = off.xw;
				    UV32_g49 = off.yw;
				    W02_g49 = s.x / ( s.x + s.y );
				 W12_g49 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g49 = lerp( tex2Dlod( _HeightMap, float4( UV32_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV22_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult45_g49 = lerp( tex2Dlod( _HeightMap, float4( UV12_g49, 0, 0.0) ) , tex2Dlod( _HeightMap, float4( UV02_g49, 0, 0.0) ) , W02_g49);
				float4 lerpResult44_g49 = lerp( lerpResult46_g49 , lerpResult45_g49 , W12_g49);
				float4 Output_2D131_g49 = lerpResult44_g49;
				float4 break74_g49 = Output_2D131_g49;
				float4 appendResult24 = (float4(break74_g50.r , break74_g49.g , break74_g50.b , 0.0));
				float4 WaveDisplacement225 = appendResult24;
				
				float3 vertexPos268 = inputMesh.positionOS;
				float4 ase_clipPos268 = TransformWorldToHClip( TransformObjectToWorld(vertexPos268));
				float4 screenPos268 = ComputeScreenPos( ase_clipPos268 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord7 = screenPos268;
				
				float3 vertexPos381 = inputMesh.positionOS;
				float4 ase_clipPos381 = TransformWorldToHClip( TransformObjectToWorld(vertexPos381));
				float4 screenPos381 = ComputeScreenPos( ase_clipPos381 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord8 = screenPos381;
				
				float4 ase_clipPos = TransformWorldToHClip( TransformObjectToWorld(inputMesh.positionOS));
				float4 screenPos = ComputeScreenPos( ase_clipPos , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord9 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(inputMesh.positionOS));
				float eyeDepth = -objectToViewPos.z;
				outputPackedVaryingsMeshToPS.ase_texcoord10.x = eyeDepth;
				float3 vertexPos235 = inputMesh.positionOS;
				float4 ase_clipPos235 = TransformWorldToHClip( TransformObjectToWorld(vertexPos235));
				float4 screenPos235 = ComputeScreenPos( ase_clipPos235 , _ProjectionParams.x );
				outputPackedVaryingsMeshToPS.ase_texcoord11 = screenPos235;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord10.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = WaveDisplacement225.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS = inputMesh.normalOS;
				inputMesh.tangentOS = inputMesh.tangentOS;
				return inputMesh;
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh)
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS = (PackedVaryingsMeshToPS)0;
				AttributesMesh defaultMesh = inputMesh;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				inputMesh = ApplyMeshModification( inputMesh, _TimeParameters.xyz, outputPackedVaryingsMeshToPS);

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
				float4 VPASSpreviousPositionCS;
				float4 VPASSpositionCS = mul(UNITY_MATRIX_UNJITTERED_VP, float4(positionRWS, 1.0));

				bool forceNoMotion = unity_MotionVectorsParams.y == 0.0;
				if (forceNoMotion)
				{
					VPASSpreviousPositionCS = float4(0.0, 0.0, 0.0, 1.0);
				}
				else
				{
					bool hasDeformation = unity_MotionVectorsParams.x > 0.0;
					float3 effectivePositionOS = (hasDeformation ? inputMesh.previousPositionOS : defaultMesh.positionOS);
					#if defined(_ADD_PRECOMPUTED_VELOCITY)
					effectivePositionOS -= inputMesh.precomputedVelocity;
					#endif

					#if defined(HAVE_MESH_MODIFICATION)
						AttributesMesh previousMesh = defaultMesh;
						previousMesh.positionOS = effectivePositionOS ;
						PackedVaryingsMeshToPS test = (PackedVaryingsMeshToPS)0;
						float3 curTime = _TimeParameters.xyz;
						previousMesh = ApplyMeshModification(previousMesh, _LastTimeParameters.xyz, test);
						_TimeParameters.xyz = curTime;
						float3 previousPositionRWS = TransformPreviousObjectToWorld(previousMesh.positionOS);
					#else
						float3 previousPositionRWS = TransformPreviousObjectToWorld(effectivePositionOS);
					#endif

					#ifdef ATTRIBUTES_NEED_NORMAL
						float3 normalWS = TransformPreviousObjectToWorldNormal(defaultMesh.normalOS);
					#else
						float3 normalWS = float3(0.0, 0.0, 0.0);
					#endif

					#if defined(HAVE_VERTEX_MODIFICATION)
						//ApplyVertexModification(inputMesh, normalWS, previousPositionRWS, _LastTimeParameters.xyz);
					#endif

					VPASSpreviousPositionCS = mul(UNITY_MATRIX_PREV_VP, float4(previousPositionRWS, 1.0));
				}
				#endif

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					outputPackedVaryingsMeshToPS.vpassPositionCS = float3(VPASSpositionCS.xyw);
					outputPackedVaryingsMeshToPS.vpassPreviousPositionCS = float3(VPASSpreviousPositionCS.xyw);
				#endif
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 previousPositionOS : TEXCOORD4;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						float3 precomputedVelocity : TEXCOORD5;
					#endif
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					o.previousPositionOS = v.previousPositionOS;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						o.precomputedVelocity = v.precomputedVelocity;
					#endif
				#endif
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					o.previousPositionOS = patch[0].previousPositionOS * bary.x + patch[1].previousPositionOS * bary.y + patch[2].previousPositionOS * bary.z;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						o.precomputedVelocity = patch[0].precomputedVelocity * bary.x + patch[1].precomputedVelocity * bary.y + patch[2].precomputedVelocity * bary.z;
					#endif
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag(PackedVaryingsMeshToPS packedInput,
					#ifdef OUTPUT_SPLIT_LIGHTING
						out float4 outColor : SV_Target0,
						out float4 outDiffuseLighting : SV_Target1,
						OUTPUT_SSSBUFFER(outSSSBuffer)
					#else
						out float4 outColor : SV_Target0
					#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
						, out float4 outMotionVec : SV_Target1
					#endif
					#endif
					#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
					#endif
					
						)
			{
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					outMotionVec = float4(2.0, 0.0, 0.0, 0.0);
				#endif

				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				input.positionSS.xy = _OffScreenRendering > 0 ? (input.positionSS.xy * _OffScreenDownsampleFactor) : input.positionSS.xy;
				uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize ();

				PositionInputs posInput = GetPositionInput( input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex );

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				float4 appendResult54 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
				float4 WorldSpace55 = appendResult54;
				float4 WorldspaceUV61 = ( ( WorldSpace55 * float4( _Scale, 0.0 , 0.0 ) ) * _Tiling );
				float4 temp_output_261_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner270 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_261_0.xy);
				float2 panner397 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_261_0.xy);
				float4 screenPos268 = packedInput.ase_texcoord7;
				float4 ase_screenPosNorm268 = screenPos268 / screenPos268.w;
				ase_screenPosNorm268.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm268.z : ase_screenPosNorm268.z * 0.5 + 0.5;
				float screenDepth268 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm268.xy ),_ZBufferParams);
				float distanceDepth268 = abs( ( screenDepth268 - LinearEyeDepth( ase_screenPosNorm268.z,_ZBufferParams ) ) / ( _FoamDistance ) );
				float clampResult269 = clamp( distanceDepth268 , 0.0 , 1.0 );
				float4 lerpResult266 = lerp( ( tex2D( _FoamTexture, panner270 ) + tex2D( _FoamTexture, panner397 ) ) , _Albedo , clampResult269);
				float4 Color229 = lerpResult266;
				
				float localBicubicPrepare2_g46 = ( 0.0 );
				float2 temp_output_51_0_g44 = WorldspaceUV61.xy;
				float2 break52_g44 = temp_output_51_0_g44;
				float temp_output_34_0_g44 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult55_g44 = (float2(( break52_g44.x + temp_output_34_0_g44 ) , break52_g44.y));
				float2 Input_UV100_g46 = appendResult55_g44;
				float2 UV2_g46 = Input_UV100_g46;
				float4 TexelSize2_g46 = _NormalMap_TexelSize;
				float2 UV02_g46 = float2( 0,0 );
				float2 UV12_g46 = float2( 0,0 );
				float2 UV22_g46 = float2( 0,0 );
				float2 UV32_g46 = float2( 0,0 );
				float W02_g46 = 0;
				float W12_g46 = 0;
				{
				{
				 UV2_g46 = UV2_g46 * TexelSize2_g46.zw - 0.5;
				    float2 f = frac( UV2_g46 );
				    UV2_g46 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g46.x - 0.5, UV2_g46.x + 1.5, UV2_g46.y - 0.5, UV2_g46.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g46.xyxy;
				    UV02_g46 = off.xz;
				    UV12_g46 = off.yz;
				    UV22_g46 = off.xw;
				    UV32_g46 = off.yw;
				    W02_g46 = s.x / ( s.x + s.y );
				 W12_g46 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g46 = lerp( tex2D( _NormalMap, UV32_g46 ) , tex2D( _NormalMap, UV22_g46 ) , W02_g46);
				float4 lerpResult45_g46 = lerp( tex2D( _NormalMap, UV12_g46 ) , tex2D( _NormalMap, UV02_g46 ) , W02_g46);
				float4 lerpResult44_g46 = lerp( lerpResult46_g46 , lerpResult45_g46 , W12_g46);
				float4 Output_2D131_g46 = lerpResult44_g46;
				float4 break74_g46 = Output_2D131_g46;
				float localBicubicPrepare2_g45 = ( 0.0 );
				float2 Input_UV100_g45 = temp_output_51_0_g44;
				float2 UV2_g45 = Input_UV100_g45;
				float4 TexelSize2_g45 = _NormalMap_TexelSize;
				float2 UV02_g45 = float2( 0,0 );
				float2 UV12_g45 = float2( 0,0 );
				float2 UV22_g45 = float2( 0,0 );
				float2 UV32_g45 = float2( 0,0 );
				float W02_g45 = 0;
				float W12_g45 = 0;
				{
				{
				 UV2_g45 = UV2_g45 * TexelSize2_g45.zw - 0.5;
				    float2 f = frac( UV2_g45 );
				    UV2_g45 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g45.x - 0.5, UV2_g45.x + 1.5, UV2_g45.y - 0.5, UV2_g45.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g45.xyxy;
				    UV02_g45 = off.xz;
				    UV12_g45 = off.yz;
				    UV22_g45 = off.xw;
				    UV32_g45 = off.yw;
				    W02_g45 = s.x / ( s.x + s.y );
				 W12_g45 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g45 = lerp( tex2D( _NormalMap, UV32_g45 ) , tex2D( _NormalMap, UV22_g45 ) , W02_g45);
				float4 lerpResult45_g45 = lerp( tex2D( _NormalMap, UV12_g45 ) , tex2D( _NormalMap, UV02_g45 ) , W02_g45);
				float4 lerpResult44_g45 = lerp( lerpResult46_g45 , lerpResult45_g45 , W12_g45);
				float4 Output_2D131_g45 = lerpResult44_g45;
				float4 break74_g45 = Output_2D131_g45;
				float temp_output_57_85_g44 = break74_g45.g;
				float temp_output_43_0_g44 = _NormalStrength;
				float3 appendResult45_g44 = (float3(1.0 , 0.0 , ( ( break74_g46.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float localBicubicPrepare2_g47 = ( 0.0 );
				float2 appendResult38_g44 = (float2(break52_g44.x , ( break52_g44.y + temp_output_34_0_g44 )));
				float2 Input_UV100_g47 = appendResult38_g44;
				float2 UV2_g47 = Input_UV100_g47;
				float4 TexelSize2_g47 = _NormalMap_TexelSize;
				float2 UV02_g47 = float2( 0,0 );
				float2 UV12_g47 = float2( 0,0 );
				float2 UV22_g47 = float2( 0,0 );
				float2 UV32_g47 = float2( 0,0 );
				float W02_g47 = 0;
				float W12_g47 = 0;
				{
				{
				 UV2_g47 = UV2_g47 * TexelSize2_g47.zw - 0.5;
				    float2 f = frac( UV2_g47 );
				    UV2_g47 -= f;
				    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
				    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
				    float4 xs = xn * xn * xn;
				    float4 ys = yn * yn * yn;
				    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
				    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
				    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
				 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
				    float4 c = float4( UV2_g47.x - 0.5, UV2_g47.x + 1.5, UV2_g47.y - 0.5, UV2_g47.y + 1.5 );
				    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
				    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g47.xyxy;
				    UV02_g47 = off.xz;
				    UV12_g47 = off.yz;
				    UV22_g47 = off.xw;
				    UV32_g47 = off.yw;
				    W02_g47 = s.x / ( s.x + s.y );
				 W12_g47 = s.z / ( s.z + s.w );
				}
				}
				float4 lerpResult46_g47 = lerp( tex2D( _NormalMap, UV32_g47 ) , tex2D( _NormalMap, UV22_g47 ) , W02_g47);
				float4 lerpResult45_g47 = lerp( tex2D( _NormalMap, UV12_g47 ) , tex2D( _NormalMap, UV02_g47 ) , W02_g47);
				float4 lerpResult44_g47 = lerp( lerpResult46_g47 , lerpResult45_g47 , W12_g47);
				float4 Output_2D131_g47 = lerpResult44_g47;
				float4 break74_g47 = Output_2D131_g47;
				float3 appendResult50_g44 = (float3(0.0 , 1.0 , ( ( break74_g47.g - temp_output_57_85_g44 ) * temp_output_43_0_g44 )));
				float3 normalizeResult54_g44 = normalize( cross( appendResult45_g44 , appendResult50_g44 ) );
				float4 temp_output_374_0 = ( WorldspaceUV61 * 20.0 );
				float2 panner376 = ( _TimeParameters.x * float2( 1,-1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g10 = panner376;
				float2 break6_g10 = temp_output_2_0_g10;
				float temp_output_25_0_g10 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
				float4 tex2DNode14_g10 = tex2D( _FoamNormal, temp_output_2_0_g10 );
				float temp_output_4_0_g10 = 2.0;
				float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
				float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g10 ).g - tex2DNode14_g10.g ) * temp_output_4_0_g10 )));
				float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
				float2 panner392 = ( 1.0 * _Time.y * float2( -2,1 ) + temp_output_374_0.xy);
				float2 temp_output_2_0_g11 = panner392;
				float2 break6_g11 = temp_output_2_0_g11;
				float temp_output_25_0_g11 = ( pow( 0.5 , 3.0 ) * 0.1 );
				float2 appendResult8_g11 = (float2(( break6_g11.x + temp_output_25_0_g11 ) , break6_g11.y));
				float4 tex2DNode14_g11 = tex2D( _FoamNormal, temp_output_2_0_g11 );
				float temp_output_4_0_g11 = 2.0;
				float3 appendResult13_g11 = (float3(1.0 , 0.0 , ( ( tex2D( _FoamNormal, appendResult8_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float2 appendResult9_g11 = (float2(break6_g11.x , ( break6_g11.y + temp_output_25_0_g11 )));
				float3 appendResult16_g11 = (float3(0.0 , 1.0 , ( ( tex2D( _FoamNormal, appendResult9_g11 ).g - tex2DNode14_g11.g ) * temp_output_4_0_g11 )));
				float3 normalizeResult22_g11 = normalize( cross( appendResult13_g11 , appendResult16_g11 ) );
				float4 color382 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos381 = packedInput.ase_texcoord8;
				float4 ase_screenPosNorm381 = screenPos381 / screenPos381.w;
				ase_screenPosNorm381.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm381.z : ase_screenPosNorm381.z * 0.5 + 0.5;
				float screenDepth381 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm381.xy ),_ZBufferParams);
				float distanceDepth381 = abs( ( screenDepth381 - LinearEyeDepth( ase_screenPosNorm381.z,_ZBufferParams ) ) / ( _Float3 ) );
				float clampResult384 = clamp( distanceDepth381 , 0.0 , 1.0 );
				float4 lerpResult385 = lerp( float4( ( normalizeResult22_g10 + normalizeResult22_g11 ) , 0.0 ) , color382 , clampResult384);
				float4 normalizeResult391 = normalize( ( float4( normalizeResult54_g44 , 0.0 ) + lerpResult385 ) );
				float4 Normal89 = normalizeResult391;
				
				float2 temp_output_20_0_g48 = ( (Normal89.rgb).xy * ( _RefractionStrength / 1.0 ) * 1.0 );
				float4 screenPos = packedInput.ase_texcoord9;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth2_g48 = LinearEyeDepth(SampleCameraDepth( ( float4( temp_output_20_0_g48, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float eyeDepth = packedInput.ase_texcoord10.x;
				float2 temp_output_32_0_g48 = (( float4( ( temp_output_20_0_g48 * saturate( ( eyeDepth2_g48 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal74 = ASEHDSampleSceneColor(temp_output_32_0_g48, 0, GetInverseCurrentExposureMultiplier());
				float4 color233 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos235 = packedInput.ase_texcoord11;
				float4 ase_screenPosNorm235 = screenPos235 / screenPos235.w;
				ase_screenPosNorm235.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm235.z : ase_screenPosNorm235.z * 0.5 + 0.5;
				float screenDepth235 = LinearEyeDepth(SampleCameraDepth( ase_screenPosNorm235.xy ),_ZBufferParams);
				float distanceDepth235 = saturate( abs( ( screenDepth235 - LinearEyeDepth( ase_screenPosNorm235.z,_ZBufferParams ) ) / ( _WaterClarity ) ) );
				float clampResult310 = clamp( ( _WorldSpaceCameraPos.y - ase_worldPos.y ) , 0.0 , 1.0 );
				float4 lerpResult227 = lerp( fetchOpaqueVal74 , color233 , ( saturate( distanceDepth235 ) * ceil( clampResult310 ) ));
				float4 Refracted75 = saturate( lerpResult227 );
				
				surfaceDescription.Albedo = Color229.rgb;
				surfaceDescription.Normal = Normal89.rgb;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = Refracted75.rgb;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = 1;
				surfaceDescription.Alpha = 1;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _AlphaCutoff;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

				PreLightData preLightData = GetPreLightData(V, posInput, bsdfData);

				outColor = float4(0.0, 0.0, 0.0, 0.0);
				#ifdef DEBUG_DISPLAY
				#ifdef OUTPUT_SPLIT_LIGHTING
					outDiffuseLighting = 0;
					ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
				#endif

				bool viewMaterial = false;
				int bufferSize = int(_DebugViewMaterialArray[0]);
				if (bufferSize != 0)
				{
					bool needLinearToSRGB = false;
					float3 result = float3(1.0, 0.0, 1.0);

					for (int index = 1; index <= bufferSize; index++)
					{
						int indexMaterialProperty = int(_DebugViewMaterialArray[index]);

						if (indexMaterialProperty != 0)
						{
							viewMaterial = true;

							GetPropertiesDataDebug(indexMaterialProperty, result, needLinearToSRGB);
							GetVaryingsDataDebug(indexMaterialProperty, input, result, needLinearToSRGB);
							GetBuiltinDataDebug(indexMaterialProperty, builtinData, result, needLinearToSRGB);
							GetSurfaceDataDebug(indexMaterialProperty, surfaceData, result, needLinearToSRGB);
							GetBSDFDataDebug(indexMaterialProperty, bsdfData, result, needLinearToSRGB);
						}
					}

					if (!needLinearToSRGB)
						result = SRGBToLinear(max(0, result));

					outColor = float4(result, 1.0);
				}

				if (!viewMaterial)
				{
					if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_DIFFUSE_COLOR || _DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_SPECULAR_COLOR)
					{
						float3 result = float3(0.0, 0.0, 0.0);

						GetPBRValidatorDebug(surfaceData, result);

						outColor = float4(result, 1.0f);
					}
					else if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_TRANSPARENCY_OVERDRAW)
					{
						float4 result = _DebugTransparencyOverdrawWeight * float4(TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_A);
						outColor = result;
					}
					else
				#endif
					{
				#ifdef _SURFACE_TYPE_TRANSPARENT
						uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
				#else
						uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_OPAQUE;
				#endif
						float3 diffuseLighting;
						float3 specularLighting;

						LightLoop(V, posInput, preLightData, bsdfData, builtinData, featureFlags, diffuseLighting, specularLighting);

						diffuseLighting *= GetCurrentExposureMultiplier();
						specularLighting *= GetCurrentExposureMultiplier();

				#ifdef OUTPUT_SPLIT_LIGHTING
						if (_EnableSubsurfaceScattering != 0 && ShouldOutputSplitLighting(bsdfData))
						{
							outColor = float4(specularLighting, 1.0);
							outDiffuseLighting = float4(TagLightingForSSS(diffuseLighting), 1.0);
						}
						else
						{
							outColor = float4(diffuseLighting + specularLighting, 1.0);
							outDiffuseLighting = 0;
						}
						ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
				#else
						outColor = ApplyBlendMode(diffuseLighting, specularLighting, builtinData.opacity);
						outColor = EvaluateAtmosphericScattering(posInput, V, outColor);
				#endif

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
						float4 VPASSpositionCS = float4(packedInput.vpassPositionCS.xy, 0.0, packedInput.vpassPositionCS.z);
						float4 VPASSpreviousPositionCS = float4(packedInput.vpassPreviousPositionCS.xy, 0.0, packedInput.vpassPreviousPositionCS.z);

						bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
						if (!forceNoMotion)
						{
							float2 motionVec = CalculateMotionVector(VPASSpositionCS, VPASSpreviousPositionCS);
							EncodeMotionVector(motionVec * 0.5, outMotionVec);
							outMotionVec.zw = 1.0;
						}
				#endif
					}

				#ifdef DEBUG_DISPLAY
				}
				#endif

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.Rendering.HighDefinition.HDLitGUI"
	
	
}
/*ASEBEGIN
Version=18712
224;73;1418;655;1507.416;-588.3025;1.880654;True;True
Node;AmplifyShaderEditor.CommentaryNode;299;-3494.476,27.67888;Inherit;False;1301.082;378.5306;WorldspaceUV;8;53;54;55;58;59;57;60;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;53;-3444.476,77.67888;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;54;-3193.575,80.27888;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-3041.075,111.4789;Inherit;False;WorldSpace;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;58;-2992.176,242.2095;Inherit;False;Property;_Scale;Scale;8;0;Create;True;0;0;0;False;0;False;1,1;0.75,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;57;-2767.676,282.0753;Inherit;False;Property;_Tiling;Tiling;7;0;Create;True;0;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2792.659,118.1521;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2611.049,114.3152;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2417.394,115.3879;Inherit;False;WorldspaceUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-3816.712,2466.916;Inherit;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;372;-3871.106,2381.07;Inherit;False;61;WorldspaceUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3919.106,2301.07;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;393;-3670.289,2638.795;Inherit;False;Constant;_Vector2;Vector 2;16;0;Create;True;0;0;0;False;0;False;-2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;375;-3759.106,2301.07;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;373;-3775.106,2141.07;Inherit;False;Constant;_Vector1;Vector 1;13;0;Create;True;0;0;0;False;0;False;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;-3616.385,2463.591;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;392;-3437.096,2604.17;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;376;-3478.588,2301.361;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;379;-3032.696,2743.316;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;364;-3898.556,1840.336;Inherit;True;Property;_FoamNormal;FoamNormal;17;0;Create;True;0;0;0;False;0;False;None;cf98c510542f6ea459cf1be46b46d4c9;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;378;-3012.562,2905.505;Inherit;False;Property;_Float3;Float 3;13;0;Create;True;0;0;0;False;0;False;0;0;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-3215.649,710.1585;Inherit;True;Property;_NormalMap;NormalMap;6;0;Create;True;0;0;0;False;0;False;c5c3e64f92f00cc4da3437bfe1bde8e3;;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DepthFade;381;-2752.888,2793.067;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;395;-3183.595,2484.712;Inherit;False;NormalCreate;1;;11;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;388;-3221.87,2179.866;Inherit;False;NormalCreate;1;;10;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-2969.62,726.3773;Inherit;False;NormalMap;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-2780.528,1311.8;Inherit;False;195;NormalMap;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;382;-2584.359,1938.138;Inherit;False;Constant;_FoamNormalStrength;FoamNormalStrength;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0.7450981;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;204;-2838.468,1571.659;Inherit;False;61;WorldspaceUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;396;-2851.655,2324.758;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;384;-2489.316,2821.662;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-2833.305,1697.049;Inherit;False;Property;_NormalStrength;NormalStrength;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;218;-2533.83,1396.862;Inherit;True;BicubicNormalCreate;3;;44;6c559f1e2c343a9439eb498f8880ec95;0;4;39;SAMPLER2D;;False;51;FLOAT2;0,0;False;42;FLOAT;0.5;False;43;FLOAT;2;False;1;FLOAT3;56
Node;AmplifyShaderEditor.LerpOp;385;-2204.498,2223.476;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;366;-2079.18,1631.73;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;308;-503.6964,2288.274;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;309;-534.6964,2096.274;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;391;-1945.228,1618.174;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;237;-446.5492,1596.584;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1704.64,1601.208;Inherit;False;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-1808,-800;Inherit;False;61;WorldspaceUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1753.606,-714.1539;Inherit;False;Constant;_Float4;Float 4;13;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-1856,-880;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;-1473.029,1427.195;Inherit;False;Property;_WaterClarity;WaterClarity;11;0;Create;True;0;0;0;False;0;False;25;38;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;303;-243.4469,2228.292;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;310;-66.69641,2231.274;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-1145.237,1124.432;Inherit;False;Property;_RefractionStrength;RefractionStrength;14;0;Create;True;0;0;0;False;0;False;0;0.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;-1040.995,1026.867;Inherit;False;89;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;235;-174.1563,1682.686;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-1553.279,-717.4792;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;398;-1566.412,-437.5876;Inherit;False;Constant;_Vector3;Vector 3;17;0;Create;True;0;0;0;False;0;False;-2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;274;-1712,-1040;Inherit;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;0;False;0;False;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;271;-1696,-880;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;397;-1363.769,-583.1202;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;312;104.9948,2238.794;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;270;-1415.482,-879.7091;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;258;-1462.904,-1106.917;Inherit;True;Property;_FoamTexture;FoamTexture;16;0;Create;True;0;0;0;False;0;False;None;d5c8151d0e0bcf046887fc78cecd1b1b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;276;84.4483,1696.608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1361.93,-3.804336;Inherit;False;Property;_FoamDistance;FoamDistance;12;0;Create;True;0;0;0;False;0;False;0;3.7;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;298;-3562.461,-1260.13;Inherit;False;1434;996.9998;Wave;10;33;290;18;219;291;24;225;93;92;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;255;-1382.064,-165.9936;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;221;-779.3675,1112.11;Inherit;False;DepthMaskedRefraction;-1;;48;c805f061214177c42bca056464193f81;2,40,1,103,1;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.ColorNode;233;-215.5896,1354.847;Inherit;False;Constant;_Color0;Color 0;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;323.5934,1975.342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3512.461,-890.1304;Inherit;True;Property;_HeightMap;HeightMap;5;0;Create;True;0;0;0;False;0;False;cb3ab42d3f6a4494fb306c32d91af450;;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DepthFade;268;-1102.256,-116.2425;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;290;-3288.461,-1210.13;Inherit;True;Property;_ChoppyMap;ChoppyMap;15;0;Create;True;0;0;0;False;0;False;None;;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ScreenColorNode;74;-210.6983,1004.54;Inherit;False;Global;_GrabScreen0;Grab Screen 0;9;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;33;-3480.461,-666.1304;Inherit;False;61;WorldspaceUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;400;-1185.318,-604.8907;Inherit;True;Property;_TextureSample3;Texture Sample 3;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;259;-1216.736,-1027.347;Inherit;True;Property;_TextureSample12;Texture Sample 12;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;227;53.81741,1291.784;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;219;-3032.461,-922.1304;Inherit;True;Bicubic Sample;-1;;49;ce0e14d5ad5eac645b2e5892ab3506ff;2,92,0,72,0;7;99;SAMPLER2D;0;False;91;SAMPLER2DARRAY;0;False;93;FLOAT;0;False;97;FLOAT2;0,0;False;198;FLOAT4;0,0,0,0;False;199;FLOAT2;0,0;False;94;SAMPLERSTATE;0;False;5;COLOR;86;FLOAT;84;FLOAT;85;FLOAT;82;FLOAT;83
Node;AmplifyShaderEditor.SimpleAddOpNode;401;-844.3372,-844.15;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;291;-2936.461,-1162.13;Inherit;False;Bicubic Sample;-1;;50;ce0e14d5ad5eac645b2e5892ab3506ff;2,92,0,72,0;7;99;SAMPLER2D;0;False;91;SAMPLER2DARRAY;0;False;93;FLOAT;0;False;97;FLOAT2;0,0;False;198;FLOAT4;0,0,0,0;False;199;FLOAT2;0,0;False;94;SAMPLERSTATE;0;False;5;COLOR;86;FLOAT;84;FLOAT;85;FLOAT;82;FLOAT;83
Node;AmplifyShaderEditor.ColorNode;1;-1038.581,-1258.49;Inherit;False;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;0.1177465,0.1929061,0.509434,0;0,0.216981,0.1696607,0.7450981;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;269;-838.6844,-87.64722;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-2632.461,-714.1304;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;277;246.0543,1298.285;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;266;-654.8328,-1000.38;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-2376.461,-426.1304;Inherit;False;WaveDisplacement;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;436.3227,1287.213;Inherit;False;Refracted;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;-423.1241,-925.9202;Inherit;True;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;363;-1192.004,-744.1487;Inherit;False;FoamPan;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;230;34.72877,-38.5159;Inherit;False;229;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2424.461,-602.1304;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;17.14596,309.9416;Inherit;False;75;Refracted;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-33.05823,476.2376;Inherit;False;225;WaveDisplacement;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;403;-742.9666,837.2921;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;93;-2680.461,-506.1304;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;91;-3000.461,-522.1304;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;42.8593,74.08182;Inherit;False;89;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-175.5504,185.0282;Inherit;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;0;False;0;False;1;0.99;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;META;0;1;META;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;9;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentBackface;0;7;TransparentBackface;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-19;0;True;-20;1;0;True;-21;0;True;-22;False;False;False;False;False;False;False;False;True;1;False;-1;False;True;True;True;True;True;0;True;-44;False;False;False;True;0;True;-23;True;0;True;-31;False;True;1;LightMode=TransparentBackface;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;12;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Forward;0;10;Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-19;0;True;-20;1;0;True;-21;0;True;-22;False;False;False;False;False;False;False;False;True;0;True;-28;False;True;True;True;True;True;0;True;-44;False;False;True;True;0;True;-4;255;False;-1;255;True;-5;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;True;-23;True;0;True;-30;False;True;1;LightMode=Forward;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Motion Vectors;0;5;Motion Vectors;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;True;0;True;-25;False;False;False;False;True;True;0;True;-8;255;False;-1;255;True;-9;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=MotionVectors;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;11;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPostpass;0;9;TransparentDepthPostpass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPostpass;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;257.7093,37.6768;Float;False;True;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;WaterAmplify;53b46d85872c5b24c8f4f0a1c3fe4c87;True;GBuffer;0;0;GBuffer;35;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;True;0;True;-25;False;False;False;False;True;True;0;True;-13;255;False;-1;255;True;-12;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;0;True;-18;False;True;1;LightMode=GBuffer;False;0;;0;0;Standard;41;Surface Type;0;  Rendering Pass;0;  Refraction Model;0;    Blending Mode;0;    Blend Preserves Specular;1;  Receive Fog;1;  Back Then Front Rendering;1;  Transparent Depth Prepass;1;  Transparent Depth Postpass;1;  Transparent Writes Motion Vector;0;  Distortion;0;    Distortion Mode;0;    Distortion Depth Test;0;  ZWrite;0;  Z Test;4;Double-Sided;1;Alpha Clipping;0;  Use Shadow Threshold;0;Material Type,InvertActionOnDeselection;4;  Energy Conserving Specular;1;  Transmission;1;Receive Decals;0;Receives SSR;1;Motion Vectors;0;  Add Precomputed Velocity;0;Specular AA;0;Specular Occlusion Mode;1;Override Baked GI;0;Depth Offset;0;DOTS Instancing;1;LOD CrossFade;0;Tessellation;1;  Phong;1;  Strength;1,False,-1;  Type;3;  Tess;32,False,-1;  Min;1,False,-1;  Max;1000,False,-1;  Edge Length;2,False,-1;  Max Displacement;25,False,-1;Vertex Position;1;0;11;True;True;True;True;True;True;False;False;False;False;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;DepthOnly;0;4;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;True;0;True;-25;False;False;False;False;True;True;0;True;-6;255;False;-1;255;True;-7;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;8;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Distortion;0;6;Distortion;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;4;1;False;-1;1;False;-1;1;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;True;0;True;-10;255;False;-1;255;True;-11;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;False;-1;False;True;1;LightMode=DistortionVectors;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;10;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPrepass;0;8;TransparentDepthPrepass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPrepass;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;0;;0;0;Standard;0;False;0
WireConnection;54;0;53;1
WireConnection;54;1;53;3
WireConnection;55;0;54;0
WireConnection;59;0;55;0
WireConnection;59;1;58;0
WireConnection;60;0;59;0
WireConnection;60;1;57;0
WireConnection;61;0;60;0
WireConnection;375;0;370;0
WireConnection;374;0;372;0
WireConnection;374;1;371;0
WireConnection;392;0;374;0
WireConnection;392;2;393;0
WireConnection;376;0;374;0
WireConnection;376;2;373;0
WireConnection;376;1;375;0
WireConnection;381;1;379;0
WireConnection;381;0;378;0
WireConnection;395;1;364;0
WireConnection;395;2;392;0
WireConnection;388;1;364;0
WireConnection;388;2;376;0
WireConnection;195;0;17;0
WireConnection;396;0;388;0
WireConnection;396;1;395;0
WireConnection;384;0;381;0
WireConnection;218;39;207;0
WireConnection;218;51;204;0
WireConnection;218;43;205;0
WireConnection;385;0;396;0
WireConnection;385;1;382;0
WireConnection;385;2;384;0
WireConnection;366;0;218;56
WireConnection;366;1;385;0
WireConnection;391;0;366;0
WireConnection;89;0;391;0
WireConnection;303;0;309;2
WireConnection;303;1;308;2
WireConnection;310;0;303;0
WireConnection;235;1;237;0
WireConnection;235;0;241;0
WireConnection;261;0;260;0
WireConnection;261;1;262;0
WireConnection;271;0;272;0
WireConnection;397;0;261;0
WireConnection;397;2;398;0
WireConnection;312;0;310;0
WireConnection;270;0;261;0
WireConnection;270;2;274;0
WireConnection;270;1;271;0
WireConnection;276;0;235;0
WireConnection;221;35;244;0
WireConnection;221;37;223;0
WireConnection;305;0;276;0
WireConnection;305;1;312;0
WireConnection;268;1;255;0
WireConnection;268;0;256;0
WireConnection;74;0;221;38
WireConnection;400;0;258;0
WireConnection;400;1;397;0
WireConnection;259;0;258;0
WireConnection;259;1;270;0
WireConnection;227;0;74;0
WireConnection;227;1;233;0
WireConnection;227;2;305;0
WireConnection;219;99;18;0
WireConnection;219;97;33;0
WireConnection;401;0;259;0
WireConnection;401;1;400;0
WireConnection;291;99;290;0
WireConnection;291;97;33;0
WireConnection;269;0;268;0
WireConnection;24;0;291;84
WireConnection;24;1;219;85
WireConnection;24;2;291;82
WireConnection;277;0;227;0
WireConnection;266;0;401;0
WireConnection;266;1;1;0
WireConnection;266;2;269;0
WireConnection;225;0;24;0
WireConnection;75;0;277;0
WireConnection;229;0;266;0
WireConnection;363;0;270;0
WireConnection;92;0;24;0
WireConnection;92;1;93;0
WireConnection;93;1;91;0
WireConnection;91;0;33;0
WireConnection;2;0;230;0
WireConnection;2;1;90;0
WireConnection;2;6;76;0
WireConnection;2;7;65;0
WireConnection;2;11;226;0
ASEEND*/
//CHKSM=82D7976C32E88A4EDDD54E8AA235DB9E3487C409