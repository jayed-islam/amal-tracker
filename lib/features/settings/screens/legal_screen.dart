import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ── LEGAL SCREEN (Privacy Policy via Webview) ──────────────────────────────

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  static const String _privacyUrl = 'https://sabeqapp.vercel.app/privacy-policy';
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
            },
          ),
        );

      controller.loadRequest(Uri.parse(_privacyUrl)).catchError((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      });

      setState(() {
        _controller = controller;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _openInExternalBrowser() async {
    final uri = Uri.parse(_privacyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showWebView = _controller != null && !_hasError;

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        backgroundColor: context.colors.darkGreen,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          'গোপনীয়তা নীতি',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded, color: Colors.white),
            tooltip: 'ব্রাউজারে খুলুন',
            onPressed: _openInExternalBrowser,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'পুনরায় লোড করুন',
            onPressed: () {
              if (_controller != null) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _controller!.reload();
              } else {
                _initWebView();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (showWebView) WebViewWidget(controller: _controller!),
          if (_isLoading && showWebView)
            Column(
              children: [
                LinearProgressIndicator(
                  value: _loadingProgress / 100,
                  backgroundColor: context.colors.inputBg,
                  color: context.colors.darkGreen,
                  minHeight: 3,
                ),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.colors.darkGreen,
                    ),
                  ),
                ),
              ],
            ),
          if (!showWebView && !_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: 64,
                      color: context.colors.darkGreen,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'গোপনীয়তা নীতি (Sabeq App)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'অ্যাপটি নতুন রি-বিল্ড সম্পূর্ণ হওয়ার পর ইন-অ্যাপ স্ক্রিনে সম্পূর্ণ পেজ দেখতে পাবেন। আপাতত আপনার ডিভাইসের ব্রাউজারে দেখতে নিচে ক্লিক করুন।',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: context.colors.textBody,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _openInExternalBrowser,
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text('ব্রাউজারে খুলুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            _initWebView();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('পুনরায় চেষ্টা করুন'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.colors.darkGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
