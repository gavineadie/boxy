#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {

    @autoreleasepool {

        NSError *           errorReport;
        NSFileManager *     defaultFileManager = [NSFileManager defaultManager];

        if (argc > 1) {
            NSString *      filePath = @(argv[1]);
            if ([defaultFileManager fileExistsAtPath:filePath]) {

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ read the file ...                                                                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

                NSStringEncoding    fileEncoding;
                NSString *  fileContents = [[NSString alloc] initWithContentsOfFile:filePath
                                                                       usedEncoding:&fileEncoding
                                                                              error:&errorReport];
                if (nil == fileContents) {
                    NSLog(@"readFromFile error: %@", errorReport);
                    return 1;
                }

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ break up the file into lines ...                                                                 │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/

                NSUInteger          length = [fileContents length];
                NSUInteger          lineAlpha = 0;
                NSUInteger          lineOmega = 0;
                NSUInteger          contentsEnd = 0;
                NSMutableArray *    lineArray = [NSMutableArray array];

                while (lineOmega < length) {
                    [fileContents getParagraphStart:&lineAlpha
                                                end:&lineOmega
                                        contentsEnd:&contentsEnd
                                           forRange:NSMakeRange(lineOmega, 0)];

                    NSRange currentRange = NSMakeRange(lineAlpha, contentsEnd - lineAlpha);

                    [lineArray addObject:[[fileContents substringWithRange:currentRange] mutableCopy]];
                }


/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ change the boxes into boxy directives ...                                                        │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/

                NSMutableString *   unfoldedString = [[NSMutableString alloc] init];
                BOOL                inLightBox = NO,
                inHeavyBox = NO,
                inSplitBox = NO,
                inDottyBox = NO,
                inBlobbyBox = NO;

                for (__strong NSMutableString * line in lineArray) {

                    if ([line rangeOfString:@"/*" "bar="].length > 0 ||
                        [line rangeOfString:@"/*" "════"].length > 0) {
                        [line setString:@"/*" "bar= ====================================="
                         "==========================================================*/"];
                    }
                    if ([line rangeOfString:@"/*" "bar-"].length > 0 ||
                        [line rangeOfString:@"/*" "━━━━"].length > 0) {
                        [line setString:@"/*" "bar- -------------------------------------"
                         "----------------------------------------------------------*/"];
                    }
                    if ([line rangeOfString:@"/*" "bar..."].length > 0 ||
                        [line rangeOfString:@"/*" "╌╌╌╌"].length > 0) {
                        [line setString:@"/*" "bar... ..................................."
                         "..........................................................*/"];
                    }
                    if ([line rangeOfString:@"/*" "bar "].length > 0 ||
                        [line rangeOfString:@"/*" "───"].length > 0) {
                        [line setString:@"/*─" "─────────────────────────────────────────"
                         "──────────────────────────────────────────────────────────*/"];
                    }


                    if (inSplitBox && [line rangeOfString:@"*/"].length > 0) {
                        [line setString:@"  +========================================="
                         "=========================================================+*/"];
                        inSplitBox = NO;
                    }
                    if (inLightBox && [line rangeOfString:@"*/"].length > 0) {
                        [line setString:@"  +- - - - - - - - - - - - - - - - - - - - -"
                         " - - - - - - - - - - - - - - - - - - - - - - - - - - - - +*/"];
                        inLightBox = NO;
                    }
                    if (inHeavyBox && [line rangeOfString:@"*/"].length > 0) {
                        [line setString:@"  +-----------------------------------------"
                         "---------------------------------------------------------+*/"];
                        inHeavyBox = NO;
                    }
                    if (inDottyBox && [line rangeOfString:@"*/"].length > 0) {
                        [line setString:@"  :........................................."
                         ".........................................................:*/"];
                        inDottyBox = NO;
                    }


                    if (inSplitBox) {
                        CFStringPad((CFMutableStringRef)line, CFSTR(" "), 102, 0);
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(0,3)
                                                              withString:@"  |"] mutableCopy];
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(101,1)
                                                              withString:@"|"] mutableCopy];
                    }
                    if (inLightBox) {
                        CFStringPad((CFMutableStringRef)line, CFSTR(" "), 102, 0);
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(0,3)
                                                              withString:@"  |"] mutableCopy];
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(101,1)
                                                              withString:@"|"] mutableCopy];
                    }
                    if (inHeavyBox) {
                        CFStringPad((CFMutableStringRef)line, CFSTR(" "), 102, 0);
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(0,3)
                                                              withString:@"  |"] mutableCopy];
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(101,1)
                                                              withString:@"|"] mutableCopy];
                    }
                    if (inDottyBox) {
                        CFStringPad((CFMutableStringRef)line, CFSTR(" "), 102, 0);
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(0,3)
                                                              withString:@"  :"] mutableCopy];
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(101,1)
                                                              withString:@":"] mutableCopy];
                    }
                    if (inBlobbyBox) {
                        CFStringPad((CFMutableStringRef)line, CFSTR(" "), 102, 0);
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(0,3)
                                                              withString:@"  |"] mutableCopy];
                        line = [[line stringByReplacingCharactersInRange:NSMakeRange(101,1)
                                                              withString:@"|"] mutableCopy];
                    }


                    if (!inSplitBox && ([line rangeOfString:@"/*" "box="].length > 0 ||
                                        [line rangeOfString:@"/*" "╔═══"].length > 0)) {
                        inSplitBox = YES;
                        [line setString:@"/*b" "ox= ====================================="
                         "=========================================================+"];
                    }
                    else if (!inHeavyBox && ([line rangeOfString:@"/*" "box-"].length > 0 ||
                                             [line rangeOfString:@"/*" "┏━━━"].length > 0)) {
                        inHeavyBox = YES;
                        [line setString:@"/*b" "ox- -------------------------------------"
                         "---------------------------------------------------------+"];
                    }
                    else if (!inDottyBox && ([line rangeOfString:@"/*" "box.."].length > 0 ||
                                             [line rangeOfString:@"/*" "╭╌╌╌"].length > 0)) {
                        inDottyBox = YES;
                        [line setString:@"/*b" "ox.. ...................................."
                         ".........................................................."];
                    }
                    else if (!inLightBox && ([line rangeOfString:@"/*" "box"].length > 0 ||
                                             [line rangeOfString:@"/*" "┌──"].length > 0)) {
                        inLightBox = YES;
                        [line setString:@"/*b" "ox - - - - - - - - - - - - - - - - - - - "
                         "- - - - - - - - - - - - - - - - - - - - - - - - - - - - -+"];
                    }

                    [unfoldedString appendFormat:@"%@\n", line];
                }

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ and write the modified file back out ...                                                         │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/

                if (![unfoldedString writeToFile:filePath
                                      atomically:YES
                                        encoding:fileEncoding
                                           error:&errorReport]) {
                    NSLog(@"writeToFile error: %@", errorReport);
                }

            }                                                                                             
            else {                                                                                        
                NSLog(@"File '%@' doesn't exist.", filePath);                                             
            }                                                                                             
        }                                                                                                 
        else {                                                                                            
            NSLog(@"No input file specified.");                                                           
        }                                                                                                 
    }

    return 0;
}
