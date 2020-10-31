using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	class Func
	{
		private String email;
		private String contribuinte;
		private String fname;
		private String lname;
		private bool sexo;
		private String dataNasc;
		private String foto;
		private int contacto_default_id;
		private int administrador;
		private int salario;
		private bool deleted;

		public string Email { get => email; set => email = value; }
		public string Contribuinte { get => contribuinte; set => contribuinte = value; }
		public string Fname { get => fname; set => fname = value; }
		public string Lname { get => lname; set => lname = value; }
		public bool Sexo { get => sexo; set => sexo = value; }
		public string DataNasc { get => dataNasc; set => dataNasc = value; }
		public string Foto { get => foto; set => foto = value; }
		public int Contacto_default_id { get => contacto_default_id; set => contacto_default_id = value; }
		public int Administrador { get => administrador; set => administrador = value; }
		public int Salario { get => salario; set => salario = value; }
		public bool Deleted { get => deleted; set => deleted = value; }
	}
}
