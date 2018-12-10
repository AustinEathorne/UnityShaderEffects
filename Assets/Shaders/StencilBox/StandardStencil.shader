Shader "Custom/StandardStencil" 
{
	Properties
	{
		_Color("MainColor", Color) = (1,1,1,1)

		_MainTex("Albedo (RGB)", 2D) = "white" {}
		//_DetailTex("Detail", 2D) = "white" {}

		_Normal("Normal Map", 2D) = "bump" {}
		_NormalMul("Normal Multiplier", Range(0, 10)) = 1

		_Occlusion("Occlusion Map", 2D) = "white" {}

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		[Toggle] _IsEmissive("Use Emissive", Float) = 0
		_Emissive("Emissive", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)

		_SRef("Stencil Ref", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Op", Float) = 2
	}
	SubShader
	{
		Tags { "Queue" = "Geometry" }

		Stencil
		{
			Ref[_SRef]
			Comp[_SComp]
			Pass[_SOp]
		}

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		float4 _Color;
		float4 _EmissiveColor;

		sampler2D _MainTex;
		sampler2D _Detail;
		sampler2D _Normal;
		sampler2D _Emissive;
		sampler2D _Occlusion;

		float _IsEmissive;
		half _NormalMul;
		half _Glossiness;
		half _Metallic;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_Detail;
			float2 uv_Normal;
			float2 uv_Emissive;
			float2 uv_Occlusion;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * tex2D(_Occlusion, IN.uv_Occlusion);

			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			o.Normal *= float3(_NormalMul, _NormalMul, 1);

			o.Emission = _IsEmissive == 1 ?
				tex2D(_Emissive, IN.uv_Emissive) * _EmissiveColor : float3(0, 0, 0);

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			o.Alpha = c.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
