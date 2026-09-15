import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
void main() => runApp(const NattileServiceApp());

class NattileServiceApp extends StatelessWidget {
  const NattileServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'നാട്ടിലെ Service',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class Service {
  final String name, emoji;
  const Service(this.name, this.emoji);
}

const services = [
  Service('പ്ലമ്പർ', '🔧'),
  Service('ഇലക്ട്രീഷ്യൻ', '⚡'),
  Service('A/C & Fridge Technician', '❄️'),
  Service('പെയിന്റർ', '🎨'),
  Service('കാർപ്പെന്റർ', '🪚'),
  Service('Car / Bike Service', '🚗'),
];

class Worker {
  final String name, location, experience, phone;
  final double rating;
  final String service;
  const Worker(this.name, this.location, this.experience, this.phone, this.rating, this.service);
}

final List<Worker> workers = [
  Worker('അനിൽ കുമാർ', 'തൃശൂർ', '8 വർഷം', '9999999999', 4.8, 'പ്ലമ്പർ'),
  Worker('ഷാജി', 'ഒല്ലൂർ', '6 വർഷം', '9888888888', 4.7, 'പ്ലമ്പർ'),
  Worker('രമേഷ്', 'കൂർക്കഞ്ചേരി', '10 വർഷം', '9777777777', 4.9, 'ഇലക്ട്രീഷ്യൻ'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('നാട്ടിലെ Service', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Worker Registration',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationPage())),
            icon: const Icon(Icons.person_add_alt_1),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.green),
              title: const Text('നിങ്ങളുടെ സ്ഥലം'),
              subtitle: const Text('തൃശൂർ'),
              trailing: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          const SizedBox(height: 18),
          const Text('ഏത് സേവനമാണ് വേണ്ടത്?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.18,
            ),
            itemBuilder: (context, i) {
              final s = services[i];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    if (s.name == 'Car / Bike Service') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VehicleChoicePage()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => WorkerListPage(service: s.name)));
                    }
                  },
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(s.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationPage())),
            icon: const Icon(Icons.handyman),
            label: const Text('ഞാനും ഒരു Service Provider ആണ്'),
          ),
        ],
      ),
    );
  }
}

class VehicleChoicePage extends StatelessWidget {
  const VehicleChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car / Bike Service')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text('സേവനം തിരഞ്ഞെടുക്കുക', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _choice(context, '🚗', 'കാർ സർവീസ്'),
          const SizedBox(height: 16),
          _choice(context, '🏍️', 'ബൈക്ക് സർവീസ്'),
        ]),
      ),
    );
  }

  Widget _choice(BuildContext context, String emoji, String title) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(18),
      leading: Text(emoji, style: const TextStyle(fontSize: 38)),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkerListPage(service: title))),
    ),
  );
}

class WorkerListPage extends StatelessWidget {
  final String service;
  const WorkerListPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final list = workers.where((w) => w.service == service).toList();
    return Scaffold(
      appBar: AppBar(title: Text(service)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text('ഇപ്പോൾ ഈ വിഭാഗത്തിൽ രജിസ്റ്റർ ചെയ്ത സേവനദാതാക്കൾ ഇല്ല.')),
            )
          else
            ...list.map((w) => WorkerCard(worker: w)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationPage())),
            icon: const Icon(Icons.person_add),
            label: Text('ഞാനും ഒരു ${service == "പ്ലമ്പർ" ? "പ്ലമ്പർ" : "Service Provider"} ആണ്'),
          ),
        ],
      ),
    );
  }
}

class WorkerCard extends StatelessWidget {
  final Worker worker;
  const WorkerCard({super.key, required this.worker});

  Future<void> _call() async {
    final uri = Uri.parse('tel:${worker.phone}');
    await launchUrl(uri);
  }

  Future<void> _whatsapp() async {
    final uri = Uri.parse('https://wa.me/91${worker.phone}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person, size: 30)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(worker.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('📍 ${worker.location}'),
            Text('⭐ ${worker.rating}  •  ${worker.experience}'),
          ])),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: FilledButton.icon(onPressed: _call, icon: const Icon(Icons.call), label: const Text('വിളിക്കുക'))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(onPressed: _whatsapp, icon: const Icon(Icons.chat), label: const Text('വാട്സ്ആപ്പ്'))),
        ]),
      ]),
    ),
  );
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _form = GlobalKey<FormState>();
  bool confirmed = false;XFile? profilePhoto;
Future<void> _pickPhoto() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    setState(() => profilePhoto = picked);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Provider Registration')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('നിങ്ങളുടെ വിവരങ്ങൾ നൽകുക', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _field('പേര്', Icons.person),
            _field('ഫോൺ നമ്പർ', Icons.phone, keyboard: TextInputType.phone),
            _field('സ്ഥലം', Icons.location_on),
            _field('എത്ര വർഷത്തെ പരിചയം?', Icons.work, keyboard: TextInputType.number),
            _field('ചെയ്യുന്ന സേവനങ്ങൾ', Icons.handyman, maxLines: 3),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: _pickPhoto, icon: const Icon(Icons.photo_camera), label: const Text('Profile Photo ചേർക്കുക')),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: confirmed,
              onChanged: (v) => setState(() => confirmed = v ?? false),
              title: const Text('ഞാൻ നൽകിയ വിവരങ്ങൾ ശരിയാണെന്ന് സ്ഥിരീകരിക്കുന്നു'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                if (_form.currentState!.validate() && confirmed) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('രജിസ്ട്രേഷൻ സമർപ്പിച്ചു!')));
                } else if (!confirmed) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ദയവായി confirmation തിരഞ്ഞെടുക്കുക.')));
                }
              },
              child: const Text('രജിസ്റ്റർ ചെയ്യുക'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, IconData icon, {TextInputType? keyboard, int maxLines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'ഇത് ആവശ്യമാണ്' : null,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
    ),
  );
} 
