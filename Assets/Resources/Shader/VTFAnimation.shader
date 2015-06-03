Shader "Custom/VTFAnimation"
{
	Properties
	{
		_MainTex ("Main (RGB)", 2D) = "White" {}
		_DeformTex ("Deform (RGB)", 2D) = "White" {}
	}
	
	CGINCLUDE
	ENDCG

    SubShader
    {   
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"
            #pragma enable_d3d11_debug_symbols
            
            sampler2D	_MainTex;
            Texture2D	_DeformTex;
            float4		_MainTex_ST;
            int			_DeformTexStride;
            int			_VertexCount;
            int 		_AnimationFrame;
            RWStructuredBuffer<float> _Debug;
            
			struct VSIn
			{
				float4	vertex		: POSITION;
			    uint	vertexId	: SV_VertexID;
			    uint	instanceID	: SV_InstanceID;
				float4	tangent		: TANGENT;
				float3	normal		: NORMAL;
				float4	texcoord	: TEXCOORD0;
				float4	texcoord1	: TEXCOORD1;
				float4	texcoord2	: TEXCOORD2;
				float4 	texcoord3	: TEXCOORD3;
				#if defined(SHADER_API_XBOX360)
				half4	texcoord4	: TEXCOORD4;
				half4	texcoord5	: TEXCOORD5;
				#endif
				fixed4	color		: COLOR;			    
			};       
	        

            struct v2f
            {
                float4	pos		: SV_Position;
                float2	uv		: TEXCOORD0;
                float4	color	: COLOR;
            };
            
            v2f vert(VSIn i) 
            {
                v2f o;
                
                int _texId = i.vertexId + _AnimationFrame * _VertexCount;

				o.pos = mul(UNITY_MATRIX_MVP, float4(i.vertex.xyz, 1));
				o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);
				
				uint _uvY = floor((float)_texId / (float)_DeformTexStride);
				uint _uvX = _texId % _DeformTexStride;
				
				float4 _deformColor = _DeformTex[ uint2(_uvX, _DeformTexStride - _uvY - 1) ];

				float3 _unPack = _deformColor.xyz * 2.0f - 1.0f;
				float _exp = exp(_deformColor.w * 255.0f) - 1.0f;
				float3 _deformPos = _unPack * _exp * 0.01f;
				
				o.pos = mul(UNITY_MATRIX_MVP, float4(_deformPos.xyz, 1));
				o.color = float4(_deformColor.xyz, 1);
				
				return o;
            }

            float4 frag(v2f i) : SV_Target
            {   
                return float4(i.color);
            }

            ENDCG
        }

    }
}