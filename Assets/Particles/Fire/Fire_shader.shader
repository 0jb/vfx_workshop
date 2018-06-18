Shader "Unlit/Fire"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Distortion ("Distortion Map", 2D) = "white" {}
		_ScrollSpeedX ("Scroll Speed X", Float ) = 0.0
		_ScrollSpeedY ("Scroll Speed Y", Float ) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
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
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _Distortion;

			float _ScrollSpeedX;
			float _ScrollSpeedY;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = o.uv.xy +  float2(_ScrollSpeedX, _ScrollSpeedY) * _Time.y;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 distortion = tex2D(_Distortion, i.uv.zw);
				distortion *= i.uv.xy * 2;

				// sample the texture
				fixed4 col = tex2D(_MainTex, distortion);
				return col;
			}
			ENDCG
		}
	}
}
