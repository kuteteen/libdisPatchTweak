//
//  Marco.h
//  
//
//  Created by mutouren on 2017/6/28.
//
//

#ifndef Marco_h
#define Marco_h


#pragma mark - 设备屏幕尺寸
#define SCREEN_SIZE             [UIScreen mainScreen].bounds.size
#define SCREEN_SIZE_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_SIZE_HEIGHT      [UIScreen mainScreen].bounds.size.height


#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



//登录
//GET /member/login?OSVersion=9.3.3&deviceCode=F7C4B851-0419-4197-9D33-5D011CBF182D&dtu=100&lat=26.06230848460704&lon=119.2735688623071&network=WIFI&password=sys46417066&sign=c770537d2fcbcca26d6f6c053685719a&telephone=18059159871&time=1502248687&uuid=B4FBD181-582E-44D5-9B98-4C7D1E566C6C&version=20303 HTTP/1.1

//获取新闻列表数据
//GET /content/getList?OSVersion=9.3.3&cid=255&content_type=1%2C2%2C4%2C3&deviceCode=F7C4B851-0419-4197-9D33-5D011CBF182D&dtu=100&lat=26.06230848460704&lon=119.2735688623071&max_time=1502248284820&network=WIFI&op=2&page=3&sign=74135f03a4f18b67b55bb71a913c8fb7&time=1502248839&token=6f50j2Wq2hpMVqC1fCi6bDgjySfP0611m-HHgbpOcJTQYb9LJThRnxoJ2EIj-1C-ggC3EIDAKSIMHTK-&uuid=B4FBD181-582E-44D5-9B98-4C7D1E566C6C&version=20303 HTTP/1.1

#endif /* Marco_h */
