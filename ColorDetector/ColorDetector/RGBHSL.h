//
//  RGBHSL.h
//  ColorDetector
//
//  Created by Wang Yu on 1/2/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

#ifndef RGBHSL_h
#define RGBHSL_h

static void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL)
{
    r /= 255.0f;
    g /= 255.0f;
    b /= 255.0f;
    
    float min = MIN(r, MIN(g, b));
    float max = MAX(r, MAX(g, b));
    float delta = max - min;
    
    float l = (min + max) / 2;
    
    float s = 0;
    if (l > 0 && l < 1)
        s = delta / (l < 0.5 ? (2 * l) : (2 - 2 * l));

    float h = 0;
    if (delta > 0) {
        if (max == r && max != g) h += (g - b) / delta;
        if (max == g && max != b) h += (2 + (b - r) / delta);
        if (max == b && max != r) h += (4 + (r - g) / delta);
        h /= 6;
    }
    if(outH)
        *outH = h * 255;
    if(outS)
        *outS = s * 255;
    if(outL)
        *outL = l * 255;
}


#endif /* RGBHSL_h */
