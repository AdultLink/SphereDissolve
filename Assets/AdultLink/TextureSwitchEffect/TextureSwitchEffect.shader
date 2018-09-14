// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/TextureSwitchEffect"
{
	Properties
	{
		_Set1_albedo("Set1_albedo", 2D) = "white" {}
		_Set1_metallic("Set1_metallic", 2D) = "white" {}
		_Set1_smoothness("Set1_smoothness", 2D) = "white" {}
		_Set1_normal("Set1_normal", 2D) = "white" {}
		_Set1_emission("Set1_emission", 2D) = "black" {}
		_Set2_albedo("Set2_albedo", 2D) = "white" {}
		_Set2_normal("Set2_normal", 2D) = "white" {}
		_Set2_emission("Set2_emission", 2D) = "black" {}
		_Set2_smoothness("Set2_smoothness", 2D) = "white" {}
		_Set2_metallic("Set2_metallic", 2D) = "white" {}
		_Falloffvalue("Falloff value", Float) = 0.08
		_Radius("Radius", Float) = 2.16
		_Bordernoisescale("Border noise scale", Float) = 0
		_Borderradius("Border radius", Range( 0 , 2)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		_Smoothness1("Smoothness1", Range( 0 , 1)) = 0
		_Smoothness2("Smoothness2", Range( 0 , 1)) = 0
		[HDR]_Set1_emissionColor("Set1_emissionColor", Color) = (1,1,1,1)
		[HDR]_Set2_emissionColor("Set2_emissionColor", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		uniform sampler2D _Set1_normal;
		uniform float4 _Set1_normal_ST;
		uniform float3 _Position;
		uniform float _Radius;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Falloffvalue;
		uniform sampler2D _Set2_normal;
		uniform float4 _Set2_normal_ST;
		uniform sampler2D _Set1_albedo;
		uniform float4 _Set1_albedo_ST;
		uniform sampler2D _Set2_albedo;
		uniform float4 _Set2_albedo_ST;
		uniform float4 _Set1_emissionColor;
		uniform sampler2D _Set1_emission;
		uniform float4 _Set1_emission_ST;
		uniform sampler2D _Set2_emission;
		uniform float4 _Set2_emission_ST;
		uniform float4 _Set2_emissionColor;
		uniform float4 _Bordercolor;
		uniform float _Borderradius;
		uniform sampler2D _Set1_metallic;
		uniform float4 _Set1_metallic_ST;
		uniform sampler2D _Set2_metallic;
		uniform float4 _Set2_metallic_ST;
		uniform float _Smoothness1;
		uniform sampler2D _Set1_smoothness;
		uniform float4 _Set1_smoothness_ST;
		uniform sampler2D _Set2_smoothness;
		uniform float4 _Set2_smoothness_ST;
		uniform float _Smoothness2;


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
			float2 uv_Set1_normal = i.uv_texcoord * _Set1_normal_ST.xy + _Set1_normal_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float mulTime42 = _Time.y * _Noisespeed.x;
			float mulTime47 = _Time.y * _Noisespeed.y;
			float mulTime46 = _Time.y * _Noisespeed.z;
			float4 appendResult48 = (float4(mulTime42 , mulTime47 , mulTime46 , 0.0));
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( float4( ase_worldPos , 0.0 ) + appendResult48 ) ).xyz );
			float temp_output_39_0 = ( _Radius + simplePerlin3D26 );
			float temp_output_14_0 = ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) );
			float temp_output_5_0 = step( temp_output_14_0 , _Falloffvalue );
			float Set1Mask51 = temp_output_5_0;
			float Set2Mask52 = step( _Falloffvalue , temp_output_14_0 );
			float2 uv_Set2_normal = i.uv_texcoord * _Set2_normal_ST.xy + _Set2_normal_ST.zw;
			o.Normal = ( ( tex2D( _Set1_normal, uv_Set1_normal ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_normal, uv_Set2_normal ) ) ).rgb;
			float2 uv_Set1_albedo = i.uv_texcoord * _Set1_albedo_ST.xy + _Set1_albedo_ST.zw;
			float2 uv_Set2_albedo = i.uv_texcoord * _Set2_albedo_ST.xy + _Set2_albedo_ST.zw;
			o.Albedo = ( ( tex2D( _Set1_albedo, uv_Set1_albedo ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_albedo, uv_Set2_albedo ) ) ).rgb;
			float2 uv_Set1_emission = i.uv_texcoord * _Set1_emission_ST.xy + _Set1_emission_ST.zw;
			float2 uv_Set2_emission = i.uv_texcoord * _Set2_emission_ST.xy + _Set2_emission_ST.zw;
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) ) ) , _Falloffvalue ) );
			o.Emission = ( ( _Set1_emissionColor * tex2D( _Set1_emission, uv_Set1_emission ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_emission, uv_Set2_emission ) * _Set2_emissionColor ) + ( _Bordercolor * Border49 ) ).rgb;
			float2 uv_Set1_metallic = i.uv_texcoord * _Set1_metallic_ST.xy + _Set1_metallic_ST.zw;
			float2 uv_Set2_metallic = i.uv_texcoord * _Set2_metallic_ST.xy + _Set2_metallic_ST.zw;
			o.Metallic = ( ( tex2D( _Set1_metallic, uv_Set1_metallic ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_metallic, uv_Set2_metallic ) ) ).r;
			float2 uv_Set1_smoothness = i.uv_texcoord * _Set1_smoothness_ST.xy + _Set1_smoothness_ST.zw;
			float2 uv_Set2_smoothness = i.uv_texcoord * _Set2_smoothness_ST.xy + _Set2_smoothness_ST.zw;
			o.Smoothness = ( ( _Smoothness1 * tex2D( _Set1_smoothness, uv_Set1_smoothness ) * Set1Mask51 ) + ( Set2Mask52 * tex2D( _Set2_smoothness, uv_Set2_smoothness ) * _Smoothness2 ) ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
563;312;1350;692;914.3948;515.6409;2.700808;True;False
Node;AmplifyShaderEditor.Vector3Node;41;-2519.804,1298.618;Float;False;Property;_Noisespeed;Noise speed;15;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-2314.983,1278.943;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-2315.408,1419.117;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-2314.257,1350.093;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-2101.635,1329.278;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-2106.478,1163.94;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1973.161,1062.387;Float;False;Property;_Bordernoisescale;Border noise scale;12;0;Create;True;0;0;False;0;0;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-1853.009,1241.079;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1706.687,1218.438;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-1517.017,1085.005;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1483.345,939.2599;Float;False;Property;_Radius;Radius;11;0;Create;True;0;0;False;0;2.16;8.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-1627.186,560.9174;Float;False;Global;_Position;_Position;4;0;Create;True;0;0;False;0;0,2.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-1676.457,756.3458;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;19;-1127.84,790.836;Float;False;Property;_Borderradius;Border radius;13;0;Create;True;0;0;False;0;0;0.28;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1274.876,998.1458;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-1414.105,777.0017;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-834.7081,802.727;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-1069.075,556.6634;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-967.2233,989.4166;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-806.3911,978.1039;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-908.2432,545.3507;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-707.9551,546.5916;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-606.104,979.3448;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-637.4748,682.2545;Float;False;Property;_Falloffvalue;Falloff value;10;0;Create;True;0;0;False;0;0.08;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-210.853,488.0095;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;5;-210.6798,724.0934;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;48.76942,464.7562;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;-202.6526,958.8853;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;687.1785,2372.659;Float;True;Property;_Set2_smoothness;Set2_smoothness;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;666.421,2125.741;Float;True;Property;_Set1_smoothness;Set1_smoothness;2;0;Create;True;0;0;False;0;None;e5d9b43e84ff9e64da552afa5244d441;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;679.1309,2032.837;Float;False;Property;_Smoothness1;Smoothness1;16;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;914.4825,1370.277;Float;True;Property;_Set1_metallic;Set1_metallic;1;0;Create;True;0;0;False;0;None;e5d9b43e84ff9e64da552afa5244d441;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;1019.518,1572.234;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;1011.611,1667.376;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;919.2047,1748.927;Float;True;Property;_Set2_metallic;Set2_metallic;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;1027.891,2213.966;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;868.4716,640.1307;Float;False;Property;_Set2_emissionColor;Set2_emissionColor;19;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;849.5775,4.511616;Float;False;Property;_Set1_emissionColor;Set1_emissionColor;18;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;1028.984,2309.108;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;1196.056,359.9723;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;1194.084,264.8302;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;703.9797,2585.995;Float;False;Property;_Smoothness2;Smoothness2;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;1030.826,-958.4321;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;1038.733,-1053.574;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;938.4197,-876.8811;Float;True;Property;_Set2_albedo;Set2_albedo;5;0;Create;True;0;0;False;0;None;019d98742919c3248be0a995d4730f22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;933.6979,-1255.531;Float;True;Property;_Set1_albedo;Set1_albedo;0;0;Create;True;0;0;False;0;None;e5d9b43e84ff9e64da552afa5244d441;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;5.276077,956.5837;Float;False;Set2Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;191.6766,459.6407;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;22.20654,741.6946;Float;False;Set1Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;839.6127,949.6295;Float;False;Property;_Bordercolor;Border color;14;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;0,0.881138,2.323,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;58;1038.428,-353.8697;Float;False;52;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;941.2991,-650.9692;Float;True;Property;_Set1_normal;Set1_normal;3;0;Create;True;0;0;False;0;None;e5d9b43e84ff9e64da552afa5244d441;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;57;946.0211,-272.3187;Float;True;Property;_Set2_normal;Set2_normal;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;858.331,1131.06;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;1046.335,-449.0117;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;832.1533,185.4846;Float;True;Property;_Set1_emission;Set1_emission;4;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;840.6989,431.5989;Float;True;Property;_Set2_emission;Set2_emission;7;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1280.522,-289.9138;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1405.668,167.779;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;1272.921,-894.4762;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;1253.706,1731.333;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1107.894,1032.203;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1260.079,2355.064;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;1268.354,-1120.229;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1251.903,2109.461;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;1413.384,414.0038;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1275.955,-515.6668;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1249.139,1505.579;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;1434.969,1604.524;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1704.648,391.9015;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;1441.342,2228.255;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1461.784,-416.7224;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;1470.218,-1080.079;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2236.143,464.4567;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/TextureSwitchEffect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;41;1
WireConnection;46;0;41;3
WireConnection;47;0;41;2
WireConnection;48;0;42;0
WireConnection;48;1;47;0
WireConnection;48;2;46;0
WireConnection;40;0;27;0
WireConnection;40;1;48;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;39;0;13;0
WireConnection;39;1;26;0
WireConnection;15;0;10;0
WireConnection;15;1;16;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;11;0;12;0
WireConnection;32;0;31;0
WireConnection;33;0;32;0
WireConnection;14;0;11;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;4;0;3;0
WireConnection;4;1;14;0
WireConnection;52;0;4;0
WireConnection;49;0;24;0
WireConnection;51;0;5;0
WireConnection;60;0;58;0
WireConnection;60;1;57;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;83;2;78;0
WireConnection;7;0;54;0
WireConnection;7;1;2;0
WireConnection;67;0;64;0
WireConnection;67;1;63;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;76;0;73;0
WireConnection;76;1;72;0
WireConnection;76;2;70;0
WireConnection;8;0;1;0
WireConnection;8;1;53;0
WireConnection;75;0;69;0
WireConnection;75;1;71;0
WireConnection;75;2;74;0
WireConnection;82;0;79;0
WireConnection;82;1;81;0
WireConnection;82;2;88;0
WireConnection;56;0;61;0
WireConnection;56;1;59;0
WireConnection;66;0;62;0
WireConnection;66;1;65;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;84;2;35;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;55;0;56;0
WireConnection;55;1;60;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;0;0;9;0
WireConnection;0;1;55;0
WireConnection;0;2;84;0
WireConnection;0;3;68;0
WireConnection;0;4;77;0
ASEEND*/
//CHKSM=7DDDE4E1C5508A9D36F84DC712E0AF7CFCFDBA84