import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {

  const SignUpScreen({super.key});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}



class _SignUpScreenState extends State<SignUpScreen> {


  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true; // Variable para manejar la visibilidad de la contraseña

  Future<void> _signUp() async {

     final url = Uri.parse('http://localhost/askbem_omaima_benhamouda/assets/apis/signup.php'); // URL de la API
     final response = await http.post(
      url,
      body: json.encode({
        'nom': _nameController.text,
        'cognoms': _surnameController.text,
        'correu': _emailController.text,
        'contrasenya': _passwordController.text,
        // Suponiendo que el rol se puede establecer en el servidor o por defecto es 'alumne'.
        'rol': 'alumne', 
      }),
      headers: {'Content-Type': 'application/json'},
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['message'] == 'Usuario registrado exitosamente') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro exitoso')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${data['message']}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión')));
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                 Image.asset(
                    'images/logo.png',  // Ruta de la imagen en tus assets
                ),
                                const SizedBox(height: 20),

                // Título
                Text(
                  'Crea un compte',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // Campos de formulario
                _buildNameInputs(),
                const SizedBox(height: 20),
                _buildEmailInput(),
                const SizedBox(height: 20),
                _buildPasswordInput(),
                const SizedBox(height: 30),

                // Botón de Registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: const Color(0xFF4361EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Radius de 20
                      ), // Color del botón
                    ),
                    child: Text(
                      "Registra't",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Separador
                Row(children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('O', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ]),
                const SizedBox(height: 25),

                // Botón Google
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                        onPressed: () {},
                        label: Text(
                        "Registra't amb Google",
                        style: GoogleFonts.montserrat(        
                            color: Color(0xFF36454F),
),
                        ),
                        icon: Image.asset('images/google.png', width: 24),
                        style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Radius de 20
                        ),
                        ),
                    ),
                    )
                    ,
            
                const SizedBox(height: 30),

                // Enlace Login
                TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      text: 'Tens un compte? ',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFF36454F),
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF3F8CFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



 

  Widget _buildNameInputs() {
    return Column(
      children: [
        // Input para Nombre
        TextFormField(
         controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nom',
              labelStyle: TextStyle(
              color: Color(0x8036454F), // Color con 50% de transparencia
                              fontSize: 12, // Aquí ajustas el tamaño del texto

                ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: SizedBox(
            width: 40,  // Ajusta el tamaño según lo necesites
            height: 40, // Ajusta el tamaño según lo necesites
            child: const Icon(Icons.person_outline),
            ),            
            filled: true,
            fillColor: const Color(0xFFDEE2E6), // Color de fondo
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Radio de 20
            borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Radio de 20
            borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
        ),
          ),
          style: GoogleFonts.montserrat( fontSize: 12,),
        ),
        const SizedBox(height: 15),
        // Input para Apellidos
        TextFormField(
        controller: _surnameController,
          decoration: InputDecoration(
            labelText: 'Cognoms',
            labelStyle: TextStyle(
              color: Color(0x8036454F), // Color con 50% de transparencia
                              fontSize: 12, // Aquí ajustas el tamaño del texto

                ),

            prefixIcon: const Icon(Icons.people_alt_outlined,color: Color(0xFF36454F),
),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: const Color(0xFFDEE2E6), // Color de fondo
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Radio de 20
            borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
        ),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Radio de 20
            borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
        ),
          ),
          style: GoogleFonts.montserrat( fontSize: 12,),
        ),
      ],
    );
  }


Widget _buildEmailInput() {
  return TextFormField(
     controller: _emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(
              color: Color(0x8036454F), // Color con 50% de transparencia
                              fontSize: 12, // Aquí ajustas el tamaño del texto

                ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      prefixIcon: const Icon(Icons.email_outlined),
      filled: true,
      fillColor: const Color(0xFFDEE2E6), // Color de fondo
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Radio de 20
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Radio de 20
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
    ),
    style: GoogleFonts.montserrat( fontSize: 12,),
  );
}


  Widget _buildPasswordInput() {
    return TextFormField(
    controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Contrasenya',
        
        labelStyle: TextStyle(
              color: Color(0x8036454F), // Color con 50% de transparencia

                fontSize: 12, // Aquí ajustas el tamaño del texto
                ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;  // Cambiar el estado de la contraseña visible/oculta
          });
        },
      ),
        filled: true,
        fillColor: const Color(0xFFDEE2E6), // Color de fondo
          enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Radio de 20
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // Radio de 20
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
      ),
    
style: GoogleFonts.montserrat(fontSize: 12),
           // Tamaño del texto ingresado por el usuario

    );
  }
}
