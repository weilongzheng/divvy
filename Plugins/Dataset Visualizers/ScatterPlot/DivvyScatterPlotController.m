//
//  DivvyScatterPlotController.m
//
//  Written in 2011 by Joshua Lewis at the UC San Diego Natural Computation Lab,
//  PI Virginia de Sa, supported by NSF Award SES #0963071.
//  Copyright 2011, UC San Diego Natural Computation Lab. All rights reserved.
//  Licensed under the MIT License. http://www.opensource.org/licenses/mit-license.php
//
//  Find the Divvy project on the web at http://divvy.ucsd.edu


#import "DivvyScatterPlotController.h"

#import "DivvyAppDelegate.h"
#import "DivvyDatasetView.h"
#import "DivvyReducer.h"

#import "DivvyScatterPlot.h"

@implementation DivvyScatterPlotController

@synthesize xAxisSlider;
@synthesize yAxisSlider;

- (id)init
{
  if (!(self = [super init])) return nil;
 
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  [delegate addObserver:self forKeyPath:@"selectedDatasetView.selectedReducer.d" options:0 context:nil];
  
  return self;
}

// If we're moving from high d to lower d, adjust the scatter dimensions and sliders
// to compensate, even if  scatter plot is not the current visualizer.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  if(delegate.selectedDatasetView.selectedReducer) {
    int d = [delegate.selectedDatasetView.selectedReducer.d intValue] - 1; // The slider is zero based
    
    NSArray *sliders = [NSArray arrayWithObjects:xAxisSlider, yAxisSlider, nil];
    
    for(NSSlider *slider in sliders) {
      slider.maxValue = d;
      slider.numberOfTickMarks = d + 1;
    }
    for (id <DivvyDatasetVisualizer> datasetVisualizer in delegate.selectedDatasetView.datasetVisualizers) {
      if ([datasetVisualizer isKindOfClass:[DivvyScatterPlot class]]) {
        DivvyScatterPlot *scatterPlot = datasetVisualizer;
        if (scatterPlot.xAxis.intValue > d)
          scatterPlot.xAxis = [NSNumber numberWithInt:d];
        if (scatterPlot.yAxis.intValue > d)
          scatterPlot.yAxis = [NSNumber numberWithInt:d];
      }
    }
  }
}

- (void) dealloc {
  [xAxisSlider release];
  [yAxisSlider release];
  
  [super dealloc];
}

@end
