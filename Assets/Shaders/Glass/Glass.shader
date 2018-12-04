Shader "Glass/Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_ScaleUV ("UV Scale", Range(1,200)) = 1
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent-1"
		}

		GrabPass {}
		Pass // Window pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float2 uvbump : TEXCOORD2;
				float4 vertex : SV_POSITION;
				float4 diff : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _BumpMap;
			float4 _BumpMap_ST;

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;

			float _ScaleUV;

			v2f vert (appdata v)
			{
				v2f o;

				// Get vertex from world space to clip space
				o.vertex = UnityObjectToClipPos(v.vertex);

				// Based on screen scape get uvs for grab texture
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;

				// Get main texture UVs
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				// Get bump map UVs
				o.uvbump = TRANSFORM_TEX(v.uv, _BumpMap);

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				o.diff = nl * _LightColor0;

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg;
				float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				fixed4 tint = tex2D(_MainTex, i.uv);
				col *= tint;



				return col;
			}
			ENDCG
		}
	}
}
