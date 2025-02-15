import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/widgets/custom_loader_widget.dart';
import 'package:scaner_test_task/core/widgets/header_widget.dart';
import 'package:scaner_test_task/core/widgets/search_widget.dart';
import 'package:scaner_test_task/features/documents/presentation/cubit/documents_cubit.dart';

import '../../../../core/constants/assets.dart';

import 'widgets/document_card.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  late DocumentsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<DocumentsCubit>(context);
    cubit.loadDocuments();
  }

  Widget _buildContent(BuildContext context, DocumentsState state) {
    if (state is DocumentsInitial) return const SizedBox.shrink();
    if (state is DocumentsLoading) {
      return Center(child: CustomLoaderWidget());
    }
    if (state is DocumentsLoaded) {
      final docsToShow = state.filteredDocuments.isNotEmpty
          ? state.filteredDocuments
          : state.documents;

      if (docsToShow.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: docsToShow.length,
        itemBuilder: (context, index) {
          final document = docsToShow[index];
          return DocumentCard(document: document);
        },
      );
    }

    if (state is DocumentsError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Image.asset(
      AppImageAssets.nothing.asset,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        return RefreshIndicator.adaptive(
          onRefresh: () => cubit.loadDocuments(),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    HeaderWidget(signFontSize: 30.0, itFontSize: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SearchWidget(
                        onChanged: (query) => cubit.searchDocuments(query),
                      ),
                    ),
                    _buildContent(context, state),
                  ],
                ),
              ),
              if (state is DocumentProcessing)
                Center(child: CustomLoaderWidget()),
            ],
          ),
        );
      },
    );
  }
}
