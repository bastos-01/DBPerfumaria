using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Perfumaria
{
    static class Program
    {

        public static bool OpenClient { get; set; }
        public static bool OpenFunc { get; set; }
        public static String ClientMail { get; set; }
        public static String FuncMail { get; set; }

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            OpenClient = false;
            OpenFunc = false;
            Application.Run(new Main());

            if (OpenClient)
            {
                if (ClientMail != null)
                    Application.Run(new Cliente());

            } else if(OpenFunc)
            {
                if(FuncMail!=null)
                    Application.Run(new Funcionario());
            }
        }

    }

}
