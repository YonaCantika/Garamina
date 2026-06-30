import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'auth_state.dart';
import 'package:provider/provider.dart';

import 'components/actionComponent.dart';
import 'components/customExpandedContainer.dart';
import 'dashboard_page.dart';
import 'notif_page.dart';
import 'akun_page.dart';
import 'dataAbsen_page.dart';
import 'components/menu.dart';
import 'components/welcome.dart';
import 'components/carousel.dart';
import 'package:garamina/services/api_services.dart';

class HistoriPage extends StatefulWidget {
  @override
  _HistoriPageState createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> historiData = [];
  int count = 0;
  bool dataResponse = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi(idPeg) async {
    count++;
    final apiUrl = Uri.parse(
        ApiServices.reportHistoryAbsen);

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'APIKEY': ApiServices.apiKey,
        },
        body: {
          "periodeTanggal":
              '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
          "idPegawai": idPeg.toString()
          // "idPegawai": "797"
        },
      );

      if (response.statusCode == 200) {
        loading = false;
        final data = jsonDecode(response.body);
        data.length <= 0 ? dataResponse = false : dataResponse = true;
        print(data);
        setState(() {
          historiData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    count < 1 ? fetchDataFromApi(authState.idPeg) : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildUserGuide(context),
              buildInformationCenter(context),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          WelcomeSection(),
          CarouselSection(),
          CustomExpandedContainer(
            title: 'Histori Absen',
            data: historiData,
            loading: loading,
            dataResponse: dataResponse,
            itemBuilder: (context, index) {
              final tanggal = historiData[index]['TANGGAL'];
              final keterangan = historiData[index]['KETERANGAN'];

              final fotoIn =
                  '${ApiServices.erpAssetsUrl}${historiData[index]['FOTO_IN']}';
              final jarakIn = historiData[index]['JARAK_IN'];
              final jamIn = historiData[index]['JAM_IN'];
              final statusAbsenIn = historiData[index]['STATUS_ABSEN_IN'];

              final fotoOut =
                  '${ApiServices.erpAssetsUrl}${historiData[index]['FOTO_OUT']}';
              final jarakOut = historiData[index]['JARAK_OUT'];
              final jamOut = historiData[index]['JAM_OUT'];
              final statusAbsenOut = historiData[index]['STATUS_ABSEN_OUT'];
              final nilaiInsentif = historiData[index]['NILAI_INSENTIF'];
              return GestureDetector(
                onTap: () {
                  _showDetailAbsen(
                    context,
                    historiData[index],
                    fotoIn,
                    fotoOut,
                    jarakIn,
                    jarakOut,
                    jamIn,
                    jamOut,
                    statusAbsenIn,
                    statusAbsenOut,
                    nilaiInsentif,
                    tanggal,
                  );
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Tanggal: $tanggal'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keterangan: $keterangan'),
                        ],
                      ),
                      trailing: Text(
                        keterangan == 'Tidak Absen' ? '🤬' : '',
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // Bagian 4: Menu dengan Icon dan Text di Bawah
      // bottomNavigationBar: BottomMenu(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: (int index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     if (index == 0) {
      //       // Navigasi ke halaman "DashboardPage"
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DashboardPage(),
      //         ),
      //       );
      //     }
      //     if (index == 2) {
      //       // Navigasi ke halaman "DashboardPage"
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DataAbsenPage(),
      //         ),
      //       );
      //     }
      //     if (index == 3) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => NotifPage(),
      //         ),
      //       );
      //     }
      //     if (index == 4) {
      //       // Navigasi ke halaman "AkunPage"
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => AkunPage(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  // ── Navy Blue Color Constants ──
  static const Color _navyDark = Color(0xFF1B2A4A);
  static const Color _navyMedium = Color(0xFF2D4373);
  static const Color _navyLight = Color(0xFF3D5A99);
  static const Color _surfaceGrey = Color(0xFFF5F7FA);
  static const Color _borderGrey = Color(0xFFE8EDF2);
  static const Color _textSecondary = Color(0xFF6B7B8D);

  void _showDetailAbsen(
    BuildContext context,
    Map<String, dynamic> data,
    String fotoIn,
    String fotoOut,
    dynamic jarakIn,
    dynamic jarakOut,
    dynamic jamIn,
    dynamic jamOut,
    dynamic statusAbsenIn,
    dynamic statusAbsenOut,
    dynamic nilaiInsentif,
    dynamic tanggal,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // ── Drag Handle ──
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ── Header ──
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_navyDark, _navyMedium],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _navyDark.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.assignment_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detail Absensi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tanggal?.toString() ?? '-',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Content ──
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Libur State
                        if (data['KETERANGAN'] == 'Libur') ...[
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _borderGrey),
                              boxShadow: [
                                BoxShadow(
                                  color: _navyDark.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/holiday.png',
                                  width: 160,
                                  height: 160,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Selamat menikmati waktu bersama keluarga, semoga sehat dan bahagia selalu 😊",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: _textSecondary,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ── Card Absen Masuk ──
                        if (data['FOTO_IN'] != null)
                          _buildAbsenCard(
                            title: 'Absen Masuk',
                            icon: Icons.login_rounded,
                            accentColor: const Color(0xFF27AE60),
                            fotoUrl: fotoIn,
                            jarak: jarakIn,
                            jam: jamIn,
                            status: statusAbsenIn,
                            nilaiInsentif: null,
                          )
                        else if (data['KETERANGAN'] == 'Masuk' ||
                            data['KETERANGAN'] == 'Tidak Absen')
                          _buildEmptyAbsenCard(
                            title: 'Absen Masuk',
                            message: 'Anda belum absen masuk!',
                            icon: Icons.login_rounded,
                          ),

                        const SizedBox(height: 14),

                        // ── Card Absen Pulang ──
                        if (data['FOTO_OUT'] != null)
                          _buildAbsenCard(
                            title: 'Absen Pulang',
                            icon: Icons.logout_rounded,
                            accentColor: const Color(0xFFE67E22),
                            fotoUrl: fotoOut,
                            jarak: jarakOut,
                            jam: jamOut,
                            status: statusAbsenOut,
                            nilaiInsentif: nilaiInsentif,
                          )
                        else if (data['KETERANGAN'] == 'Masuk' ||
                            data['KETERANGAN'] == 'Tidak Absen')
                          _buildEmptyAbsenCard(
                            title: 'Absen Pulang',
                            message: 'Anda belum absen pulang!',
                            icon: Icons.logout_rounded,
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAbsenCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required String fotoUrl,
    required dynamic jarak,
    required dynamic jam,
    required dynamic status,
    required dynamic nilaiInsentif,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: _navyDark.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _navyDark,
                  ),
                ),
                const Spacer(),
                if (status != null) _buildStatusBadge(status.toString()),
              ],
            ),
          ),

          // ── Photo ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _navyDark.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    fotoUrl,
                    height: 140,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        width: 180,
                        decoration: BoxDecoration(
                          color: _surfaceGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: _textSecondary,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ── Info Rows ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              children: [
                if (jam != null) ...[
                  _buildInfoRow(
                    Icons.access_time_rounded,
                    'Jam',
                    jam.toString().length >= 19
                        ? jam.toString().substring(11, 19)
                        : jam.toString(),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today_rounded,
                    'Tanggal',
                    jam.toString().length >= 10
                        ? jam.toString().substring(0, 10)
                        : jam.toString(),
                  ),
                ],
                if (jarak != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.location_on_rounded,
                    'Jarak',
                    '$jarak m',
                  ),
                ],
                if (nilaiInsentif != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.monetization_on_rounded,
                    'Uang Kehadiran',
                    nilaiInsentif.toString(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAbsenCard({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: _navyDark.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFE67E22), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _navyDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFE67E22),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _surfaceGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _navyLight),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _navyDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData badgeIcon;

    final statusLower = status.toLowerCase();

    if (statusLower.contains('terlambat')) {
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFD32F2F);
      badgeIcon = Icons.warning_amber_rounded;
    } else if (statusLower.contains('lebih cepat')) {
      bgColor = const Color(0xFFFFF8E1);
      textColor = const Color(0xFFF57F17);
      badgeIcon = Icons.speed_rounded;
    } else if (statusLower.contains('tepat') || statusLower.contains('hadir')) {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      badgeIcon = Icons.check_circle_outline_rounded;
    } else {
      bgColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF1565C0);
      badgeIcon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeteranganBadge(dynamic keterangan) {
    Color bgColor;
    Color textColor;

    switch (keterangan?.toString()) {
      case 'Masuk':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case 'Tidak Absen':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'Libur':
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        break;
      default:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        keterangan?.toString() ?? '-',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
