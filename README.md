# course_ripper
A program that downloads all lectures and announcements from a given UQ course

## Usage

Type the below and follow the on screen prompts.
1. Run the ripper to download all the lectures
    
```bash
$ ./bin/course-ripper rip COURSE username password
```
        
        
2. Once all the lectures are downloaded, run the renamer to change the filenames into a logical format
    
    
```bash
$ ./bin/course-ripper rename COURSE
```    

3. Access the files at `~/Lectures/COURSE_CODE`

## License

The program is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

