import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aviso_esqueci_senha_model.dart';
export 'aviso_esqueci_senha_model.dart';

class AvisoEsqueciSenhaWidget extends StatefulWidget {
  const AvisoEsqueciSenhaWidget({super.key});

  @override
  State<AvisoEsqueciSenhaWidget> createState() => _AvisoEsqueciSenhaWidgetState();
}

class _AvisoEsqueciSenhaWidgetState extends State<AvisoEsqueciSenhaWidget> {
  late AvisoEsqueciSenhaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvisoEsqueciSenhaModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF8910F0);

    return Container(
      width: 360,
      height: 242,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
      ),
      padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Um link de recuperação foi enviado para o seu e-mail.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.leagueSpartan(
                        fontWeight: FontWeight.normal,
                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Colors.black,
                      fontSize: 22,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: FFButtonWidget(
              onPressed: () {
                context.pushNamed(TelaLoginWidget.routeName);
              },
              text: 'Ok',
              options: FFButtonOptions(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                color: primaryColor.withOpacity(0.8),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.leagueSpartan(
                        fontWeight: FontWeight.w600,
                        fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 20,
                    ),
                elevation: 0,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}