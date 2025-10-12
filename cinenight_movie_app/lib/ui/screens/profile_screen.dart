import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_language.dart';
import 'package:cinenight_movie_app/core/theme/app_text_size.dart';
import 'package:cinenight_movie_app/core/utils/url_laucher_helper.dart';
import 'package:cinenight_movie_app/data/userpref.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/login_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/animated_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_fonts.dart';
import '../../provider/text_size_notifier.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
    String? _name;

    @override
    void initState(){
      super.initState();
      _loadName();
    }

    Future<void> _loadName() async{
      String? name = await Userpref.getName();
      setState(() {
        _name = name;
      });
    }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TextSizeNotifier>();
    final current = notifier.size;

    return Scaffold(
      backgroundColor: AppColors.background2,
      body: SafeArea(
        child: ListView(
          children: [
            // Account title
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: AnimatedText(
                text: "account".tr(),
                style: const TextStyle(
                  color: AppColors.button2,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Account content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.profilecontainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            "assets/images/logo/login.jpg",
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedText(
                          text: "${"wel".tr()},",
                          style: const TextStyle(
                            color: AppColors.button2,
                            fontSize: 16,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AnimatedText(
                          text: " $_name",
                          style: const TextStyle(
                            color: AppColors.button2,
                            fontFamily: AppFonts.montserrat,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (routes) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // General
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: AnimatedText(
                text: "general".tr(),
                style: TextStyle(
                  color: AppColors.button2,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: AppColors.profilecontainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Language
                    ListTile(
                      title: AnimatedText(
                        text: "language".tr(),
                        style: const TextStyle(
                          color: AppColors.button2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: DropdownButton<AppLanguage>(
                        value: languages.firstWhere(
                          (lang) =>
                              lang.api ==
                              context.watch<MovieProvider>().language,
                        ),
                        items: languages.map((lang) {
                          return DropdownMenuItem<AppLanguage>(
                            value: lang,
                            child: Text(
                              lang.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.profiletitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.setLocale((Locale(value.code)));
                            context.read<MovieProvider>().setLanguage(
                              value.api,
                            );
                          }
                        },
                      ),
                    ),

                    const Divider(
                      color: Color.fromARGB(255, 167, 164, 164),
                      height: 1,
                    ),

                    // Text size
                    ListTile(
                      title: AnimatedText(
                        text: "text_size".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.button2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            ChoiceChip(
                              label: Text("small".tr()),
                              selected: current == AppTextSize.small,
                              onSelected: (v) {
                                if (v) notifier.setSize(AppTextSize.small);
                              },
                              selectedColor: AppColors.items,
                              backgroundColor: AppColors.profilecontainer,
                              labelStyle: TextStyle(
                                color: current == AppTextSize.small
                                    ? Colors.white
                                    : AppColors.profiletitle,
                              ),
                            ),
                            ChoiceChip(
                              label: Text("normal".tr()),
                              selected: current == AppTextSize.normal,
                              onSelected: (v) {
                                if (v) notifier.setSize(AppTextSize.normal);
                              },
                              selectedColor: AppColors.items,
                              backgroundColor: AppColors.profilecontainer,
                              labelStyle: TextStyle(
                                color: current == AppTextSize.normal
                                    ? Colors.white
                                    : AppColors.profiletitle,
                              ),
                            ),
                            ChoiceChip(
                              label: Text("large".tr()),
                              selected: current == AppTextSize.large,
                              onSelected: (v) {
                                if (v) notifier.setSize(AppTextSize.large);
                              },
                              selectedColor: AppColors.items,
                              backgroundColor: AppColors.profilecontainer,
                              labelStyle: TextStyle(
                                color: current == AppTextSize.large
                                    ? Colors.white
                                    : AppColors.profiletitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(
                      color: Color.fromARGB(255, 167, 164, 164),
                      height: 1,
                    ),

                    ListTile(
                      title: AnimatedText(
                        text: "invite".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.button2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.profiletitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Support section
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: AnimatedText(
                text: "support".tr(),
                style: const TextStyle(
                  color: AppColors.button2,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: AppColors.profilecontainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: AnimatedText(
                        text: "term".tr(),
                        style: const TextStyle(
                          color: AppColors.button2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.profiletitle,
                      ),
                      onTap: () => UrHelper.launchURL(
                        "https://github.com/VHLuu21/VHLuu21",
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 167, 164, 164),
                      height: 1,
                    ),
                    ListTile(
                      title: AnimatedText(
                        text: "contact".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.button2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.profiletitle,
                      ),
                      onTap: () => UrHelper.launchURL(
                        "https://github.com/VHLuu21/VHLuu21",
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 167, 164, 164),
                      height: 1,
                    ),
                    ListTile(
                      title: AnimatedText(
                        text: "report".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.button2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.profiletitle,
                      ),
                      onTap: () => UrHelper.launchURL(
                        "https://github.com/VHLuu21/VHLuu21",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
