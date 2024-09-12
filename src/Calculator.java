import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator implements ActionListener{

    //Calculator components
    JFrame frame;
    JTextField textfield, sqrtfield, logfield, trigfield;
    JButton[] numberbutton = new JButton[10];
    JButton[] functionbutton = new JButton[6];
    JButton[] morefunctionsf = new JButton[9];
    JButton[] morefunctionss = new JButton[9];
    JButton[] minipanelbuttons = new JButton[3];
    JButton addbutton, subbutton, mulbutton, divbutton;
    JButton decbutton, equbutton, delbutton, clrbutton, negbutton;
    JButton degbutton, sqrtbutton, sinbutton, cosbutton, tanbutton, logbutton, pibutton, sqbutton, expbutton;
    JButton ebutton, radbutton, morebutton, asin, acos, atan, eexp, morebuttons, radbuttons, degbuttons;
    JButton lnbutton;
    JPanel panel, minipanel, panel2, panel3;

    boolean degrees = true;
    boolean sqrton = false;
    boolean logon = false;
    boolean lnon = false;
    boolean sinon = false;
    boolean coson = false;
    boolean tanon = false;
    boolean asinon = false;
    boolean acoson = false;
    boolean atanon = false;

    //Memory memory = new Memory();

    Font font = new Font("Arial",Font.PLAIN,30);
    Font smallerfont = new Font("Arial",Font.PLAIN,20);
    Font smolfont = new Font("Arial",Font.PLAIN,16);

    double num1 = 0;
    double num2 = 0;
    double rslt = 0;
    String operator = "";

    // Memory components
    JFrame memoryframe;
    JTextField mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10;
	JButton recall1, recall2, recall3, recall4, recall5, recall6, recall7, recall8, recall9, recall10, clear;

    double m1 = 0;
    double m2 = 0;
    double m3 = 0;
    double m4 = 0;
    double m5 = 0;
    double m6 = 0;
    double m7 = 0;
    double m8 = 0;
    double m9 = 0;
    double m10 = 0;

    Calculator (){
        // Calculator parts
        frame = new JFrame("Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420+800, 800);
        frame.setLayout(null);

        textfield = new JTextField();
        textfield.setBounds(50, 25, 300, 50);
        textfield.setFont(font);
        textfield.setEditable(false);

        sqrtfield = new JTextField();
        sqrtfield.setBounds(50, 5, 70, 20);
        sqrtfield.setFont(smolfont);
        sqrtfield.setEditable(false);

        logfield = new JTextField();
        logfield.setBounds(130, 5, 70, 20);
        logfield.setFont(smolfont);
        logfield.setEditable(false);

        trigfield = new JTextField();
        trigfield.setBounds(210, 5, 70, 20);
        trigfield.setFont(smolfont);
        trigfield.setEditable(false);

        addbutton = new JButton("+");
        subbutton = new JButton("-");
        mulbutton = new JButton("x");
        divbutton = new JButton("/");
        decbutton = new JButton(".");
        equbutton = new JButton("=");

        delbutton = new JButton("del");
        clrbutton = new JButton("clr");
        negbutton = new JButton("+/-");

        radbutton = new JButton("RAD");
        degbutton = new JButton("DEG");
        sqrtbutton = new JButton("√");
        morebutton = new JButton("2nd");
        expbutton = new JButton("^");
        sqbutton = new JButton("x^2");
        sinbutton = new JButton("sin");
        cosbutton = new JButton("cos");
        tanbutton = new JButton("tan");
        asin = new JButton("asin");
        acos = new JButton("acos");
        atan = new JButton("atan");
        lnbutton = new JButton("ln");
        logbutton = new JButton("log");
        pibutton = new JButton("π");
        ebutton = new JButton("e");
        eexp = new JButton("e^x");

        morebuttons = new JButton("2nd");
        radbuttons = new JButton("RAD");
        degbuttons = new JButton("DEG");

        degbutton.addActionListener(this);

        functionbutton[0] = addbutton;
        functionbutton[1] = subbutton;
        functionbutton[2] = mulbutton;
        functionbutton[3] = divbutton;
        functionbutton[4] = decbutton;
        functionbutton[5] = equbutton;

        minipanelbuttons[0] = negbutton;
        minipanelbuttons[1] = delbutton;
        minipanelbuttons[2] = clrbutton;

        morefunctionsf[0] = morebutton;
        morefunctionsf[1] = degbutton;
        morefunctionsf[2] = expbutton;
        morefunctionsf[3] = sinbutton;
        morefunctionsf[4] = cosbutton;
        morefunctionsf[5] = tanbutton;
        morefunctionsf[6] = sqbutton;
        morefunctionsf[7] = logbutton;
        morefunctionsf[8] = pibutton;

        morefunctionss[0] = morebuttons;
        morefunctionss[1] = degbuttons;
        morefunctionss[2] = sqrtbutton;
        morefunctionss[3] = asin;
        morefunctionss[4] = acos;
        morefunctionss[5] = atan;
        morefunctionss[6] = eexp;
        morefunctionss[7] = lnbutton;
        morefunctionss[8] = ebutton;

        for(int i =0;i<6;i++) {
            functionbutton[i].addActionListener(this);
            functionbutton[i].setFont(font);
            functionbutton[i].setFocusable(false);
        }

        for(int i =0;i<10;i++) {
            numberbutton[i] = new JButton(String.valueOf(i));
            numberbutton[i].addActionListener(this);
            numberbutton[i].setFont(font);
            numberbutton[i].setFocusable(false);
        }

        for(int i =0;i<3;i++) {
            minipanelbuttons[i].addActionListener(this);
            minipanelbuttons[i].setFont(smallerfont);
            minipanelbuttons[i].setFocusable(false);
        }

        for(int i =0;i<9;i++) {
            morefunctionsf[i].addActionListener(this);
            morefunctionsf[i].setFont(smallerfont);
            morefunctionsf[i].setFocusable(false);
        }

        for(int i =0;i<9;i++) {
            morefunctionss[i].addActionListener(this);
            morefunctionss[i].setFont(smallerfont);
            morefunctionss[i].setFocusable(false);
        }

        //negbutton.setBounds(50,415,100,50);
        //delbutton.setBounds(150,415,100,50);
        //clrbutton.setBounds(250,415,100,50);

        panel = new JPanel();
        panel.setBounds(50, 160, 300, 300);
        panel.setLayout(new GridLayout(4,4,10,10));

        minipanel = new JPanel();
        minipanel.setBounds(50, 100, 300, 50);
        minipanel.setLayout(new GridLayout(1, 3, 10, 10));

        panel2 = new JPanel();
        panel2.setBounds(50, 490, 300, 231);
        panel2.setLayout(new GridLayout(3, 4, 10, 10));

        panel3 = new JPanel();
        panel3.setBounds(50, 490, 300, 231);
        panel3.setLayout(new GridLayout(3, 4, 10, 10));

        panel.add(numberbutton[1]);
        panel.add(numberbutton[2]);
        panel.add(numberbutton[3]);
        panel.add(addbutton);
        panel.add(numberbutton[4]);
        panel.add(numberbutton[5]);
        panel.add(numberbutton[6]);
        panel.add(subbutton);
        panel.add(numberbutton[7]);
        panel.add(numberbutton[8]);
        panel.add(numberbutton[9]);
        panel.add(mulbutton);
        panel.add(decbutton);
        panel.add(numberbutton[0]);
        panel.add(equbutton);
        panel.add(divbutton);

        for(int i =0;i<9; i++) {
            panel2.add(morefunctionsf[i]);
        }

        minipanel.add(negbutton);
        minipanel.add(delbutton);
        minipanel.add(clrbutton);

        for(int i =0;i<9;i++) {
            panel3.add(morefunctionss[i]);
        }

        frame.add(panel);
        frame.add(minipanel);
        frame.add(panel2);
        frame.add(textfield);
        frame.add(sqrtfield);
        frame.add(logfield);
        frame.add(trigfield);

        //Memory parts
   /*     memoryframe = new JFrame("Memory");
		memoryframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		memoryframe.setSize(800, 675);
		memoryframe.setLayout(null);
        memoryframe.setLocation(410, 0); */

        mem1 = new JTextField("0.0");
        mem2 = new JTextField("0.0");
        mem3 = new JTextField("0.0");
        mem4 = new JTextField("0.0");
        mem5 = new JTextField("0.0");
        mem6 = new JTextField("0.0");
        mem7 = new JTextField("0.0");
        mem8 = new JTextField("0.0");
        mem9 = new JTextField("0.0");
        mem10 = new JTextField("0.0");



        mem1.setBounds(50+350, 25, 550, 50);
        mem2.setBounds(50+350, 75, 550, 50);
        mem3.setBounds(50+350, 125, 550, 50);
        mem4.setBounds(50+350, 175, 550, 50);
        mem5.setBounds(50+350, 225, 550, 50);
        mem6.setBounds(50+350, 275, 550, 50);
        mem7.setBounds(50+350, 325, 550, 50);
        mem8.setBounds(50+350, 375, 550, 50);
        mem9.setBounds(50+350, 425, 550, 50);
        mem10.setBounds(50+350, 475, 550, 50);

        frame.add(mem1);
        frame.add(mem2);
        frame.add(mem3);
        frame.add(mem4);
        frame.add(mem5);
        frame.add(mem6);
        frame.add(mem7);
        frame.add(mem8);
        frame.add(mem9);
        frame.add(mem10);
/*
        memoryframe.add(mem1);
        memoryframe.add(mem2);
        memoryframe.add(mem3);
        memoryframe.add(mem4);
        memoryframe.add(mem5);
        memoryframe.add(mem6);
        memoryframe.add(mem7);
        memoryframe.add(mem8);
        memoryframe.add(mem9);
        memoryframe.add(mem10);
*/
        mem1.setFont(font);
        mem2.setFont(font);
        mem3.setFont(font);
        mem4.setFont(font);
        mem5.setFont(font);
        mem6.setFont(font);
        mem7.setFont(font);
        mem8.setFont(font);
        mem9.setFont(font);
        mem10.setFont(font);

        mem1.setEditable(false);
        mem2.setEditable(false);
        mem3.setEditable(false);
        mem4.setEditable(false);
        mem5.setEditable(false);
        mem6.setEditable(false);
        mem7.setEditable(false);
        mem8.setEditable(false);
        mem9.setEditable(false);
        mem10.setEditable(false);

        mem1.setFocusable(false);
        mem2.setFocusable(false);
        mem3.setFocusable(false);
        mem4.setFocusable(false);
        mem5.setFocusable(false);
        mem6.setFocusable(false);
        mem7.setFocusable(false);
        mem8.setFocusable(false);
        mem9.setFocusable(false);
        mem10.setFocusable(false);

        recall1 = new JButton("Recall");
        recall2 = new JButton("Recall");
        recall3 = new JButton("Recall");
        recall4 = new JButton("Recall");
        recall5 = new JButton("Recall");
        recall6 = new JButton("Recall");
        recall7 = new JButton("Recall");
        recall8 = new JButton("Recall");
        recall9 = new JButton("Recall");
        recall10 = new JButton("Recall");

        recall1.addActionListener(this);
        recall2.addActionListener(this);
        recall3.addActionListener(this);
        recall4.addActionListener(this);
        recall5.addActionListener(this);
        recall6.addActionListener(this);
        recall7.addActionListener(this);
        recall8.addActionListener(this);
        recall9.addActionListener(this);
        recall10.addActionListener(this);

        recall1.setBounds(625+350, 25, 125, 50);
        recall2.setBounds(625+350, 75, 125, 50);
        recall3.setBounds(625+350, 125, 125, 50);
        recall4.setBounds(625+350, 175, 125, 50);
        recall5.setBounds(625+350, 225, 125, 50);
        recall6.setBounds(625+350, 275, 125, 50);
        recall7.setBounds(625+350, 325, 125, 50);
        recall8.setBounds(625+350, 375, 125, 50);
        recall9.setBounds(625+350, 425, 125, 50);
        recall10.setBounds(625+350, 475, 125, 50);

        frame.add(recall1);
        frame.add(recall2);
        frame.add(recall3);
        frame.add(recall4);
        frame.add(recall5);
        frame.add(recall6);
        frame.add(recall7);
        frame.add(recall8);
        frame.add(recall9);
        frame.add(recall10);
/*
        memoryframe.add(recall1);
        memoryframe.add(recall2);
        memoryframe.add(recall3);
        memoryframe.add(recall4);
        memoryframe.add(recall5);
        memoryframe.add(recall6);
        memoryframe.add(recall7);
        memoryframe.add(recall8);
        memoryframe.add(recall9);
        memoryframe.add(recall10);
*/
        recall1.setFont(font);
        recall2.setFont(font);
        recall3.setFont(font);
        recall4.setFont(font);
        recall5.setFont(font);
        recall6.setFont(font);
        recall7.setFont(font);
        recall8.setFont(font);
        recall9.setFont(font);
        recall10.setFont(font);

        recall1.setFocusable(false);
        recall2.setFocusable(false);
        recall3.setFocusable(false);
        recall4.setFocusable(false);
        recall5.setFocusable(false);
        recall6.setFocusable(false);
        recall7.setFocusable(false);
        recall8.setFocusable(false);
        recall9.setFocusable(false);
        recall10.setFocusable(false);

        clear = new JButton("Memory Reset");
        clear.addActionListener(this);
        clear.setBounds(50+350, 550, 700, 50);
        //memoryframe.add(clear);
        frame.add(clear);
        clear.setFont(font);
        clear.setFocusable(false);

        // Make both frames visible
        //memoryframe.setVisible(true);
        frame.setVisible(true);

    }

    public static void main(String[] args) {
        Calculator calc = new Calculator();
    } 

    void updateMemory () {
        m10 = m9;
        m9 = m8;
        m8 = m7;
        m7 = m6;
        m6 = m5;
        m5 = m4;
        m4 = m3;
        m3 = m2;
        m2 = m1;
        m1 = rslt;

        mem1.setText(String.valueOf(m1));
        mem2.setText(String.valueOf(m2));
        mem3.setText(String.valueOf(m3));
        mem4.setText(String.valueOf(m4));
        mem5.setText(String.valueOf(m5));
        mem6.setText(String.valueOf(m6));
        mem7.setText(String.valueOf(m7));
        mem8.setText(String.valueOf(m8));
        mem9.setText(String.valueOf(m9));
        mem10.setText(String.valueOf(m10));

        System.out.println("Memory reset");
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        // Memory functions
        if(e.getSource() == recall1) {
			textfield.setText(String.valueOf(m1));
            System.out.println("Recalled memory 1");
		}
        if(e.getSource() == recall2) {
            textfield.setText(String.valueOf(m2));
            System.out.println("Recalled memory 2");
        }
        if(e.getSource() == recall3) {
            textfield.setText(String.valueOf(m3));
            System.out.println("Recalled memory 3");
        }
        if(e.getSource() == recall4) {
            textfield.setText(String.valueOf(m4));
            System.out.println("Recalled memory 4");
        }
        if(e.getSource() == recall5) {
            textfield.setText(String.valueOf(m5));
            System.out.println("Recalled memory 5");
        }
        if(e.getSource() == recall6) {
            textfield.setText(String.valueOf(m6));
            System.out.println("Recalled memory 6");
        }
        if(e.getSource() == recall7) {
            textfield.setText(String.valueOf(m7));
            System.out.println("Recalled memory 7");
        }
        if(e.getSource() == recall8) {
            textfield.setText(String.valueOf(m8));
            System.out.println("Recalled memory 8");
        }
        if(e.getSource() == recall9) {
            textfield.setText(String.valueOf(m9));
            System.out.println("Recalled memory 9");
        }
        if(e.getSource() == recall10) {
            textfield.setText(String.valueOf(m10));
            System.out.println("Recalled memory 10");
        }
        if(e.getSource() == clear) {
            m1 = 0;
            m2 = 0;
            m3 = 0;
            m4 = 0;
            m5 = 0;
            m6 = 0;
            m7 = 0;
            m8 = 0;
            m9 = 0;
            m10 = 0;

            mem1.setText("0.0");
            mem2.setText("0.0");
            mem3.setText("0.0");
            mem4.setText("0.0");
            mem5.setText("0.0");
            mem6.setText("0.0");
            mem7.setText("0.0");
            mem8.setText("0.0");
            mem9.setText("0.0");
            mem10.setText("0.0");

            textfield.setText("");

            System.out.println("RAM cleared");
        }

        // Calculator functions
        for(int i=0;i<10;i++) {
            if(e.getSource() == numberbutton[i]) {
                textfield.setText(textfield.getText().concat(String.valueOf(i)));
            }
        }
        if(e.getSource() == decbutton) {
            textfield.setText(textfield.getText().concat("."));
        }
        if(e.getSource() == addbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = "+";
            textfield.setText("");
        }
        if(e.getSource() == subbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = "-";
            textfield.setText("");
        }
        if(e.getSource() == mulbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = "*";
            textfield.setText("");
        }
        if(e.getSource() == divbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = "/";
            textfield.setText("");
        }
        // Extra functions
        if(e.getSource() == expbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = "^";
            textfield.setText("");
        }
        if(e.getSource() == sqrtbutton) {
            if (!sqrton) {
                sqrton = true;
                logon = false;
                lnon = false;
                logfield.setText("");
                operator = "q";
                sqrtfield.setText("sqrt");
            } else if (sqrton) {
                sqrton = false;
                operator = "";
                sqrtfield.setText("");
            }
        }
        if(e.getSource() == pibutton) {
            textfield.setText(String.valueOf(Math.PI));
        }
        if(e.getSource() == ebutton) {
            textfield.setText(String.valueOf(Math.E));
        }
        if(e.getSource() == sqbutton) {
            num1 = Double.parseDouble(textfield.getText());
            textfield.setText(String.valueOf(Math.pow(num1, 2)));
        }
        if(e.getSource() == logbutton) {
            if (!logon) {
                logon = true;
                sqrton = false;
                lnon = false;
                sqrtfield.setText("");
                operator = "l";
                logfield.setText("log");
            } else if (logon) {
                logon = false;
                operator = "";
                logfield.setText("");
            }

        }
        if(e.getSource() == lnbutton) {
            if (!lnon) {
                lnon = true;
                logon = false;
                sqrton = false;
                sqrtfield.setText("");
                operator = "n";
                logfield.setText("ln");
            } else if (lnon) {
                lnon = false;
                operator = "";
                logfield.setText("");
            }
        }
        if(e.getSource() == eexp) {
            operator = "e";
        }
        if(e.getSource() == sinbutton) {
            if(!sinon) {
                sinon = true;
                coson = false;
                tanon = false;
                asinon = false;
                acoson = false;
                atanon = false;
                trigfield.setText("");
                operator = "S";
                trigfield.setText("sin");
            } else if (sinon) {
                sinon = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == cosbutton) {
            if(!coson) {
                coson = true;
                sinon = false;
                tanon = false;
                asinon = false;
                acoson = false;
                atanon = false;
                trigfield.setText("");
                operator = "C";
                trigfield.setText("cos");
            } else if (coson) {
                coson = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == tanbutton) {
            if(!tanon) {
                tanon = true;
                sinon = false;
                coson = false;
                asinon = false;
                acoson = false;
                atanon = false;
                trigfield.setText("");
                operator = "T";
                trigfield.setText("tan");
            } else if (tanon) {
                tanon = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == asin) {
            if(!asinon) {
                sinon = false;
                coson = false;
                tanon = false;
                asinon = true;
                acoson = false;
                atanon = false;
                trigfield.setText("asin");
                operator = "as";
            }
            if (asinon) {
                asinon = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == acos) {
            if(!acoson) {
                coson = false;
                sinon = false;
                tanon = false;
                asinon = false;
                acoson = true;
                atanon = false;
                trigfield.setText("acos");
                operator = "ac";
            }
            if (acoson) {
                acoson = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == atan) {
            if(!atanon) {
                coson = false;
                sinon = false;
                tanon = false;
                asinon = false;
                acoson = false;
                atanon = true;
                trigfield.setText("atan");
                operator = "at";
            }
            if (atanon) {
                atanon = false;
                operator = "";
                trigfield.setText("");
            }
        }
        if(e.getSource() == equbutton) {
            num2 = Double.parseDouble(textfield.getText());
            switch (operator) {
                case "+":
                    rslt = num1 + num2;
                    break;
                case "-":
                    rslt = num1 - num2;
                    break;
                case "*":
                    rslt = num1 * num2;
                    break;
                case "/":
                    if (num2 == 0) {
                        textfield.setText("undefined");
                    } else if (num2 != 0) {
                        rslt = num1 / num2;
                    }
                    break;
                case "^":
                    rslt = Math.pow(num1, num2);
                    break;
                case "q":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.sqrt(num1);
                    break;
                case "l":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.log(num1);
                    break;
                case "n":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = (Math.log(num1) / Math.log(Math.E));
                    break;
                case "e":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = (Math.pow(Math.E, num1));
                    break;
                case "S":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.sin(Math.toDegrees(num1));
                    break;
                case "C":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.cos(Math.toDegrees(num1));
                    break;
                case "T":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.tan(Math.toDegrees(num1));
                    break;
                case "as":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.asin(num1);
                    break;
                case "ac":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.acos(num1);
                    break;
                case "at":
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.atan(num1);
                    break;
                default:
                    rslt = Double.parseDouble(textfield.getText());
                    break;
            }
            if (num2 != 0 | operator != "/") {
            textfield.setText(String.valueOf(rslt));
            num1=rslt;
            }

            // Run Memory Update
            updateMemory();
        }
        if (e.getSource() == clrbutton) {
            textfield.setText("");
            sqrtfield.setText("");
            trigfield.setText("");
            operator = "";
        }
        if (e.getSource() == delbutton) {
            String string = textfield.getText();
            textfield.setText("");
            for(int i = 0; i<string.length() - 1; i++) {
                textfield.setText(textfield.getText() + string.charAt(i));
            }
        }
        if (e.getSource() == negbutton) {
            double temp = Double.parseDouble(textfield.getText());
            temp*= -1;
            textfield.setText(String.valueOf(temp));
        }
        // TODO: Add actualy functionality to RAD and DEG button
        if (e.getSource() == morebutton) {
            frame.repaint();
            frame.remove(panel2);
            frame.add(panel3);
            frame.setVisible(true);
            frame.repaint();
        }
        if (e.getSource() == morebuttons) {
            frame.repaint();
            frame.remove(panel3);
            frame.add(panel2);
            frame.setVisible(true);
            frame.repaint();
        }
        // TODO: Make the rest of the buttons functional
    }
}