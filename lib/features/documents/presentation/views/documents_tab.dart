import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/widgets/logo_widget.dart';
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
      return Center(child: CircularProgressIndicator());
    }
    if (state is DocumentsLoaded) {
      return state.documents.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.documents.length,
              itemBuilder: (context, index) {
                return DocumentCard(document: state.documents[index]);
              },
            );
    }
    if (state is DocumentsError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox.shrink();
    // return switch (state) {
    //   DocumentsInitial() => const SizedBox.shrink(),
    //   DocumentConvertionProgress() =>
    //     Center(child: CircularProgressIndicator()),
    //   DocumentsLoading() => Center(child: CircularProgressIndicator()),
    //   DocumentProcessing() =>
    //     const SizedBox.shrink(), // Center(child: CircularProgressIndicator()),
    //   DocumentsLoaded() => state.documents.isEmpty
    //       ? _buildEmptyState()
    //       : ListView.builder(
    //           shrinkWrap: true,
    //           padding: EdgeInsets.symmetric(horizontal: 16),
    //           itemCount: state.documents.length,
    //           itemBuilder: (context, index) {
    //             return DocumentCard(document: state.documents[index]);
    //           },
    //         ),
    //   DocumentsError() => Center(child: Text('Error: ${state.message}')),
    // };
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
          child: Column(
            children: [
              LogoWidget(signFontSize: 30.0, itFontSize: 30.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchWidget(
                  onChanged: (query) => cubit.searchDocuments(query),
                ),
              ),
              _buildContent(context, state),
            ],
          ),
        );
      },
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.onChanged});
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(34.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.25),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            weight: 1,
            color: Colors.black.withOpacity(0.25),
          ),
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(34.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
