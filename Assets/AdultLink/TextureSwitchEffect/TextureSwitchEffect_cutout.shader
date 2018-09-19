// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/TextureSwitchEffect_cutout"
{
	Properties
	{
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		[Toggle]_Invert("Invert", Float) = 0
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Albedo_tint("Albedo_tint", Color) = (1,1,1,1)
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Emission("Emission", 2D) = "black" {}
		[HDR]_Emission_tint("Emission_tint", Color) = (1,1,1,1)
		_Position("_Position", Vector) = (0,2.5,0,0)
		_Falloffvalue("Falloff value", Float) = 0.5
		_Radius("Radius", Float) = 2
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		_Borderradius("Border radius", Range( 0 , 2)) = 1
		_Bordernoisescale("Border noise scale", Range( 0 , 20)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _Invert;
		uniform float3 _Position;
		uniform float _Radius;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Falloffvalue;
		uniform float _Borderradius;
		uniform float4 _Albedo_tint;
		uniform sampler2D _Albedo;
		uniform float4 _Emission_tint;
		uniform sampler2D _Emission;
		uniform float4 _Bordercolor;
		uniform float _Cutoff = 0.5;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord90 = i.uv_texcoord * _Tiling + _Offset;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( ase_worldPos + ( _Noisespeed * _Time.y ) ) ) );
			float temp_output_39_0 = ( _Radius + simplePerlin3D26 );
			float temp_output_5_0 = step( ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) ) , _Falloffvalue );
			float temp_output_32_0 = saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) );
			float Mask51 = lerp(temp_output_5_0,step( temp_output_32_0 , _Falloffvalue ),_Invert);
			o.Normal = ( UnpackNormal( tex2D( _Normal, uv_TexCoord90 ) ) * Mask51 );
			o.Albedo = ( _Albedo_tint * tex2D( _Albedo, uv_TexCoord90 ) * Mask51 ).rgb;
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - temp_output_32_0 ) , _Falloffvalue ) );
			o.Emission = ( ( _Emission_tint * tex2D( _Emission, uv_TexCoord90 ) * Mask51 ) + ( _Bordercolor * Border49 ) ).rgb;
			o.Alpha = 1;
			float temp_output_78_0 = Mask51;
			clip( temp_output_78_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
507;92;1051;527;2424.567;720.3455;2.583395;True;False
Node;AmplifyShaderEditor.Vector3Node;41;-3653.63,417.5185;Float;False;Property;_Noisespeed;Noise speed;12;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-3646.38,576.8399;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3448.065,445.0377;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-3390.595,271.0204;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-3137.122,348.1595;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3343.809,172.558;Float;False;Property;_Bordernoisescale;Border noise scale;14;0;Create;True;0;0;False;0;0;0.8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2990.799,325.5184;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-2747.048,320.3435;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2716.548,188.8748;Float;False;Property;_Radius;Radius;11;0;Create;True;0;0;False;0;2;5.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-2909.467,-85.13766;Float;False;Property;_Position;_Position;9;0;Create;True;0;0;False;0;0,2.5,0;0,2.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2504.906,241.4155;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2953.542,-187.4458;Float;False;Property;_Borderradius;Border radius;13;0;Create;True;0;0;False;0;1;0.27;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-2644.135,12.34053;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-2309.833,-9.653191;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-2226.255,220.7553;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-2176.507,-202.3565;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-2010.554,-199.7883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-2042.668,224.494;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-1851.287,222.6835;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-1784.28,-198.2636;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1736.897,29.58072;Float;False;Property;_Falloffvalue;Falloff value;10;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;92;247.036,310.3633;Float;False;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;5;-1410.933,240.67;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-1409.549,-220.8889;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;-1411.729,12.55791;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;248.3361,173.864;Float;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-1056.864,-113.5174;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;442.0364,205.0634;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;107;-1065.864,114.0964;Float;False;Property;_Invert;Invert;2;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-876.4263,114.2735;Float;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;857.3165,471.6254;Float;False;Property;_Bordercolor;Border color;15;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;2.323001,0.3844966,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;839.2489,-28.19606;Float;False;Property;_Emission_tint;Emission_tint;7;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;821.8247,152.777;Float;True;Property;_Emission;Emission;6;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-880.8252,-118.0172;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;876.0349,653.056;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;891.1077,354.3461;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;907.6737,-479.6245;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;924.3142,-132.6616;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1180.158,159.1718;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;802.6385,-681.5815;Float;True;Property;_Albedo;Albedo;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;312c93ed564bd8840ab4818e3db14d8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;819.2783,-334.6191;Float;True;Property;_Normal;Normal;5;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;c208f128e624c474bb2241affee1c866;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1125.598,554.1989;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;108;838.2137,-866.6116;Float;False;Property;_Albedo_tint;Albedo_tint;4;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;955.0667,1021.558;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1184.688,954.9017;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1153.934,-199.3167;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1415.181,336.2189;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;1190.006,-645.2694;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;850.0312,819.5994;Float;True;Property;_Metallic;Metallic;8;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1595.024,289.5317;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/TextureSwitchEffect_cutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;16;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;41;0
WireConnection;89;1;42;0
WireConnection;40;0;27;0
WireConnection;40;1;89;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;39;0;13;0
WireConnection;39;1;26;0
WireConnection;15;0;10;0
WireConnection;15;1;27;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;32;0;31;0
WireConnection;11;0;12;0
WireConnection;14;0;11;0
WireConnection;33;0;32;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;103;0;32;0
WireConnection;103;1;3;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;90;0;91;0
WireConnection;90;1;92;0
WireConnection;107;0;5;0
WireConnection;107;1;103;0
WireConnection;51;0;107;0
WireConnection;80;1;90;0
WireConnection;49;0;24;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;83;2;78;0
WireConnection;1;1;90;0
WireConnection;61;1;90;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;66;0;62;0
WireConnection;66;1;65;0
WireConnection;56;0;61;0
WireConnection;56;1;59;0
WireConnection;84;0;83;0
WireConnection;84;1;35;0
WireConnection;8;0;108;0
WireConnection;8;1;1;0
WireConnection;8;2;53;0
WireConnection;62;1;90;0
WireConnection;0;0;8;0
WireConnection;0;1;56;0
WireConnection;0;2;84;0
WireConnection;0;10;78;0
ASEEND*/
//CHKSM=5FCBFABA9BE65C99E6CBCE0383D13F8C8597D8B4