import 'dart:math';
import 'package:dayclover/extension/string_extension.dart';
import 'package:dayclover/main_screen.dart';
import 'package:dayclover/service/diary_service.dart';
import 'package:dayclover/service/quote_service.dart';
import 'package:flutter/material.dart';

class PigPage extends StatefulWidget {
  const PigPage({super.key});

  @override
  _PigPageState createState() => _PigPageState();
}

class _PigPageState extends State<PigPage> {
  List<Offset> _bubblePositions = [];
  int? _expandedBubbleIndex;
  String? _diaryContent;
  String? _quoteContent;
  bool _isAnimating = false;
  bool _isLoading = true;

  final List<Color> _bubbleColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final diaryData = await DiaryService().pigAlert();
      final diary = diaryData['res']['diary'];

      if (diary != null && diary.isNotEmpty) {
        setState(() {
          _diaryContent = diary['diary_content'];
          _generateRandomPositions();
        });
      } else {
        final quoteData = await QuoteService().readQuotePig();
        setState(() {
          _quoteContent = quoteData['res']['quote_content'];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateRandomPositions() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    const textAreaHeight = 150.0;

    _bubblePositions = List.generate(
      5,
      (index) => Offset(
        random.nextDouble() * (screenWidth - 100),
        topPadding +
            textAreaHeight +
            random.nextDouble() *
                (screenHeight - textAreaHeight - topPadding - 100),
      ),
    );
  }

  void _onBubbleTap(int index) {
    setState(() {
      _expandedBubbleIndex = index;
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PigPage2(
            diaryContent: _diaryContent ?? "",
            backgroundColor: _bubbleColors[index],
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // 상단 헤더 (뒤로가기 + 텍스트)
                  Positioned(
                    top: topPadding + 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const MainScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '예전 추억을 떠올려 보세요'.insertZwj(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // 오른쪽 여백을 위한 빈 공간
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Quote 표시 (diary가 없을 때)
                  if (_diaryContent == null && _quoteContent != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          _quoteContent!.insertZwj(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  // Bubbles (diary가 있을 때)
                  if (_diaryContent != null)
                    ..._bubblePositions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final position = entry.value;
                      final isExpanded = _expandedBubbleIndex == index;

                      final targetPosition = _expandedBubbleIndex != null
                          ? _bubblePositions[_expandedBubbleIndex!]
                          : position;

                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        left: _isAnimating
                            ? (isExpanded ? -screenWidth : targetPosition.dx)
                            : position.dx,
                        top: _isAnimating
                            ? (isExpanded ? -screenHeight : targetPosition.dy)
                            : position.dy,
                        child: GestureDetector(
                          onTap: () => _onBubbleTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: isExpanded ? screenWidth * 3 : 60,
                            height: isExpanded ? screenHeight * 3 : 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _bubbleColors[index].withOpacity(
                                isExpanded ? 0.8 : (_isAnimating ? 0.0 : 0.4),
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    }),
                ],
              ),
      ),
    );
  }
}

class PigPage2 extends StatelessWidget {
  final String diaryContent;
  final Color backgroundColor;

  const PigPage2({
    super.key,
    required this.diaryContent,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  constraints: BoxConstraints(
                    minHeight: screenHeight,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight / 3),
                      Text(
                        diaryContent,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: topPadding + 16,
              right: 16,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const MainScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: const Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
