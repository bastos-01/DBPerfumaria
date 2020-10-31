using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Perfumaria
{
    public partial class Funcionario : Form
    {
        private SqlConnection cn;
        private Func fc = new Func();
        private Compra Compra = new Compra();
        private List<Produto> ProdutosList = new List<Produto>();
        private Produto prod = new Produto();
        private int idmarc;
        private String cliente_email;
        private String func_email;
        private int servico_id;
        public Funcionario()
        {
            InitializeComponent();
            tabControl1.SelectedIndexChanged += new EventHandler(tabControl1_SelectedIndexChanged);
            contafunc.SelectedIndexChanged += new EventHandler(contafunc_SelectedIndexChanged);
            historico.SelectedIndexChanged += new EventHandler(historico_SelectedIndexChanged);
            detalhesvenda.SelectedIndexChanged += new EventHandler(detalhesvenda_SelectedIndexChanged);
            promotab.SelectedIndexChanged += new EventHandler(promocoes_SelectedIndexChanged);
            functab.SelectedIndexChanged += new EventHandler(funcs_SelectedIndexChanged);
        }

        private void Funcionario_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            if (verifySGBDConnection())
            {
                Console.WriteLine("Conexão");
                loadInfo(Program.FuncMail);
                showMainInfo();
            }
            else
            {
                Console.WriteLine("NOP");
            }

            cn.Close();

            

        }

        private SqlConnection getSGBDConnection()
        {
            String dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            String dbName = "p6g1";
            String userName = "p6g1";
            String userPass = "almeidapaiva1@Bd";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void showMainInfo()
        {
            email.Text = fc.Email;
            fname.Text = fc.Fname;
            lname.Text = fc.Lname;
            salario.Text = fc.Salario.ToString();
            foto.Load(fc.Foto);
            foto.SizeMode = PictureBoxSizeMode.StretchImage;

        }

        private void loadInfo(String mail)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getFuncInfo ('" + mail + "')", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            reader.Read();

            fc.Email = reader["email"].ToString();
            fc.Contribuinte = reader["contribuinte"].ToString();
            fc.Fname = reader["fname"].ToString();
            fc.Lname = reader["lname"].ToString();
            fc.Sexo = (bool)reader["sexo"];
            fc.DataNasc = reader["dataNasc"].ToString();
            if (!DBNull.Value.Equals(reader["contacto_default_id"]))
                fc.Contacto_default_id = (int)reader["contacto_default_id"];
            fc.Administrador = (byte)reader["administrator"];
            fc.Salario = (int)reader["salario"];
            fc.Foto = reader["foto"].ToString();

            cn.Close();

        }

        private void tabControl1_SelectedIndexChanged(Object sender, EventArgs e)
        {

            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    contafunc_SelectedIndexChanged(contafunc, null);
                    break;
                case 1:
                    historico_SelectedIndexChanged(historico, null);
                    break;
                case 2:
                    orderdescasc.SelectedIndex = 0;
                    orderby.SelectedIndex = 0; 
                    getProductsProperties();
                    marcacombo.SelectedIndex = 0;
                    categoriacombo.SelectedIndex = 0;
                    searchProducts();
                    lojagrid.DataSource = ProdutosList.Select(o => new
                    { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco, Deleted = o.Deleted }).ToList();
                    break;
                case 3:
                    marcacoesgrid.DataSource = getFuncMarcacoes();
                    break;
                case 4:
                    cupoesgrid.DataSource = getCupoes();
                    break;
                case 5:
                    promocoes_SelectedIndexChanged(promotab, null);
                    break;
                case 6:
                    funcs_SelectedIndexChanged(functab, null);
                    break;
                case 7:
                    servicosgrid.DataSource = getServicos();
                    break;

            }
        }

        private DataTable getServicos()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getAllServices ()", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private DataTable getCupoes()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getCupons ()", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private DataTable getFuncMarcacoes()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.funcFutureMarc ('" + fc.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private void addproduto_Click(object sender, EventArgs e)
        {
            paineladdproduto.Visible = true;
        }

        private void contafunc_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    break;
                case 1:
                    contactsgrid.DataSource = getFuncContacts();
                    break;
            }


        }

        private DataTable getFuncContacts()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientContacts ('" + fc.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }


        private void sellHistory_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == sellHistory.Columns["Detalhes"].Index && e.RowIndex >= 0)
            {
                selectPanel((int)sellHistory.Rows[e.RowIndex].Cells[4].Value);

            }
        }

        private void historico_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    sellHistory.DataSource = getFuncSellHistory();
                    break;
                case 1:
                    funcservicos.DataSource = getFuncServicesHistory();
                    break;
            }


        }

        private void detalhesvenda_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    break;
                case 1:
                    produtosvenda.DataSource = getProductsSell();
                    break;
            }


        }

        private void promocoes_SelectedIndexChanged(Object sender, EventArgs e)
        {
            
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    break;
                case 1:
                    promocoesgrid.DataSource = getPromocoes();
                    break;
            }


        }
        private void funcs_SelectedIndexChanged(Object sender, EventArgs e)
        {

            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    funcsgrid.DataSource = getFuncs();
                    break;
                case 1:
                    break;
            }


        }

        private DataTable getFuncs()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getAllFuncs ('" + fc.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;
        }

        private DataTable getPromocoes()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getPromocoes ()", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;
        }

        private DataTable getFuncSellHistory()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.funcSellHistory ('" + fc.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private DataTable getProductsSell()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getProductsFromBuy ('" + Compra.Numero + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private DataTable getFuncServicesHistory()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.funcServicesHistory ('" + fc.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }


        private void selectPanel(int compra)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.getDetailsFromSell", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@numero", compra);


            try
            {
                SqlDataReader reader = cmd.ExecuteReader();

                reader.Read();

                Compra.Cliente = reader["clienteemail"].ToString();
                Compra.Pagamento = reader["pagamento"].ToString();
                Compra.Contribuinte = reader["contribuinte"].ToString();
                Compra.Numero = (int)reader["numero"];
                Compra.Datacompra = reader["datacompra"].ToString();


             
                compraPresencialDetalhes();

             



            }
            catch (Exception ex)
            {
                throw new Exception("Failed to get vendas. \n ERROR MESSAGE: \n" + ex.Message);
            }



            cn.Close();

        }

        public void compraPresencialDetalhes()
        {
            compraoffline.Visible = true;
            datacompraoff.Text = Compra.Datacompra;
            numcompraoff.Text = Compra.Numero.ToString();
            clientecompraoff.Text = Compra.Cliente;
            contribuintecompraoff.Text = Compra.Contribuinte;
            pagamentocompraoff.Text = Compra.Pagamento;
        }

        private void fecharoffline_Click(object sender, EventArgs e)
        {
            compraoffline.Visible = false;
        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        private void label33_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void getProductsProperties()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");
            SqlCommand cmd = new SqlCommand("SELECT DISTINCT marca FROM perf.getAllProducts ()", cn);
            SqlDataReader reader = cmd.ExecuteReader();
            marcacombo.Items.Clear();
            marcacombo.Items.Add("Todos");
            while (reader.Read())
            {
                marcacombo.Items.Add(reader["marca"].ToString());
            };
            reader.Close();
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");
            cmd = new SqlCommand("SELECT DISTINCT categoria FROM perf.getAllProducts ()", cn);
            reader = cmd.ExecuteReader();
            categoriacombo.Items.Clear();
            categoriacombo.Items.Add("Todos");
            while (reader.Read())
            {
                categoriacombo.Items.Add(reader["categoria"].ToString());
            };
            reader.Close();

            cn.Close();
        }

        private void searchProducts()
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.getProductFiltersFunc", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            if (!pesquisa.Text.Equals("") && !pesquisa.Text.Equals("Pesquisar..."))
            {
                cmd.Parameters.AddWithValue("@nome", pesquisa.Text);
            }
            if (marcacombo.SelectedIndex > 0)
            {
                cmd.Parameters.AddWithValue("@marca", marcacombo.SelectedItem.ToString());
            }
            if (categoriacombo.SelectedIndex > 0)
            {
                cmd.Parameters.AddWithValue("@categoria", categoriacombo.SelectedItem.ToString());
            }

            if (orderby.SelectedIndex > -1)
            {
                cmd.Parameters.AddWithValue("@orderby", orderby.SelectedItem.ToString());
            }
            if (orderdescasc.SelectedIndex > -1)
            {
                cmd.Parameters.AddWithValue("@ordem", orderdescasc.SelectedItem.ToString());
            }
            SqlDataReader reader = cmd.ExecuteReader();
            ProdutosList.Clear();
            while (reader.Read())
            {
                Produto P = new Produto();
                P.Id = (int)reader["id"];
                P.Preco = (double)reader["preco"];
                if (!DBNull.Value.Equals(reader["familiaolfativa"]))
                    P.Familiaolfativa = reader["familiaolfativa"].ToString();
                P.Categoria = reader["categoria"].ToString();
                P.Nome = reader["nome"].ToString();
                P.Marca = reader["marca"].ToString();
                P.Linha = reader["linha"].ToString();
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Tamanho = Convert.ToInt16(reader["tamanho"]);
                if (!DBNull.Value.Equals(reader["descricao"]))
                    P.Descricao = reader["descricao"].ToString();
                P.Imagem = reader["imagem"].ToString();
                P.Stock = Convert.ToInt16(reader["stock"]);
                if (!DBNull.Value.Equals(reader["destinatario"]))
                    P.Destinatario = reader["destinatario"].ToString();
                P.Deleted = (bool)reader["deleted"];
                ProdutosList.Add(P);
            }
            cn.Close();
        }

        private void botaopesquisar_Click(object sender, EventArgs e)
        {
            searchProducts();
            lojagrid.DataSource = ProdutosList.Select(o => new
            { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco, Deleted = o.Deleted }).ToList();
        }

        private void label36_Click(object sender, EventArgs e)
        {

        }

        private void addcheck_Click(object sender, EventArgs e)
        {
            if(addnome.Text == "" || addpreco.Text == "" || addmarca.Text == "" || addstock.Text == "" || addimagem.Text == "" || addcat.Text == "" || addlinha.Text == "")
            {
                MessageBox.Show("Introduza os parâmetros obrigatórios!");
            }
            else
            {
                if (!verifySGBDConnection())
                    return;
                SqlCommand cmd = new SqlCommand("perf.addProduct", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@emailFunc", fc.Email);
                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                prod.Nome = addnome.Text;
                cmd.Parameters.AddWithValue("@nome", addnome.Text);

                prod.Preco = double.Parse(addpreco.Text, System.Globalization.CultureInfo.InvariantCulture);
                cmd.Parameters.AddWithValue("@preco", addpreco.Text);

                prod.Marca = addmarca.Text;
                cmd.Parameters.AddWithValue("@marca", addmarca.Text);

                prod.Stock = Convert.ToInt32(addstock.Text);
                cmd.Parameters.AddWithValue("@stock", addstock.Text);

                if (adddesc.Text != "")
                {
                    prod.Descricao = adddesc.Text;
                    cmd.Parameters.AddWithValue("@descricao", adddesc.Text);
                }
              
                prod.Imagem = addimagem.Text;
                cmd.Parameters.AddWithValue("@imagem", addimagem.Text);

                if (addtamanho.Text != "")
                {
                    prod.Tamanho = Convert.ToInt32(addtamanho.Text);
                    cmd.Parameters.AddWithValue("@tamanho", addtamanho.Text);
                }
                    
                prod.Categoria = addcat.Text;
                cmd.Parameters.AddWithValue("@categoria", addcat.Text);

                prod.Linha = addlinha.Text;
                cmd.Parameters.AddWithValue("@linha", addlinha.Text);

                if (addsexo.Text != "")
                {
                    prod.Destinatario = addsexo.Text;
                    cmd.Parameters.AddWithValue("@destinatario", addsexo.Text);
                }
                    
                if (addfamilia.Text != "")
                {
                    prod.Familiaolfativa = addfamilia.Text;
                    cmd.Parameters.AddWithValue("@familiaolfativa", addfamilia.Text);
                }

                SqlDataReader reader = cmd.ExecuteReader();
                reader.Read();
                reader.Close();


                paineladdproduto.Visible = false;
                addnome.Text = "";
                addpreco.Text = "";
                addmarca.Text = "";
                addstock.Text = "";
                adddesc.Text = "";
                addimagem.Text = "";
                addtamanho.Text = "";
                addcat.Text = "";
                addlinha.Text = "";
                addsexo.Text = "";
                addfamilia.Text = "";

                searchProducts();
                lojagrid.DataSource = ProdutosList.Select(o => new
                { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco, Deleted = o.Deleted }).ToList();



            }
        }

        private void fecharadd_Click(object sender, EventArgs e)
        {
            paineladdproduto.Visible = false;
        }

        private void lojagrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            altpanel.Visible = true;
            if (e.ColumnIndex == lojagrid.Columns["changeproduct"].Index && e.RowIndex >= 0)
            {
                prod = ProdutosList.ElementAt(e.RowIndex);
            }
        }

        private void alterarfechar_Click(object sender, EventArgs e)
        {
            altpanel.Visible = false;
        }

        private void alterarcheck_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.changeProduct", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);
            cmd.Parameters.AddWithValue("@id",prod.Id);

            if (altnome.Text != "")
            {
                cmd.Parameters.AddWithValue("@nome", altnome.Text);
            }
            if (altpreco.Text != "")
            {
                cmd.Parameters.AddWithValue("@preco", altpreco.Text);
            }
            if (altmarca.Text != "")
            {
                cmd.Parameters.AddWithValue("@marca", altmarca.Text);
            }
            if (altstock.Text != "")
            {
                cmd.Parameters.AddWithValue("@stock", altstock.Text);
            }
            if (altdesc.Text != "")
            {
                cmd.Parameters.AddWithValue("@descricao", altdesc.Text);
            }
            if (altimagem.Text != "")
            {
                cmd.Parameters.AddWithValue("@imagem", altimagem.Text);
            }
            if (alttamanho.Text != "")
            {
                cmd.Parameters.AddWithValue("@tamanho", alttamanho.Text);
            }
            if (altcat.Text != "")
            {
                cmd.Parameters.AddWithValue("@categoria", altcat.Text);
            }
            if (altlinha.Text != "")
            {
                cmd.Parameters.AddWithValue("@linha", altlinha.Text);
            }
            if (altdest.Text != "")
            {
                cmd.Parameters.AddWithValue("@destinatario", altdest.Text);
            }
            if (altfam.Text != "")
            {
                cmd.Parameters.AddWithValue("@familiaolfativa", altfam.Text);
            }
            if(deleteproduct.Checked == true)
            {
                cmd.Parameters.AddWithValue("@deleted", 1);
            }
            else
            {
                cmd.Parameters.AddWithValue("@deleted", 0);
            }

            SqlDataReader reader = cmd.ExecuteReader();
            reader.Read();
            reader.Close();

            altpanel.Visible = false;
            altnome.Text = "";
            altpreco.Text = "";
            altmarca.Text = "";
            altstock.Text = "";
            altdesc.Text = "";
            altimagem.Text = "";
            alttamanho.Text = "";
            altcat.Text = "";
            altlinha.Text = "";
            altdest.Text = "";
            altfam.Text = "";
            deleteproduct.Checked = false;

            searchProducts();
            lojagrid.DataSource = ProdutosList.Select(o => new
            { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco, Deleted = o.Deleted }).ToList();

        }

        private void altpanel_Paint(object sender, PaintEventArgs e)
        {

        }

        private void marcacoesgrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            idmarc = (int)marcacoesgrid.Rows[e.RowIndex].Cells[7].Value;
            cliente_email = marcacoesgrid.Rows[e.RowIndex].Cells[1].ToString();
            altmarc.Visible = true;

        }

        private void label58_Click(object sender, EventArgs e)
        {

        }

        private void altbotao_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.updateMarc", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idMarc", idmarc);
            cmd.Parameters.AddWithValue("@funcionario_email", fc.Email);
            cmd.Parameters.AddWithValue("@cliente_email", cliente_email);
           
            datamarc.Format = DateTimePickerFormat.Custom;
            datamarc.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            datamarc.MinDate = DateTime.Now;
            if (datamarc.Value != DateTime.Now)
            {
                DateTime dt = datamarc.Value;
                cmd.Parameters.AddWithValue("@dataMarc", dt.ToString("yyyy-MM-dd HH:mm:ss.fff"));
            }
           
            cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;

            cmd.ExecuteNonQuery();
            MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

            marcacoesgrid.DataSource = getFuncMarcacoes();
        }

        private void altfechar_Click(object sender, EventArgs e)
        {
            altmarc.Visible = false;
        }

        private void addcupao_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.addCupon", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);

            datainiciocupao.Format = DateTimePickerFormat.Custom;
            datainiciocupao.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            datainiciocupao.MinDate = DateTime.Now;
            datafimcupao.Format = DateTimePickerFormat.Custom;
            datafimcupao.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            datafimcupao.MinDate = DateTime.Now;
            Console.WriteLine(datainiciocupao.Value);
            Console.WriteLine(datafimcupao.MinDate);

            if (datainiciocupao.Value == datafimcupao.MinDate || datafimcupao.Value == datafimcupao.MinDate || idcupao.Text == "" || pontoscupao.Text == "")
                MessageBox.Show("Preencha todos os campos!");
            else if (idcupao.Text.Length != 10)
                MessageBox.Show("ID tem de ter 10 caracteres!");
            else
            {
                DateTime dt = datainiciocupao.Value;
                cmd.Parameters.AddWithValue("@datainicio", dt.ToString("yyyy-MM-dd HH:mm:ss.fff"));

                DateTime dt1 = datafimcupao.Value;
                cmd.Parameters.AddWithValue("@datafim", dt1.ToString("yyyy-MM-dd HH:mm:ss.fff"));

                cmd.Parameters.AddWithValue("@id", idcupao.Text);
                cmd.Parameters.AddWithValue("@pontos_atribuidos", pontoscupao.Text);

                cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();
                MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

                if (cmd.Parameters["@responseMessage"].Value.ToString() == "Success")
                {
                    cupoesgrid.DataSource = getCupoes();
                }

            }
        



           

            
        }

        private void label56_Click(object sender, EventArgs e)
        {

        }

        private void addpromobotao_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.addPromotion", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);

            addpromoinicio.Format = DateTimePickerFormat.Custom;
            addpromoinicio.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            addpromoinicio.MinDate = DateTime.Now;
            addpromofim.Format = DateTimePickerFormat.Custom;
            addpromofim.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            addpromofim.MinDate = DateTime.Now;

            if (addpromonome.Text == "" || addpromodesc.Text == "" || addpromoinicio.Value == addpromoinicio.MinDate || addpromofim.Value == addpromofim.MinDate)
                MessageBox.Show("Preencha todos os campos!");
            else
            {
                cmd.Parameters.AddWithValue("@nome", addpromonome.Text);
                String t = addpromodesc.Text;
                int temp = Convert.ToInt32(t);
                cmd.Parameters.AddWithValue("@desconto", (byte) temp);
                DateTime dt = addpromoinicio.Value;
                cmd.Parameters.AddWithValue("@datainicio", dt.ToString("yyyy-MM-dd HH:mm:ss.fff"));

                DateTime dt1 = addpromofim.Value;
                cmd.Parameters.AddWithValue("@datafim", dt1.ToString("yyyy-MM-dd HH:mm:ss.fff"));

                cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();
                MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

                if (cmd.Parameters["@responseMessage"].Value.ToString() == "Success")
                {
                    addpromonome.Text = "";
                    addpromodesc.Text = "";
                    addpromoinicio.Value = DateTime.Now;
                    addpromofim.Value = DateTime.Now;
                }


            }
        }

        private void funcsgrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            altfpanel.Visible = true;
            func_email = funcsgrid.Rows[e.RowIndex].Cells[1].Value.ToString();

        }

        private void altffechar_Click(object sender, EventArgs e)
        {
            altfpanel.Visible = false;
        }

        private void altfbotao_Click(object sender, EventArgs e)
        {
            
            
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.updateFunc", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@email", fc.Email);
            cmd.Parameters.AddWithValue("@emailOP", func_email);
            cmd.Parameters.Add("@responseMsg", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;

            if (altsalario.Text != "")
                cmd.Parameters.AddWithValue("@salario", altsalario.Text);
            if (altadmin.Text != "")
                cmd.Parameters.AddWithValue("@admin", altadmin.Text);

            cmd.ExecuteNonQuery();
            MessageBox.Show(cmd.Parameters["@responseMsg"].Value.ToString());

            if (cmd.Parameters["@responseMsg"].Value.ToString() == "Success")
            {
                altadmin.SelectedIndex = 0;
                altsalario.Text = "";
                altfpanel.Visible = false;
                funcsgrid.DataSource = getFuncs();
            }

        }

        private void newfunc_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.addNewFunc", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);
            cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;

            adddatanasc.Format = DateTimePickerFormat.Custom;
            adddatanasc.CustomFormat = "yyyy-MM-dd HH:mm:ss";
            adddatanasc.MinDate = DateTime.Now;

            if (addfemail.Text == "" || pw1.Text == "" || pw2.Text == "" || addffoto.Text == "" || cont.Text == "" || addfname.Text == "" || addlname.Text == "" || addsalario.Text == "" || addadmin.Text == "" || addfsexo.Text == "")
                MessageBox.Show("Preencha os campos todos!");
            else if (!pw1.Text.Equals(pw2.Text))
                MessageBox.Show("Password mal confirmada!");
            else
            {
                cmd.Parameters.AddWithValue("@email", addfemail.Text);
                cmd.Parameters.AddWithValue("@pw", pw1.Text);
                cmd.Parameters.AddWithValue("@foto", addffoto.Text);
                cmd.Parameters.AddWithValue("@contribuinte", cont.Text);
                cmd.Parameters.AddWithValue("@fname", addfname.Text);
                cmd.Parameters.AddWithValue("@lname", addlname.Text); 
                cmd.Parameters.AddWithValue("@salario", addsalario.Text);
                cmd.Parameters.AddWithValue("@administrator", addadmin.Text);
                Boolean sexo = false;
                if (addfsexo.Text == "Masculino")
                    sexo = true;
                cmd.Parameters.AddWithValue("@sexo", sexo);
                DateTime dt1 = adddatanasc.Value;
                cmd.Parameters.AddWithValue("@dataNasc", dt1.ToString("yyyy-MM-dd HH:mm:ss.fff"));

                cmd.ExecuteNonQuery();
                MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

                if (cmd.Parameters["@responseMessage"].Value.ToString() == "Success")
                {
                    addfemail.Text = "";
                    pw1.Text = "";
                    pw2.Text = "";
                    addffoto.Text = "";
                    cont.Text = "";
                    addfname.Text = "";
                    addlname.Text = "";
                    addsalario.Text = "";
                    addadmin.Text = "";
                    addfsexo.Text = "";
                    adddatanasc.Value = DateTime.Now;
                }

            }
        }

        private void addservbotao_Click(object sender, EventArgs e)
        {
            addnewservico.Visible = true;
            
 
        }

        private void addservcheck_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.addService", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);
            cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;

            if (addservtipo.Text == "" || addservpreco.Text == "")
                MessageBox.Show("Introduza os campos todos!");
            else
            {
                cmd.Parameters.AddWithValue("@tipo", addservtipo.Text);
                cmd.Parameters.AddWithValue("@preco", addservpreco.Text);

                cmd.ExecuteNonQuery();
                MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

                if (cmd.Parameters["@responseMessage"].Value.ToString() == "Success")
                {
                    addservtipo.Text = "";
                    addservpreco.Text = "";
                    addnewservico.Visible = false;
                    servicosgrid.DataSource = getServicos();

                }
            }
        }

        private void newservfechar_Click(object sender, EventArgs e)
        {
            addnewservico.Visible = false;
        }

        private void servicosgrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == servicosgrid.Columns["servfuncs"].Index && e.RowIndex >= 0)
            {
                servico_id = (int)servicosgrid.Rows[e.RowIndex].Cells[1].Value;
                servicefuncs.Visible = true;
                servfuncsgrid.DataSource = getServFuncs();
            }
                

        }

        private DataTable getServFuncs()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getServiceFuncs ('" + servico_id + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private void servfuncsfechar_Click(object sender, EventArgs e)
        {
            servicefuncs.Visible = false;
        }

        private void addfuncservbotao_Click(object sender, EventArgs e)
        {
            addfuncservpanel.Visible = true;

        }

        private void addfuncservfechar_Click(object sender, EventArgs e)
        {
            addfuncservpanel.Visible = false;
        }

        private void addfuncservcheck_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand("perf.addFuncService", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@emailFunc", fc.Email);
            cmd.Parameters.AddWithValue("@servico_id", servico_id);
            cmd.Parameters.Add("@responseMessage", SqlDbType.NVarChar, 250).Direction = ParameterDirection.Output;

            if (addfuncservmail.Text == "" || addfuncservduracao.Text == "" || funcservdel.Text == "")
                MessageBox.Show("Introduza os parametros!");
            else
            {
                cmd.Parameters.AddWithValue("@deleted", funcservdel.Text);
                cmd.Parameters.AddWithValue("@funcionario_email", addfuncservmail.Text);
                cmd.Parameters.AddWithValue("@duracao_media", addfuncservduracao.Text);

                cmd.ExecuteNonQuery();
                MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());

                if (cmd.Parameters["@responseMessage"].Value.ToString() == "Success")
                {
                    addfuncservmail.Text = "";
                    addfuncservduracao.Text = "";
                    addfuncservpanel.Visible = false;
                    servfuncsgrid.DataSource = getServFuncs();

                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            changepw.Visible = true;
        }

        private void cancel_Click(object sender, EventArgs e)
        {
            changepw.Visible = false;
        }

        private void change_Click(object sender, EventArgs e)
        {
            if (newpw.Text.Equals(newpw2.Text))
            {

                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.updateFunc", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@email", fc.Email);
                cmd.Parameters.AddWithValue("@pw", newpw2.Text);
                cmd.Parameters.Add("@responseMsg", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMsg"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute.");
                }
                finally
                {

                    MessageBox.Show(rm);


                }


                cn.Close();

            }
            else
                MessageBox.Show("Palavra-Passes diferentes!");
        }
    }
}
