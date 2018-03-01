
//  CMHttpURLManager.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-6.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMHttpURLManager.h"
#import "TouchXML.h"

@implementation CMHttpURLManager

static CMHttpURLManager *instance = nil;

+(CMHttpURLManager *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[CMHttpURLManager alloc] init];
    });
    return instance;
}

+(void)initConfigureWithHostPath:(NSString *)hPath suffixPath:(NSString *)spath{
    CMHttpURLManager *aInstance = [CMHttpURLManager shareInstance];
    [aInstance initConfigureWithHostPath:hPath suffixPath:spath];
}

-(void)initConfigureWithHostPath:(NSString *)hPath suffixPath:(NSString *)sPath{
    [self initHostConfigureWithPath:hPath];
    [self initUrlSuffixWithPath:sPath];
    [self assembleUrlAndSuffix];
}

-(CXMLDocument *)prepareParseXML:(NSString *)aPath{
    if(aPath.length == 0){
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:aPath];
    
    NSError *aError;
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&aError];
    if(aError){
        return nil;
    }
    
    if(document.children.count == 0){
        return nil;
    }

    return document;
}

-(void)initHostConfigureWithPath:(NSString *)aPath{
    CXMLDocument *document = [self prepareParseXML:aPath];
    if(!document){
        return;
    }

    if(!_hostMap){
        _hostMap = [NSMutableDictionary dictionary];
    }

    CXMLNode *rootNode = [document childAtIndex:0];
    
    NSArray *subNodes = [rootNode children];
    for(CXMLNode *node in subNodes){
        if(node.kind != XML_ELEMENT_NODE){
            continue;
        }
        NSString *nodeName = [node name];
        NSString *nodeValue = [node stringValue];
        [_hostMap setValue:nodeValue forKey:nodeName];
    }
}

-(void)initUrlSuffixWithPath:(NSString *)aPath{
    CXMLDocument *document = [self prepareParseXML:aPath];
    if(!document){
        return;
    }

    if(!_serviceUrlMap){
        _serviceUrlMap = [NSMutableDictionary dictionary];
    }
    CXMLNode *rootNode = [document childAtIndex:0];
    
    NSArray *subNodes = [rootNode children];
    for(CXMLNode *node in subNodes){
        if(node.kind != XML_ELEMENT_NODE){
            continue;
        }
        NSString *nodeName = [node name];
        NSString *nodeValue = [node stringValue];
        [_serviceUrlMap setValue:nodeValue forKey:nodeName];
    }
}

-(void)assembleUrlAndSuffix{
    NSArray *servIDs = [_serviceUrlMap allKeys];
    for(NSString *servID in servIDs){
        NSString *servUrlString = [_serviceUrlMap valueForKey:servID];
        if(servUrlString.length == 0){
            continue;
        }
        
        NSRange startRange = [servUrlString rangeOfString:@"{"];
        NSRange endRange = [servUrlString rangeOfString:@"}"];
        
        if(startRange.location == NSNotFound || endRange.location == NSNotFound){
            continue;
        }
        
        NSRange replaceRange = NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1);
        NSString *replaceString = [servUrlString substringWithRange:replaceRange];
        NSString *suffixString = [servUrlString substringFromIndex:(endRange.location + 1)];
        NSString *hostString = [_hostMap valueForKey:replaceString];
        if(hostString.length == 0){
            continue;
        }
        
        NSString *finalServUrlString = [NSString stringWithFormat:@"%@%@", hostString, suffixString];
        [_serviceUrlMap setValue:finalServUrlString forKey:servID];
    }
}

+(NSString *)urlStringWithServID:(NSString *)servID{
    CMHttpURLManager *aInstance = [CMHttpURLManager shareInstance];
    return [aInstance urlStringWithServID:servID];
}

-(NSString *)urlStringWithServID:(NSString *)servID{
    if(servID.length == 0){
        return nil;
    }
    NSString *urlString = [_serviceUrlMap valueForKey:servID];
    return urlString;
}

+(NSString *)getHostIPWithServID:(NSString *)servID{
    CMHttpURLManager *aInstance = [CMHttpURLManager shareInstance];
    return [aInstance getHostIPWithServID:servID];
}

-(NSString *)getHostIPWithServID:(NSString *)servID{
    if (servID.length == 0) {
        return nil;
    }
    NSString *hostIPString = [_hostMap valueForKey:servID];
    return hostIPString;
}

+(NSString *)getCurrentConfig{
    CMHttpURLManager *aInstance = [CMHttpURLManager shareInstance];
    return [aInstance getHostIPWithServID:@"getConfigParam"];
}
@end
