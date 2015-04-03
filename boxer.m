//
//  main.m
//  boxer
//
//  Created by Gavin Eadie on 11/27/12.
//
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        
        NSError *           errorReport;
        NSFileManager *     defaultFileManager = [NSFileManager defaultManager];

        if (argc > 1) {
            NSString *      filePath = @(argv[1]);
            if ([defaultFileManager fileExistsAtPath:filePath]) {

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ read the file ...                                                                                │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/

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
                BOOL                inHeavyBox = NO;
                NSRange             alphaRange, omegaRange, totalRange;
                NSString *          replacement;

                for (__strong NSString * line in lineArray) {
                    alphaRange = [line rangeOfString:@"+-"];
                    omegaRange = [line rangeOfString:@"-+"];
                    if (alphaRange.length > 0 && omegaRange.length > 0 &&
                        alphaRange.location < omegaRange.location) {
/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ... found a line with "+-...-+" in it ..                                                         │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
                        if (inHeavyBox) {
                            if (NSEqualRanges(totalRange, NSUnionRange(alphaRange, omegaRange))) {
/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │     ... if we are IN the box, and this is the same range close the box and reset                 │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
                                replacement = [[@"┗" stringByPaddingToLength:totalRange.length-1
                                                                  withString:@"━"
                                                             startingAtIndex:0]
                                               stringByAppendingString:@"┛"];
                                inHeavyBox = NO;
                            }
                        }
                        else {
/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │     ... if we are NOT IN the box, note the box-top range and draw the box-top                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
                            totalRange = NSUnionRange(alphaRange, omegaRange);
                            replacement = [[@"┏" stringByPaddingToLength:totalRange.length-1
                                                              withString:@"━"
                                                         startingAtIndex:0]
                                           stringByAppendingString:@"┓"];
                            inHeavyBox = YES;
                        }

                        line = [line stringByReplacingCharactersInRange:totalRange
                                                             withString:replacement];
                    }
                    else if (inHeavyBox) {
                        line = [line stringByReplacingOccurrencesOfString:@"|" withString:@"┃"];
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

