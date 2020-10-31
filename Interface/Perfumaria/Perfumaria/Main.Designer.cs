namespace Perfumaria
{
    partial class Main
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.loginbutton = new System.Windows.Forms.Button();
            this.signup = new System.Windows.Forms.Button();
            this.emaillogin = new System.Windows.Forms.TextBox();
            this.pwlogin = new System.Windows.Forms.TextBox();
            this.Login = new System.Windows.Forms.Panel();
            this.Registo = new System.Windows.Forms.Panel();
            this.Registar = new System.Windows.Forms.Button();
            this.back = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.label15 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.nascimento = new System.Windows.Forms.DateTimePicker();
            this.label13 = new System.Windows.Forms.Label();
            this.newsletter = new System.Windows.Forms.CheckBox();
            this.label12 = new System.Windows.Forms.Label();
            this.sex = new System.Windows.Forms.ComboBox();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.lname = new System.Windows.Forms.TextBox();
            this.fname = new System.Windows.Forms.TextBox();
            this.contribuinte = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.confirmpw = new System.Windows.Forms.TextBox();
            this.pw = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.email = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.Login.SuspendLayout();
            this.Registo.SuspendLayout();
            this.SuspendLayout();
            // 
            // loginbutton
            // 
            this.loginbutton.Location = new System.Drawing.Point(253, 283);
            this.loginbutton.Name = "loginbutton";
            this.loginbutton.Size = new System.Drawing.Size(114, 63);
            this.loginbutton.TabIndex = 0;
            this.loginbutton.Text = "Login";
            this.loginbutton.UseVisualStyleBackColor = true;
            this.loginbutton.Click += new System.EventHandler(this.button1_Click);
            // 
            // signup
            // 
            this.signup.Location = new System.Drawing.Point(419, 283);
            this.signup.Name = "signup";
            this.signup.Size = new System.Drawing.Size(102, 63);
            this.signup.TabIndex = 1;
            this.signup.Text = "Registo";
            this.signup.UseVisualStyleBackColor = true;
            this.signup.Click += new System.EventHandler(this.button2_Click);
            // 
            // emaillogin
            // 
            this.emaillogin.Location = new System.Drawing.Point(253, 136);
            this.emaillogin.Multiline = true;
            this.emaillogin.Name = "emaillogin";
            this.emaillogin.Size = new System.Drawing.Size(268, 30);
            this.emaillogin.TabIndex = 2;
            // 
            // pwlogin
            // 
            this.pwlogin.Location = new System.Drawing.Point(253, 208);
            this.pwlogin.Multiline = true;
            this.pwlogin.Name = "pwlogin";
            this.pwlogin.Size = new System.Drawing.Size(268, 30);
            this.pwlogin.TabIndex = 3;
            // 
            // Login
            // 
            this.Login.Controls.Add(this.Registo);
            this.Login.Controls.Add(this.label3);
            this.Login.Controls.Add(this.label2);
            this.Login.Controls.Add(this.label1);
            this.Login.Controls.Add(this.emaillogin);
            this.Login.Controls.Add(this.loginbutton);
            this.Login.Controls.Add(this.signup);
            this.Login.Controls.Add(this.pwlogin);
            this.Login.Location = new System.Drawing.Point(12, 12);
            this.Login.Name = "Login";
            this.Login.Size = new System.Drawing.Size(776, 426);
            this.Login.TabIndex = 4;
            // 
            // Registo
            // 
            this.Registo.Controls.Add(this.Registar);
            this.Registo.Controls.Add(this.back);
            this.Registo.Controls.Add(this.button3);
            this.Registo.Controls.Add(this.label15);
            this.Registo.Controls.Add(this.label14);
            this.Registo.Controls.Add(this.nascimento);
            this.Registo.Controls.Add(this.label13);
            this.Registo.Controls.Add(this.newsletter);
            this.Registo.Controls.Add(this.label12);
            this.Registo.Controls.Add(this.sex);
            this.Registo.Controls.Add(this.label11);
            this.Registo.Controls.Add(this.label10);
            this.Registo.Controls.Add(this.label9);
            this.Registo.Controls.Add(this.lname);
            this.Registo.Controls.Add(this.fname);
            this.Registo.Controls.Add(this.contribuinte);
            this.Registo.Controls.Add(this.label8);
            this.Registo.Controls.Add(this.label7);
            this.Registo.Controls.Add(this.confirmpw);
            this.Registo.Controls.Add(this.pw);
            this.Registo.Controls.Add(this.label6);
            this.Registo.Controls.Add(this.email);
            this.Registo.Controls.Add(this.label5);
            this.Registo.Controls.Add(this.label4);
            this.Registo.Location = new System.Drawing.Point(0, 0);
            this.Registo.Name = "Registo";
            this.Registo.Size = new System.Drawing.Size(776, 426);
            this.Registo.TabIndex = 7;
            this.Registo.Visible = false;
            this.Registo.Paint += new System.Windows.Forms.PaintEventHandler(this.Registo_Paint);
            // 
            // Registar
            // 
            this.Registar.Font = new System.Drawing.Font("Courier New", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Registar.Location = new System.Drawing.Point(22, 34);
            this.Registar.Name = "Registar";
            this.Registar.Size = new System.Drawing.Size(120, 34);
            this.Registar.TabIndex = 38;
            this.Registar.Text = "Registar";
            this.Registar.UseVisualStyleBackColor = true;
            this.Registar.Click += new System.EventHandler(this.Registrar_Click);
            // 
            // back
            // 
            this.back.Font = new System.Drawing.Font("Courier New", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.back.Location = new System.Drawing.Point(657, 34);
            this.back.Name = "back";
            this.back.Size = new System.Drawing.Size(94, 34);
            this.back.TabIndex = 37;
            this.back.Text = "Voltar";
            this.back.UseVisualStyleBackColor = true;
            this.back.Click += new System.EventHandler(this.back_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(311, 390);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(153, 23);
            this.button3.TabIndex = 36;
            this.button3.Text = "Inserir Imagem";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.Location = new System.Drawing.Point(356, 364);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(62, 23);
            this.label15.TabIndex = 35;
            this.label15.Text = "Foto";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.Location = new System.Drawing.Point(80, 314);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(244, 23);
            this.label14.TabIndex = 34;
            this.label14.Text = "Data de Nascimento";
            // 
            // nascimento
            // 
            this.nascimento.Location = new System.Drawing.Point(68, 341);
            this.nascimento.MinDate = new System.DateTime(1900, 1, 1, 0, 0, 0, 0);
            this.nascimento.Name = "nascimento";
            this.nascimento.Size = new System.Drawing.Size(268, 20);
            this.nascimento.TabIndex = 33;
            this.nascimento.ValueChanged += new System.EventHandler(this.nascimento_ValueChanged);
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.Location = new System.Drawing.Point(442, 316);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(140, 23);
            this.label13.TabIndex = 32;
            this.label13.Text = "Newsletter";
            // 
            // newsletter
            // 
            this.newsletter.AutoSize = true;
            this.newsletter.Location = new System.Drawing.Point(502, 345);
            this.newsletter.Margin = new System.Windows.Forms.Padding(50);
            this.newsletter.MinimumSize = new System.Drawing.Size(10, 0);
            this.newsletter.Name = "newsletter";
            this.newsletter.Size = new System.Drawing.Size(15, 14);
            this.newsletter.TabIndex = 31;
            this.newsletter.UseVisualStyleBackColor = true;
            this.newsletter.CheckedChanged += new System.EventHandler(this.newsletter_CheckedChanged);
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.Location = new System.Drawing.Point(619, 316);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(62, 23);
            this.label12.TabIndex = 30;
            this.label12.Text = "Sexo";
            // 
            // sex
            // 
            this.sex.FormattingEnabled = true;
            this.sex.Items.AddRange(new object[] {
            "Masculino",
            "Feminino"});
            this.sex.Location = new System.Drawing.Point(589, 342);
            this.sex.Name = "sex";
            this.sex.Size = new System.Drawing.Size(125, 21);
            this.sex.TabIndex = 29;
            this.sex.SelectedIndexChanged += new System.EventHandler(this.sex_SelectedIndexChanged);
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.Location = new System.Drawing.Point(80, 253);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(244, 23);
            this.label11.TabIndex = 28;
            this.label11.Text = "Confirmar Password";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.Location = new System.Drawing.Point(498, 253);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(153, 23);
            this.label10.TabIndex = 27;
            this.label10.Text = "Último Nome";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(485, 192);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(179, 23);
            this.label9.TabIndex = 26;
            this.label9.Text = "Primeiro Nome";
            this.label9.Click += new System.EventHandler(this.label9_Click);
            // 
            // lname
            // 
            this.lname.Location = new System.Drawing.Point(446, 281);
            this.lname.Multiline = true;
            this.lname.Name = "lname";
            this.lname.Size = new System.Drawing.Size(268, 30);
            this.lname.TabIndex = 25;
            // 
            // fname
            // 
            this.fname.Location = new System.Drawing.Point(446, 218);
            this.fname.Multiline = true;
            this.fname.Name = "fname";
            this.fname.Size = new System.Drawing.Size(268, 30);
            this.fname.TabIndex = 24;
            // 
            // contribuinte
            // 
            this.contribuinte.Location = new System.Drawing.Point(446, 154);
            this.contribuinte.Multiline = true;
            this.contribuinte.Name = "contribuinte";
            this.contribuinte.Size = new System.Drawing.Size(268, 30);
            this.contribuinte.TabIndex = 23;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(498, 121);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(166, 23);
            this.label8.TabIndex = 22;
            this.label8.Text = "Contribuinte";
            this.label8.Click += new System.EventHandler(this.label8_Click_1);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(141, 192);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(114, 23);
            this.label7.TabIndex = 20;
            this.label7.Text = "Password";
            // 
            // confirmpw
            // 
            this.confirmpw.Location = new System.Drawing.Point(68, 281);
            this.confirmpw.Multiline = true;
            this.confirmpw.Name = "confirmpw";
            this.confirmpw.Size = new System.Drawing.Size(268, 30);
            this.confirmpw.TabIndex = 19;
            // 
            // pw
            // 
            this.pw.Location = new System.Drawing.Point(68, 218);
            this.pw.Multiline = true;
            this.pw.Name = "pw";
            this.pw.Size = new System.Drawing.Size(268, 30);
            this.pw.TabIndex = 18;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(164, 121);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(75, 23);
            this.label6.TabIndex = 17;
            this.label6.Text = "Email";
            // 
            // email
            // 
            this.email.Location = new System.Drawing.Point(68, 154);
            this.email.Multiline = true;
            this.email.Name = "email";
            this.email.Size = new System.Drawing.Size(268, 30);
            this.email.TabIndex = 16;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Courier New", 20.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(209, 81);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(349, 30);
            this.label5.TabIndex = 6;
            this.label5.Text = "Registo de um cliente";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Courier New", 48F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(187, 17);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(410, 69);
            this.label4.TabIndex = 5;
            this.label4.Text = "Perfumaria";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(133, 212);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(114, 23);
            this.label3.TabIndex = 6;
            this.label3.Text = "Password";
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Courier New", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(172, 140);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(75, 23);
            this.label2.TabIndex = 5;
            this.label2.Text = "Email";
            this.label2.Click += new System.EventHandler(this.label2_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Courier New", 48F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(187, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(410, 69);
            this.label1.TabIndex = 4;
            this.label1.Text = "Perfumaria";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.Login);
            this.Name = "Main";
            this.Text = "Login/Registo";
            this.Load += new System.EventHandler(this.Form2_Load);
            this.Login.ResumeLayout(false);
            this.Login.PerformLayout();
            this.Registo.ResumeLayout(false);
            this.Registo.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button loginbutton;
        private System.Windows.Forms.Button signup;
        private System.Windows.Forms.TextBox emaillogin;
        private System.Windows.Forms.TextBox pwlogin;
        private System.Windows.Forms.Panel Login;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Panel Registo;
        private System.Windows.Forms.TextBox email;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox confirmpw;
        private System.Windows.Forms.TextBox pw;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox lname;
        private System.Windows.Forms.TextBox fname;
        private System.Windows.Forms.TextBox contribuinte;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.CheckBox newsletter;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.ComboBox sex;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.DateTimePicker nascimento;
        private System.Windows.Forms.Button back;
        private System.Windows.Forms.Button Registar;
    }
}