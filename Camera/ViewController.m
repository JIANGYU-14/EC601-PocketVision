//
//  ViewController.m
//  Camera
//
//  Created by Jianqing Gao on 11/9/16.
//  Copyright © 2016 Jianqing Gao. All rights reserved.
//

#import "ViewController.h"
#import "ClarifaiApp.h"

@interface ViewController (){
    
    __strong AVCaptureSession *session;
    AVCaptureStillImageOutput *StillImageOutput;
    
    BOOL isRecognizing;
    BOOL didGetImage;
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = framefoecapture.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    StillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [StillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:StillImageOutput];
    [session startRunning];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takephoto:(id)sender{
    
    if (isRecognizing) {
        return;
    }else{
        isRecognizing = YES;
        didGetImage = NO;
        resultLable.text = @"Recognizing...";
    }
    
    AVCaptureConnection *vedioConnection = nil;
    for ( AVCaptureConnection *connection in StillImageOutput.connections){
        for (AVCaptureInputPort *port in[connection inputPorts]){
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                vedioConnection = connection;
                break;
            }
    }
    }
   [StillImageOutput captureStillImageAsynchronouslyFromConnection:vedioConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
       if(imageDataSampleBuffer !=NULL){
           if (!didGetImage) {
               didGetImage = YES;
               NSData *imageData =[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
               UIImage *image = [UIImage imageWithData:imageData];
               [self recognizeImage:image];
           }
        }
   }];
}


- (void)recognizeImage:(UIImage *)image {
    
    // Initialize the Clarifai app with your app's ID and Secret.
    ClarifaiApp *app = [[ClarifaiApp alloc] initWithAppID:@"-jCwT9Y58ltJaA4HnXS5qh-bK-Om6XDnlUR0naV4"
                                                appSecret:@"i6TuUmKNAqQVK_ppTwpiVvZEe0a4Vc-OkfOIBLJ5"];
    
    // Fetch Clarifai's general model.
    [app getModelByName:@"general-v1.3" completion:^(ClarifaiModel *model, NSError *error) {
        // Create a Clarifai image from a uiimage.
        ClarifaiImage *clarifaiImage = [[ClarifaiImage alloc] initWithImage:image];
        
        // Use Clarifai's general model to pedict tags for the given image.
        [model predictOnImages:@[clarifaiImage] completion:^(NSArray<ClarifaiOutput *> *outputs, NSError *error) {
            if (!error) {
                ClarifaiOutput *output = outputs[0];
                
                // Loop through predicted concepts (tags), and display them on the screen.
                NSMutableArray *tags = [NSMutableArray array];
                for (ClarifaiConcept *concept in output.concepts) {
                    [tags addObject:concept.conceptName];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultLable.text = [NSString stringWithFormat:@"Tags:\n%@", [tags componentsJoinedByString:@", "]];
                });
            }
            isRecognizing = NO;
        }];
    }];
}

     
     @end
