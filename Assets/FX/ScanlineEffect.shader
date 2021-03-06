﻿Shader "CameraFX/ScanlineEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScreenHeight ("Screen Height", Range(0, 512)) = 256
		_Darkening ("Darkening", Range(0, 0.9)) = 0.1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _ScreenHeight;
			float _Darkening;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				if (floor(i.uv.y * _ScreenHeight) % 2 == 0) {
					col *= 1 - _Darkening;
				}
				return col;
			}
			ENDCG
		}
	}
}
