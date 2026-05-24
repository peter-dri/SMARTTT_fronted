import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_theme.dart';
import 'providers/timetable_provider.dart';

class PortalSyncScreen extends ConsumerStatefulWidget {
  const PortalSyncScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PortalSyncScreen> createState() => _PortalSyncScreenState();
}

class _PortalSyncScreenState extends ConsumerState<PortalSyncScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _statusMessage;
  String _currentUrl = 'https://students.tharaka.ac.ke/pages/SemesterUnitsRegistration';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _statusMessage = 'Loading portal...';
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _statusMessage = null;
              _currentUrl = url;
            });
            // Auto extract if user navigated/redirected to SemesterUnitsRegistration
            if (url.contains('/pages/SemesterUnitsRegistration')) {
              // Wait 1.5 seconds to allow AJAX table loads to render
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (mounted && _currentUrl.contains('/pages/SemesterUnitsRegistration') && !_isSyncing) {
                  _autoExtractUnits(isAuto: true);
                }
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            dev.log('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://students.tharaka.ac.ke/pages/SemesterUnitsRegistration'));
  }

  Future<void> _autoExtractUnits({bool isAuto = false}) async {
    setState(() {
      _isSyncing = true;
      _statusMessage = 'Extracting registered units...';
    });

    try {
      // Robust JavaScript to locate the REGISTERED UNITS heading and grab the table immediately following it
      const jsScript = r'''
        (function() {
          var allElements = document.getElementsByTagName('*');
          var registeredHeader = null;
          
          // 1. Find leaf elements containing text "REGISTERED UNITS:"
          for (var i = 0; i < allElements.length; i++) {
              var el = allElements[i];
              if (el.children.length === 0 && el.innerText && el.innerText.trim().toUpperCase().indexOf('REGISTERED UNITS:') > -1) {
                  registeredHeader = el;
                  break;
              }
          }
          
          // 2. Fallback to any element containing the text
          if (!registeredHeader) {
              for (var i = 0; i < allElements.length; i++) {
                  var el = allElements[i];
                  if (el.innerText && el.innerText.trim().toUpperCase().indexOf('REGISTERED UNITS:') > -1) {
                      registeredHeader = el;
                      break;
                  }
              }
          }

          if (!registeredHeader) return "NOT_FOUND";

          // 3. Find the first table positioned after the header in document order
          var targetTable = null;
          var allTables = document.getElementsByTagName('table');
          for (var i = 0; i < allTables.length; i++) {
              if (registeredHeader.compareDocumentPosition(allTables[i]) & Node.DOCUMENT_POSITION_FOLLOWING) {
                  targetTable = allTables[i];
                  break;
              }
          }

          if (!targetTable) return "NOT_FOUND";

          // 4. Extract rows
          var rows = targetTable.querySelectorAll('tr');
          var extractedData = [];
          var codeRegex = /^[A-Z]{2,4}\s*\d{3,4}[A-Z]?$/i;
          
          for (var i = 0; i < rows.length; i++) {
              var cells = rows[i].querySelectorAll('td');
              if (cells.length >= 2) {
                  var unitCode = null;
                  var unitTitle = null;
                  
                  // Try to find a cell that matches the course code pattern
                  for (var j = 0; j < cells.length; j++) {
                      var text = cells[j].innerText.trim();
                      if (codeRegex.test(text)) {
                          unitCode = text;
                          // If there's a next cell, assume it's the title
                          if (j + 1 < cells.length) {
                              unitTitle = cells[j+1].innerText.trim();
                          }
                          break;
                      }
                  }
                  
                  // Fallback: if no cell matched the regex, check if the first cell is S/No
                  if (!unitCode) {
                      var firstCell = cells[0].innerText.trim();
                      if (/^\d+$/.test(firstCell) && cells.length >= 3) {
                          unitCode = cells[1].innerText.trim();
                          unitTitle = cells[2].innerText.trim();
                      } else {
                          unitCode = firstCell;
                          unitTitle = cells[1].innerText.trim();
                      }
                  }
                  
                  if (!unitCode || unitCode.toLowerCase() === "unit" || unitCode.toLowerCase().indexOf("drop") > -1 || /^\d+$/.test(unitCode)) {
                      continue;
                  }
                  
                  extractedData.push({
                      "unit": unitCode,
                      "title": unitTitle || ""
                  });
              }
          }
          return JSON.stringify(extractedData);
        })();
      ''';

      final result = await _controller.runJavaScriptReturningResult(jsScript);
      
      String decodedResult = result.toString();
      if (decodedResult.startsWith('"') && decodedResult.endsWith('"')) {
        try {
          decodedResult = json.decode(decodedResult);
        } catch (_) {}
      }

      if (decodedResult == 'NOT_FOUND') {
        setState(() {
          _isSyncing = false;
          _statusMessage = null;
        });
        if (!isAuto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registered Units table not found. Please ensure you are on the Units Registration page.'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
        return;
      }

      final List<dynamic> parsed = json.decode(decodedResult);
      final List<String> unitCodes = [];
      for (var item in parsed) {
        if (item is Map && item.containsKey('unit')) {
          unitCodes.add(item['unit'].toString().trim());
        }
      }

      if (unitCodes.isEmpty) {
        setState(() {
          _isSyncing = false;
          _statusMessage = null;
        });
        if (!isAuto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No registered units found on this page.'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
        return;
      }

      setState(() {
        _statusMessage = 'Syncing ${unitCodes.length} units with SMARTTT...';
      });

      // Post to Backend
      final repository = ref.read(timetableRepositoryProvider);
      await repository.syncRegisteredUnits(unitCodes);

      // Refresh Provider
      await ref.read(timetableProvider.notifier).fetchActiveTermAndSchedule();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully synchronized ${unitCodes.length} units!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      dev.log('Extraction/Sync Error: $e');
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _statusMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showInstruction = !_currentUrl.contains('/pages/SemesterUnitsRegistration');

    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: AppTheme.getTextPrimary(context)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Portal Unit Sync',
          style: TextStyle(
            color: AppTheme.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading && !_isSyncing)
            IconButton(
              icon: const Icon(Iconsax.refresh_2),
              tooltip: 'Force check page',
              onPressed: () => _autoExtractUnits(isAuto: false),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (showInstruction)
                Container(
                  color: AppTheme.primary.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Icon(Iconsax.info_circle5, color: AppTheme.primary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please log into the student portal, tap "Academics" -> "Units Registration", then click "Sync Registered Units".',
                          style: TextStyle(
                            color: AppTheme.getTextPrimary(context),
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: WebViewWidget(controller: _controller),
              ),
            ],
          ),
          if (_isLoading || _isSyncing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          _statusMessage ?? 'Loading...',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !showInstruction && !_isLoading && !_isSyncing
          ? FloatingActionButton.extended(
              backgroundColor: AppTheme.primary,
              icon: const Icon(Iconsax.document_download, color: Colors.white),
              label: const Text(
                'Sync Registered Units',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _autoExtractUnits(isAuto: false),
            )
          : null,
    );
  }
}
