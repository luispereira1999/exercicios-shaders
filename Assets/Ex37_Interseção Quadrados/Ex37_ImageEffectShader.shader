Shader "Custom/Ex37_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _Square1Color ("Square 1 Color", Color) = (1, 0, 0, 1)
        _Square2Color ("Square 2 Color", Color) = (0, 1, 0, 1)
     
        _Square1Center ("Square 1 Center", Vector) = (0.3, 0.3, 0, 0)
        _Square2Center ("Square 2 Center", Vector) = (0.7, 0.7, 0, 0)
        _Square1Size ("Square 1 Size", Float) = 0.2
        _Square2Size ("Square 2 Size", Float) = 0.2

        [Toggle] _IsInvertBackground ("Is Invert Background", Int) = 0

        _Rotation ("Rotation", Range(0, 360)) = 0
    }
    SubShader
    {
        // nunca renderiza para a profundidade da tela
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            } 

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Square1Color;
            float4 _Square2Color;

            float4 _Square1Center;
            float4 _Square2Center;
            float _Square1Size;
            float _Square2Size;

            float _IsInvertBackground;

            float _Rotation;

            int isInsideRectangle(float2 center, float2 size, float2 pixel) {
                float halfWidth = size.x / 2.0;
                float halfHeight = size.y / 2.0;
    
                if (pixel.x > center.x - halfWidth && pixel.x < center.x + halfWidth &&
                    pixel.y > center.y - halfHeight && pixel.y < center.y + halfHeight) {
                    return 1;
                } else {
                    return 0;
                }
            }

            float2 rotate(float2 origin, float angle) {
                float2x2 rotation = { cos(angle), sin(angle),
                                    -sin(angle), cos(angle) };

                return mul(rotation, origin);
            }

            float2 rotatePoint(float2 pixel, float2 center, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);

                // translate point back to origin
                pixel -= center;

                // rotate point
                float xnew = pixel.x * c - pixel.y * s;
                float ynew = pixel.x * s + pixel.y * c;

                // translate point back
                pixel.x = xnew + center.x;
                pixel.y = ynew + center.y;

                return pixel;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainColor = tex2D(_MainTex, i.uv);

                float2 uvSquare1 = rotatePoint(i.uv, _Square1Center, radians(_Rotation));
                float2 uvSquare2 = rotatePoint(i.uv, _Square2Center, radians(_Rotation));

                // bool inSquare1 = i.uv.x > 0.2 && i.uv.x < 0.4 && i.uv.y > 0.2 && i.uv.y < 0.4;
                // bool inSquare2 = i.uv.x > 0.3 && i.uv.x < 0.6 && i.uv.y > 0.3 && i.uv.y < 0.6;

                float half1Size = _Square1Size / 2.0;
                float half2Size = _Square2Size / 2.0;

                bool inSquare1 = (uvSquare1.x > _Square1Center.x - half1Size && uvSquare1.x < _Square1Center.x + half1Size &&
                                  uvSquare1.y > _Square1Center.y - half1Size && uvSquare1.y < _Square1Center.y + half1Size);
                
                bool inSquare2 = (uvSquare2.x > _Square2Center.x - half2Size && uvSquare2.x < _Square2Center.x + half2Size &&
                                  uvSquare2.y > _Square2Center.y - half2Size && uvSquare2.y < _Square2Center.y + half2Size);
                
                // interseção dos quadrados
                if (inSquare1 && inSquare2)
                {
                    if (_IsInvertBackground) {
                        return 1 - (_Square1Color + _Square2Color);
                    } else {
                        return _Square1Color + _Square2Color;
                    }
                }
                // define o quadrados 1
                else if (inSquare1)
                {
                    if (_IsInvertBackground) {
                        return 1 - _Square1Color;
                    } else {
                        return _Square1Color;
                    }
                }
                // define o quadrados 2
                else if (inSquare2)
                {
                    if (_IsInvertBackground) {
                        return 1 - _Square2Color;
                    } else {
                        return _Square2Color;
                    }
                }

                // float2 newUv1 = rotatePoint(i.uv, _Square1Center, radians(_Rotation));
                // if (isInsideRectangle(_Square1Center, _Square1Size, newUv1)) {
                //     return 1 - _Square1Color;
                // }
                // if (isInsideRectangle(_Square2Center, _Square2Size, i.uv)) {
                //     float2 newUv = rotate(i.uv, _Rotation);
                //     _Square2Color = tex2D(_MainTex, newUv);
                //     return 1 - _Square2Color;
                // }

                return mainColor;
            }

            ENDCG
        }
    }
}