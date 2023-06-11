using System;
using System.Windows.Forms;

namespace ClientApp
{
    public partial class InsertForm : Form
    {
        public string Sql = null;

        private string procedure;
        private Control[] args;
        private bool[] isString;

        public InsertForm(int table)
        {
            InitializeComponent();
            switch (table)
            {
                case 1:
                    TicketLayout();
                    break;
                case 2:
                    PassengerLayout();
                    break;
                case 3:
                    FlightLayout();
                    break;
                case 4:
                    PlaneLayout();
                    break;
            }
        }

        private void PassengerLayout()
        {
            Label label1 = new Label();
            System.Windows.Forms.TextBox fullNameTextBox = new System.Windows.Forms.TextBox();
            Label label2 = new Label();
            MaskedTextBox psprtMaskedTextBox = new MaskedTextBox();

            procedure = "add_passenger";
            args = new Control[] {fullNameTextBox, psprtMaskedTextBox};
            isString = new bool[] { true, true };
                        
            SuspendLayout();
            // 
            // label3
            // 
            label1.AutoSize = true;
            label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            label1.Location = new System.Drawing.Point(123, 177);
            label1.Name = "label3";
            label1.Size = new System.Drawing.Size(85, 20);
            label1.TabIndex = 9;
            label1.Text = "Full Name";
            // 
            // fullNameTextBox
            // 
            fullNameTextBox.Location = new System.Drawing.Point(54, 200);
            fullNameTextBox.MaxLength = 100;
            fullNameTextBox.Name = "fullNameTextBox";
            fullNameTextBox.Size = new System.Drawing.Size(210, 30);
            fullNameTextBox.TabIndex = 8;
            fullNameTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            label2.Location = new System.Drawing.Point(132, 78);
            label2.Name = "label2";
            label2.Size = new System.Drawing.Size(76, 20);
            label2.TabIndex = 7;
            label2.Text = "Passport";
            // 
            // psprtMaskedTextBox
            // 
            psprtMaskedTextBox.CutCopyMaskFormat = System.Windows.Forms.MaskFormat.ExcludePromptAndLiterals;
            psprtMaskedTextBox.Location = new System.Drawing.Point(91, 101);
            psprtMaskedTextBox.Mask = "0000 000000";
            psprtMaskedTextBox.Name = "psprtMaskedTextBox";
            psprtMaskedTextBox.Size = new System.Drawing.Size(145, 30);
            psprtMaskedTextBox.TabIndex = 6;
            psprtMaskedTextBox.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            psprtMaskedTextBox.TextMaskFormat = System.Windows.Forms.MaskFormat.ExcludePromptAndLiterals;
            //
            //
            //
            Controls.Add(label1);
            Controls.Add(fullNameTextBox);
            Controls.Add(label2);
            Controls.Add(psprtMaskedTextBox);
            Text = "Insert into passengers";
            ResumeLayout(false);
            PerformLayout();
        }

        private void PlaneLayout()
        {
            Label label1 = new Label();
            Label label2 = new Label();
            System.Windows.Forms.TextBox textBox1 = new System.Windows.Forms.TextBox();
            System.Windows.Forms.TextBox textBox2 = new System.Windows.Forms.TextBox();

            procedure = "add_plane";
            args = new Control[] { textBox1, textBox2 };
            isString = new bool[] { true, false };

            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new System.Drawing.Point(111, 50);
            label1.Name = "label1";
            label1.Size = new System.Drawing.Size(66, 25);
            label1.TabIndex = 2;
            label1.Text = "Model";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new System.Drawing.Point(111, 158);
            label2.Name = "label2";
            label2.Size = new System.Drawing.Size(63, 25);
            label2.TabIndex = 3;
            label2.Text = "Seats";
            // 
            // textBox1
            // 
            textBox1.Location = new System.Drawing.Point(116, 78);
            textBox1.MaxLength = 40;
            textBox1.Name = "textBox1";
            textBox1.Size = new System.Drawing.Size(100, 30);
            textBox1.TabIndex = 4;
            // 
            // textBox2
            // 
            textBox2.Location = new System.Drawing.Point(116, 186);
            textBox2.MaxLength = 4;
            textBox2.Name = "textBox2";
            textBox2.Size = new System.Drawing.Size(100, 30);
            textBox2.TabIndex = 5;
            textBox2.KeyPress += new KeyPressEventHandler(TextBox_KeyPress_OnlyDigits);

            //

            Controls.Add(textBox2);
            Controls.Add(textBox1);
            Controls.Add(label2);
            Controls.Add(label1);
            Text = "Insert into planes";
            ResumeLayout(false);
            PerformLayout();
        }

        private void FlightLayout()
        {
            System.Windows.Forms.Label label1;
            System.Windows.Forms.TextBox textBox1;
            System.Windows.Forms.TextBox textBox2;
            System.Windows.Forms.TextBox textBox3;
            System.Windows.Forms.TextBox textBox4;
            System.Windows.Forms.Label label2;
            System.Windows.Forms.Label label3;
            System.Windows.Forms.Label label4;
            System.Windows.Forms.Label label5;
            System.Windows.Forms.Label label6;
            System.Windows.Forms.DateTimePicker dateTimePicker1;
            System.Windows.Forms.DateTimePicker dateTimePicker2;

            label1 = new System.Windows.Forms.Label();
            textBox1 = new System.Windows.Forms.TextBox();
            textBox2 = new System.Windows.Forms.TextBox();
            textBox3 = new System.Windows.Forms.TextBox();
            textBox4 = new System.Windows.Forms.TextBox();
            label2 = new System.Windows.Forms.Label();
            label3 = new System.Windows.Forms.Label();
            label4 = new System.Windows.Forms.Label();
            label5 = new System.Windows.Forms.Label();
            label6 = new System.Windows.Forms.Label();
            dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            dateTimePicker2 = new System.Windows.Forms.DateTimePicker();


            procedure = "add_flight";
            args = new Control[] { textBox1, textBox2, dateTimePicker1, dateTimePicker2, textBox3, textBox4 };
            isString = new bool[] { true, true, true, true, false, false };

            SuspendLayout();

            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new System.Drawing.Point(12, 24);
            label1.Name = "label1";
            label1.Size = new System.Drawing.Size(129, 25);
            label1.TabIndex = 2;
            label1.Text = "departure city";
            // 
            // textBox1
            // 
            textBox1.Location = new System.Drawing.Point(12, 52);
            textBox1.MaxLength = 40;
            textBox1.Name = "textBox1";
            textBox1.Size = new System.Drawing.Size(170, 30);
            textBox1.TabIndex = 3;
            // 
            // textBox2
            // 
            textBox2.Location = new System.Drawing.Point(220, 52);
            textBox2.MaxLength = 40;
            textBox2.Name = "textBox2";
            textBox2.Size = new System.Drawing.Size(170, 30);
            textBox2.TabIndex = 4;
            // 
            // textBox3
            // 
            textBox3.Location = new System.Drawing.Point(12, 301);
            textBox3.MaxLength = 40;
            textBox3.Name = "textBox3";
            textBox3.Size = new System.Drawing.Size(100, 30);
            textBox3.TabIndex = 7;
            textBox3.KeyPress += new System.Windows.Forms.KeyPressEventHandler(TextBox_KeyPress_OnlyDigits);
            // 
            // textBox4
            // 
            textBox4.Location = new System.Drawing.Point(220, 301);
            textBox4.MaxLength = 40;
            textBox4.Name = "textBox4";
            textBox4.Size = new System.Drawing.Size(100, 30);
            textBox4.TabIndex = 8;
            textBox4.KeyPress += new System.Windows.Forms.KeyPressEventHandler(TextBox_KeyPress_OnlyDigits);
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new System.Drawing.Point(215, 24);
            label2.Name = "label2";
            label2.Size = new System.Drawing.Size(98, 25);
            label2.TabIndex = 9;
            label2.Text = "arrival city";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new System.Drawing.Point(93, 109);
            label3.Name = "label3";
            label3.Size = new System.Drawing.Size(136, 25);
            label3.TabIndex = 10;
            label3.Text = "departure time";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new System.Drawing.Point(93, 182);
            label4.Name = "label4";
            label4.Size = new System.Drawing.Size(105, 25);
            label4.TabIndex = 11;
            label4.Text = "arrival time";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new System.Drawing.Point(12, 273);
            label5.Name = "label5";
            label5.Size = new System.Drawing.Size(54, 25);
            label5.TabIndex = 12;
            label5.Text = "price";
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Location = new System.Drawing.Point(215, 273);
            label6.Name = "label6";
            label6.Size = new System.Drawing.Size(86, 25);
            label6.TabIndex = 13;
            label6.Text = "plane_id";
            // 
            // dateTimePicker1
            // 
            dateTimePicker1.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            dateTimePicker1.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            dateTimePicker1.Location = new System.Drawing.Point(98, 137);
            dateTimePicker1.MinDate = new System.DateTime(2023, 1, 1, 0, 0, 0, 0);
            dateTimePicker1.Name = "dateTimePicker1";
            dateTimePicker1.Size = new System.Drawing.Size(236, 30);
            dateTimePicker1.TabIndex = 14;
            dateTimePicker1.Value = new System.DateTime(2023, 6, 9, 3, 4, 21, 0);
            // 
            // dateTimePicker2
            // 
            dateTimePicker2.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            dateTimePicker2.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            dateTimePicker2.Location = new System.Drawing.Point(98, 210);
            dateTimePicker2.MinDate = new System.DateTime(2023, 1, 1, 0, 0, 0, 0);
            dateTimePicker2.Name = "dateTimePicker2";
            dateTimePicker2.Size = new System.Drawing.Size(236, 30);
            dateTimePicker2.TabIndex = 15;
            dateTimePicker2.Value = new System.DateTime(2023, 6, 9, 3, 4, 21, 0);

            Controls.Add(dateTimePicker2);
            Controls.Add(dateTimePicker1);
            Controls.Add(label6);
            Controls.Add(label5);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(textBox4);
            Controls.Add(textBox3);
            Controls.Add(textBox2);
            Controls.Add(textBox1);
            Controls.Add(label1);
            ClientSize = new System.Drawing.Size(432, 433);
            Text = "Insert into flights";
            ResumeLayout(false);
            PerformLayout();
        }

        private void TicketLayout()
        {
            System.Windows.Forms.Label label1;
            System.Windows.Forms.Label label2;
            System.Windows.Forms.Label label3;
            System.Windows.Forms.TextBox textBox1;
            System.Windows.Forms.TextBox textBox2;
            System.Windows.Forms.TextBox textBox3;
            textBox1 = new System.Windows.Forms.TextBox();
            label1 = new System.Windows.Forms.Label();
            label2 = new System.Windows.Forms.Label();
            label3 = new System.Windows.Forms.Label();
            textBox2 = new System.Windows.Forms.TextBox();
            textBox3 = new System.Windows.Forms.TextBox();

            procedure = "buy_ticket";
            args = new Control[] { textBox1, textBox2, textBox3 };
            isString = new bool[] { false, false, true };

            SuspendLayout();

            // 
            // textBox1
            // 
            textBox1.Location = new System.Drawing.Point(115, 78);
            textBox1.MaxLength = 6;
            textBox1.Name = "textBox1";
            textBox1.Size = new System.Drawing.Size(100, 30);
            textBox1.TabIndex = 2;
            textBox1.KeyPress += new System.Windows.Forms.KeyPressEventHandler(TextBox_KeyPress_OnlyDigits);
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new System.Drawing.Point(110, 50);
            label1.Name = "label1";
            label1.Size = new System.Drawing.Size(78, 25);
            label1.TabIndex = 3;
            label1.Text = "flight_id";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new System.Drawing.Point(110, 134);
            label2.Name = "label2";
            label2.Size = new System.Drawing.Size(130, 25);
            label2.TabIndex = 4;
            label2.Text = "passenger_id";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new System.Drawing.Point(110, 225);
            label3.Name = "label3";
            label3.Size = new System.Drawing.Size(157, 25);
            label3.TabIndex = 5;
            label3.Text = "payment method";
            // 
            // textBox2
            // 
            textBox2.Location = new System.Drawing.Point(115, 162);
            textBox2.MaxLength = 6;
            textBox2.Name = "textBox2";
            textBox2.Size = new System.Drawing.Size(100, 30);
            textBox2.TabIndex = 6;
            textBox2.KeyPress += new System.Windows.Forms.KeyPressEventHandler(TextBox_KeyPress_OnlyDigits);
            // 
            // textBox3
            // 
            textBox3.Location = new System.Drawing.Point(115, 253);
            textBox3.MaxLength = 15;
            textBox3.Name = "textBox3";
            textBox3.Size = new System.Drawing.Size(100, 30);
            textBox3.TabIndex = 7;
            textBox3.Text = "admin app";
            //
            //
            //
            Controls.Add(textBox3);
            Controls.Add(textBox2);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(textBox1);
            Text = "Insert into tickets";
            ResumeLayout(false);
            PerformLayout();
        }

        private void TextBox_KeyPress_OnlyDigits(object sender, KeyPressEventArgs e)
        {
            if (!(char.IsDigit(e.KeyChar) || e.KeyChar == (char)Keys.Back || e.KeyChar == (char)Keys.Delete))
            {
                e.Handled = true;
            }
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }

        private void OkButton_Click(object sender, EventArgs e)
        {
            string[] _args = new string[args.Length];
            for (int i = 0; i < args.Length; i++)
            {
                if (string.IsNullOrWhiteSpace(args[i].Text))
                {
                    MessageBox.Show("Please, fill all empty fields.", "Error");
                    return;
                }

                if (isString[i])
                    _args[i] = "'" + args[i].Text + "'";
                else
                    _args[i] = args[i].Text;
            }

            Sql = "call " + procedure + "(" + string.Join(",", _args) + ");";
            
            DialogResult = DialogResult.OK;
            Close();
        }
    }
}
