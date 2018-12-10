Shader "Custom/Water" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SecondaryTex ("Secondary (RGB)", 2D) = "white" {}

		_ScrollX("Scroll X", Range(-5, 5)) = 0
		_ScrollY("Scroll Y", Range(-5, 5)) = 0

		_Freq("Frequency", Range(0,5)) = 3
		_Speed("Speed",Range(0,100)) = 10
		_SecondarySpeedMul("Secondary Speed Multiplier",Range(0,1)) = 1
		_Amp("Amplitude",Range(0,1)) = 0.5
	}
	SubShader 
		{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard vertex:vert

		sampler2D _MainTex;
		sampler2D _SecondaryTex;

		float _ScrollX;
		float _ScrollY;

		float _Freq;
		float _Speed;
		float _SecondarySpeedMul;
		float _Amp;

		struct appdata
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
		};

		struct Input 
		{
			float2 uv_MainTex;
			float3 vertColor;
		};

		void vert(inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);

			float t = _Time.y * _Speed;

			float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + 
				sin(t*2 + v.vertex.x + _Freq*2) * _Amp;
			v.vertex.y = v.vertex.y + waveHeight;

			v.normal = normalize(float3(
				-cos(t + v.vertex.x * _Freq) * _Amp * _Freq - cos(t * 2 + v.vertex.x * _Freq * 2) * _Amp * _Freq * 2,
				1,
				0));
			o.vertColor = waveHeight + 2;
		}

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			_ScrollX *= _Time.y * _Speed;
			_ScrollY *= _Time.y * _Speed;

			float3 main = (tex2D(_MainTex, IN.uv_MainTex + 
				float2(_ScrollX, _ScrollY))).rgb;
			float3 sec = (tex2D(_SecondaryTex, IN.uv_MainTex + float2(_ScrollX * _SecondarySpeedMul, _ScrollY * _SecondarySpeedMul))).rgb;

			o.Albedo = (((main + sec) * 0.5) * IN.vertColor) * 0.5;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

