# PocketVision
Readme for Pocket Vision Object Tracking part:
1. The whole Object Tracking system is based on the Right-Alert system, which is from previous semester team. (Special thanks to Right-Alert team) 

2. In order to make the system running on Linux system, you need to install the c++ compiler and OpenCV 2.4.8. (other version will cause error)

3. In the ObjectTracking1.0 folder, in the terminal, first type "make". It will compile all necessary files to generate out program

4. Put the video you want to test in the ObjectTracking1.0/test folder

5. In the ObjectTracking1.0 folder, in the terminal, type "./out --detection --video test/bikeexp1.avi --debug"

6. Correct output should look similar to the following:
Flags:
	debug 1
	train 0
	performanceTest 0
	detection 1
	video test/bikeexp1.avi
	cameraId -1
	cameraTest 0
Starting Bike Detection...
Size of primal vector: 3781
HogDescriptor size: 3780
Opening test/bikeexp1.avi
Detected bikes index: 0, Detected bikes coordinate: x: 217, y: 54, position: upper left
Detected bikes index: 1, Detected bikes coordinate: x: 353, y: 82, position: upper right
Detected bikes index: 2, Detected bikes coordinate: x: 426, y: 95, position: upper right
Detected bikes index: 3, Detected bikes coordinate: x: 310, y: 234, position: around middle
Done with Bike Detection.
Quitting Program.

7. The program will generate detected image in the ObjectTracking1.0/latest detection folder

8. The program will generate individual detected object image in the ObjectTracking1.0/detection record folder

9. If you want to train the algorithm, you could use "./out --train" (Remember, it requires to have negetive and positive image examples, and you should put related image in the proper train folder, the image is required to be exact width 648 x height 486 size)
