Shader "FXWorkshop/Waterfall_Shader"
{
	Properties
	{
		_ColorTex ("Color Texture", 2D) = "white" {}
		_MainTex ("Distortion Texture", 2D) = "white" {}
		_Intensity ("Distortion Intensity", Float) = 0.0
		_ScrollX ("Scroll Speed X", Float) = 0.0
		_ScrollY ("Scroll Speed Y", Float) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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
				float3 normal : NORMAL;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _ColorTex;

			float _ScrollX;
			float _ScrollY;
			float _Intensity;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv += float2(_ScrollX, _ScrollY) * _Time.y;
				float4 newVertexPos = v.vertex;
				newVertexPos.xyz += lerp(0.0f ,v.normal * tex2Dlod(_MainTex, float4(o.uv, 0, 0)) * _Intensity, v.color.r);
				o.vertex = UnityObjectToClipPos(newVertexPos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_ColorTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
