import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator implements ActionListener{

    JFrame frame;
    JTextField textfield, sqrtfield, logfield;
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

    Font font = new Font("Arial",Font.PLAIN,30);
    Font smallerfont = new Font("Arial",Font.PLAIN,20);
    Font smolfont = new Font("Arial",Font.PLAIN,16);

    double num1 = 0, num2 = 0, rslt = 0;
    char operator = ' ';

    Calculator (){

        frame = new JFrame("Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(420, 800);
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
        sqrtbutton = new JButton("sqrt");
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
        frame.setVisible(true);

    }

    @Override
    public void actionPerformed(ActionEvent e) {

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
            operator = '+';
            textfield.setText("");
        }
        if(e.getSource() == subbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '-';
            textfield.setText("");
        }
        if(e.getSource() == mulbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '*';
            textfield.setText("");
        }
        if(e.getSource() == divbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '/';
            textfield.setText("");
        }
        if(e.getSource() == expbutton) {
            num1 = Double.parseDouble(textfield.getText());
            operator = '^';
            textfield.setText("");
        }
        if(e.getSource() == sqrtbutton) {
            if (!sqrton) {
                sqrton = true;
                logon = false;
                lnon = false;
                logfield.setText("");
                operator = 'q';
                sqrtfield.setText("sqrt");
            } else if (sqrton) {
                sqrton = false;
                operator = ' ';
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
                operator = 'l';
                logfield.setText("log");
            } else if (logon) {
                logon = false;
                operator = ' ';
                logfield.setText("");
            }
        
        }
        if(e.getSource() == lnbutton) {
            if (!lnon) {
                lnon = true;
                logon = false;
                sqrton = false;
                sqrtfield.setText("");
                operator = 'n';
                logfield.setText("ln");
            } else if (lnon) {
                lnon = false;
                operator = ' ';
                logfield.setText("");
            }
        }
        // TODO: All but sqrt
        if(e.getSource() == equbutton) {
            num2 = Double.parseDouble(textfield.getText());
            switch (operator) {
                case '+':
                    rslt = num1 + num2;
                    break;
                case '-':
                    rslt = num1 - num2;
                    break;
                case '*':
                    rslt = num1 * num2;
                    break;
                case '/':
                    if (num2 == 0) {
                        textfield.setText("undefined");
                    } else if (num2 != 0) {
                        rslt = num1 / num2;
                    }
                    break;
                case '^':
                    rslt = Math.pow(num1, num2);
                    break;
                case 'q':
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.sqrt(num1);
                    break;
                case 'l':
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = Math.log(num1);
                    break;
                case 'n':
                    num1 = Double.parseDouble(textfield.getText());
                    rslt = (Math.log(num1) / Math.E);
                    break;
                default:
                    rslt = Double.parseDouble(textfield.getText());
                    break;
            }
            if (num2 != 0 | operator != '/') {
            textfield.setText(String.valueOf(rslt));
            num1=rslt;
            }
        }
        if (e.getSource() == clrbutton) {
            textfield.setText("");
            sqrtfield.setText("");
            operator = ' ';
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
    }
}