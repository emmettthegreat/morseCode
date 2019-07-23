import QtQuick 2.0
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.morseCode"
      description: "Transfer Text to Morse Code"
      version: "1.0"
      requiresScore: false

//Returns a binary string equivalent of the morse code translation of a character
function charToBin(x) {
	switch(x) {
		case 'a': return "1100"; break;
		case 'b': return "101110"; break;
		case 'c': return "1011010"; break;
		case 'd': return "10110"; break;
		case 'e': return "10"; break;
		case 'f': return "111010"; break;
		case 'g': return "101010"; break;
		case 'h': return "11110"; break;
		case 'i': return "110"; break;
		case 'j': return "11010100"; break;
		case 'k': return "101100"; break;
		case 'l': return "110110"; break;
		case 'm': return "10100"; break;
		case 'n': return "1010"; break;
		case 'o': return "1010100"; break;
		case 'p': return "1101010"; break;
		case 'q': return "10101100"; break;
		case 'r': return "11010"; break;
		case 's': return "1110"; break;
		case 't': return "100"; break;
		case 'u': return "11100"; break;
		case 'v': return "111100"; break;
		case 'w': return "110100"; break;
		case 'x': return "1011100"; break;
		case 'y': return "10110100"; break;
		case 'z': return "1010110"; break;
		case ' ': return "000"; break;
		case '1': return "1101010100"; break;
		case '2': return "111010100"; break;
		case '3': return "11110100"; break;
		case '4': return "1111100"; break;
		case '5': return "111110"; break;
		case '6': return "1011110"; break;
		case '7': return "10101110"; break;
		case '8': return "101010110"; break;
		case '9': return "1010101010"; break;
		case '0': return "10101010100"; break;
		default: return ""; break;
		}
	}

//Returns the hexadecimal character equivalent of a four digit binary number
function binToHex(x) {
  var setVal = 0;
	if(x.charAt(0)=='1') setVal+=8;
	if(x.charAt(1)=='1') setVal+=4;
  if(x.charAt(2)=='1') setVal+=2;
  if(x.charAt(3)=='1') setVal+=1;
  if(setVal<10) return setVal;
  switch(setVal) {
	     case 10: return 'A'; break;
	     case 11: return 'B'; break;
	     case 12: return 'C'; break;
	     case 13: return 'D'; break;
	     case 14: return 'E'; break;
	     case 15: return 'F'; break;
	     default: return ''; break;
       }
    }

//Write out one beat based on hexadecimal character input
function writeNotes(x) {
	switch(x) {
		case '0': morseC.add(quart0); break;
		case '1': morseC.add(dotEighth0); morseC.add(sixt1); break;
		case '2': morseC.add(eighth0); morseC.add(eighth1); break;
		case '3': morseC.add(eighth0); morseC.add(sixt1); morseC.add(sixt1); break;
		case '4': morseC.add(sixt0); morseC.add(dotEighth1); break;
		case '5': morseC.add(sixt0); morseC.add(eighth1); morseC.add(sixt1); break;
		case '6': morseC.add(sixt0); morseC.add(sixt1); morseC.add(eighth1); break;
		case '7': morseC.add(sixt0); morseC.add(sixt1); morseC.add(sixt1); morseC.add(sixt1); break;
		case '8': morseC.add(quart1); break;
		case '9': morseC.add(dotEighth1); morseC.add(sixt1); break;
		case 'A': morseC.add(eighth1); morseC.add(eighth1); break;
		case 'B': morseC.add(eighth1); morseC.add(sixt1); morseC.add(sixt1); break;
		case 'C': morseC.add(sixt1); morseC.add(dotEighth1); break;
		case 'D': morseC.add(sixt1); morseC.add(eighth1); morseC.add(sixt1); break;
		case 'E': morseC.add(sixt1); morseC.add(sixt1); morseC.add(eighth1); break;
		case 'F': morseC.add(sixt1); morseC.add(sixt1); morseC.add(sixt1); morseC.add(sixt1); break;
		default: break;
		}
	}

      
      onRun: {
      //Setup variables
           //Define basic note
            beep = new Note();
            beep.pitch = 75;
            beep.velocity = 100;
            
           //Define building block chords
            eighth1 = new Chord();
            eighth1.addNote(Note beep);
            eighth1.tickLen = 240;
            dotEighth1 = new Chord();
            dotEighth1.addNote(Note beep);
            dotEighth1.tickLen = 360;
            sixt1 = new Chord();
            sixt1.addNote(Note beep);
            sixt1.tickLen = 120;
            quart1 = new Chord();
            quart1.addNote(Note beep);
            quart1.tickLen = 480;
            
           //Define building block rests
            eighth0 = new Rest();
            eighth0.tickLen = 240;
            dotEighth0 = new Rest();
            dotEighth0.tickLen = 360;
            sixt0 = new Rest();
            sixt0.tickLen = 120;
            quart0 = new Rest();
            quart0.tickLen = 480;
            
      //Main Code
      //var userIn = prompt("Please enter some text (special characters won't be translated)","example text");
      if(userIn!=null) {
        //Convert user input into binary morse code string
        var userInBinary = "";
        for (i=0;i<userIn.length();i++) {
	          userInBinary += charToBin(userIn.toLowerCase().charAt(i));
	        }
        //Extend binary morse code string to fill a full 4/4 bar
        while(userInBinary%16 != 0) {
	          userInBinary += "0";
	        }
          
        //Convert binary morse code string to hexadecimal characters
        //(could've written the program without this step,
        // but it could be useful for future implementation)
        var userInHex = "";
        for(i=0;i<(userInBinary/4);i++) {
	          tempByte = userInBinary.substring(i*4,(i+1)*4);
	          userInHex += "" + binToHex(tempByte);
	        }
          
        //Create new score with correct # of measures and claves part
        var morseScore = new Score();
        morseScore.composer = "Emmett Husmann";
        morseScore.keysig = 0;
        morseScore.title = userIn;
        morseScore.timesig.setCommonTime();
        morseScore.appendMeasures(userInHex.length()/4);
        morseScore.appendPart("claves");

        //Create and reposition new cursor
        morseC = new Cursor(morseScore);
        morseC.staff = 0;
        morseC.voice = 0;
        morseC.rewind();

        //Write out notes in score from the hexadecimal string
        for(i=0;i<userInHex.length();i++) {
	          writeNotes(userInHex.charAt(i));
	        }
        //Confirm end of program
        console.log("completed morse code translation");
         }
        Qt.quit()
       }
      }
